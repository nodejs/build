variable "orka_endpoint" {
  type    = string
  default = "http://10.221.190.20"
}

variable "orka_auth_token" {
  type    = string
  default = env("ORKA_AUTH_TOKEN")
  sensitive = true
}
# TODO document how to put this into an environment variable
# orka3 login;ORKA_AUTH_TOKEN=$(orka3 user get-token)

variable "orka_source_image" {
  type    = string
  default = "ghcr.io/macstadium/orka-images/sequoia:15.4.1-no-sip"
}

variable "image_type" {
  type    = string
  default = "test"

  validation {
    condition     = contains(["test", "release"], var.image_type)
    error_message = "Image_type must be either test or release."
  }
}

variable "macos_version" {
  type    = string
  default = "15.4.1"
}

variable "xcode_version" {
  type    = string
  default = "16.4"
}


variable "ssh_default_username" {
  type    = string
  default = "admin"
}

variable "ssh_image_password" {
  type    = string
  default = "admin"
  sensitive = true
}

variable "ssh_new_public_key" {
  type    = string
  default = ""
}

variable "ssh_new_password" {
  type    = string
  default = ""
  sensitive = true
}

variable "architecture" {
  type    = string
  default = "arm64"
  description = "Target architecture for the build (arm64 or x64)"

  validation {
    condition     = contains(["arm64", "x64"], var.architecture)
    error_message = "Architecture must be either arm64 or x64."
  }
}

variable "homebrew_path_map" {
  type = map(string)
  default = {
    "arm64" = "/opt/homebrew"
    "x64" = "/usr/local"
  }
}

locals {
  build_timestamp = formatdate("YYMMDDHHMMss", timestamp())
}

locals {
  homebrew_path = lookup(var.homebrew_path_map, var.architecture, "arm64")
}

packer {
  required_plugins {
    macstadium-orka = {
      version = "~> 3.0"
      source  = "github.com/macstadium/macstadium-orka"
    }
  }
}

source "macstadium-orka" "orka-image" {
  source_image      = var.orka_source_image
  image_name        = "macos-${var.macos_version}-${var.architecture}-${var.image_type}-${local.build_timestamp}"
  image_description = "The MacOS ${var.macos_version} ${var.architecture} ${var.image_type} image"
  orka_endpoint     = var.orka_endpoint
  orka_auth_token   = var.orka_auth_token
  ssh_username      = var.ssh_default_username
  ssh_password      = var.ssh_image_password
  //no_create_image  = true
}


# We build the test image first, then, use the same image to add what we need to the release image.
build {
  name = "test"

  sources = [
    "macstadium-orka.orka-image"
  ]

  // Allow admin to sudo without a password
  provisioner "shell" {
    inline = [
      "echo 'Setting the image type for future shell commands'",
      "echo 'export IMAGE_ARCHITECTURE=\"${var.architecture}\"' >> /Users/admin/.zprofile"
    ]
  }


  // Allow admin to sudo without a password
  provisioner "shell" {
    inline = [
      "echo 'Allowing sudo without password...'",
      "echo ${var.ssh_image_password} | sudo -S id",
      "echo ${var.ssh_image_password} | sudo -S tee /private/etc/sudoers.d/90-nopasswd-admin > /dev/null <<< '%admin ALL=(ALL) NOPASSWD:ALL'",
      "echo ${var.ssh_image_password} | sudo -S chmod 0440 /private/etc/sudoers.d/90-nopasswd-admin",
      "echo ${var.ssh_image_password} | sudo -S visudo -c"
    ]
  }
  // Change the password of the default user.
  provisioner "shell" {
    inline = [
      "echo 'Setting user password...'",
      "sudo sysadminctl -adminUser ${var.ssh_default_username} -adminPassword ${var.ssh_image_password} -resetPasswordFor ${var.ssh_default_username} -newPassword ${var.ssh_new_password}"
    ]
  }
  // Set system hostname.
  provisioner "shell" {
    inline = [
      "echo 'Setting system hostname...'",
      "sudo scutil --set HostName macos-${var.macos_version}-${var.architecture}-test"
    ]
  }
  // Add SSH key access.
  provisioner "shell" {
    inline = [
      "echo 'Adding SSH key access...'",
      "mkdir -p /Users/${var.ssh_default_username}/.ssh",
      "echo '${var.ssh_new_public_key}' >> /Users/${var.ssh_default_username}/.ssh/authorized_keys",
      "chown -R ${var.ssh_default_username}:staff /Users/${var.ssh_default_username}/.ssh",
      "chmod 700 /Users/${var.ssh_default_username}/.ssh",
      "chmod 600 /Users/${var.ssh_default_username}/.ssh/authorized_keys"
    ]
  } 
  // Add GitHub host key to known hosts.
  provisioner "shell" {
    inline = [
      "echo 'Adding GitHub host key to known hosts...'",
      "ssh-keyscan github.com >> /Users/${var.ssh_default_username}/.ssh/known_hosts"
    ]
  }
  // Disable SSH password authentication.
  // @TODO: Review fallback to password authentication.
  provisioner "shell" {
    inline = [
      "echo 'Disabling SSH password authentication...'",
      "sudo sed -i '' 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config",
      "sudo sed -i '' 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config",
      "sudo sed -i '' 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config",
      "sudo sed -i '' 's/^#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config",
      "sudo sed -i '' 's/^ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config",
      "sudo systemsetup -f -setremotelogin on",
      "sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist",
      "sudo launchctl load /System/Library/LaunchDaemons/ssh.plist",
    ]
  }

  // Install Homebrew.
  provisioner "shell" {
    inline = [
      "echo 'Installing Homebrew...'",
      "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"",
      "eval \"$(${local.homebrew_path}/bin/brew shellenv)\"",
      "(echo; echo 'eval \"$(${local.homebrew_path}/bin/brew shellenv)\"') >> /Users/admin/.zprofile",
      "eval \"$($(${local.homebrew_path}/bin/brew --prefix)/bin/brew shellenv)\""
    ]
  }
  // Ensure Homebrew environment is set up in the shell profile.
  provisioner "shell" {
    inline = [
      "echo 'Setting up Homebrew environment in shell profile...'",
      "echo 'eval \"$(${local.homebrew_path}/bin/brew shellenv)\"' >> /Users/admin/.zshrc",
      "echo 'eval \"$(${local.homebrew_path}/bin/brew shellenv)\"' >> /Users/admin/.bash_profile"
    ]
  }
  // Check Homebrew. Ignore errors because we are not using the last version of Xcode.
  provisioner "shell" {
    inline = [
      "echo 'Checking Homebrew...'",
      "eval \"$(${local.homebrew_path}/bin/brew shellenv)\"",
      "${local.homebrew_path}/bin/brew doctor || true"
    ]
  }
  // Create symlink for Homebrew to /usr/local/bin for legacy script compatibility.
  provisioner "shell" {
    inline = [
      "echo 'Creating Homebrew compatibility symlink...'",
      # Check if the path exists and is not already a symlink to avoid errors on reruns
      "if [ ! -L /usr/local/bin ]; then sudo ln -s ${local.homebrew_path}/bin /usr/local/bin; fi"
    ]
  }
  // Install dependencies for build and test.
  provisioner "shell" {
    inline = [
      "echo 'Installing packages using Homebrew...'",
      "eval \"$(${local.homebrew_path}/bin/brew shellenv)\"",
      "${local.homebrew_path}/bin/brew install git automake bash libtool cmake python ccache xz pipx orka-vm-tools"
    ]
  }

  // Install tap2junit using pipx for better isolation.
  provisioner "shell" {
    environment_vars = ["HOME=/Users/admin", "USER=admin"]
    inline = [
      "echo 'Installing tap2junit using pipx...'",
      "eval \"$(${local.homebrew_path}/bin/brew shellenv)\"",
      "${local.homebrew_path}/bin/pipx install tap2junit",
      // This command automatically adds the pipx path to the user's profile
      "${local.homebrew_path}/bin/pipx ensurepath"
    ]
  }
  // Install Java 17 for Jenkins.
  provisioner "shell" {
    inline = [
      "echo 'Installing JRE...'",
      "eval \"$(${local.homebrew_path}/bin/brew shellenv)\"",
      "${local.homebrew_path}/bin/brew install --cask temurin@17",
    ]
  }
  // Print the version of the installed packages.
  provisioner "shell" {
    inline = [
      "echo 'Printing the version of the installed packages...'",
      "eval \"$(${local.homebrew_path}/bin/brew shellenv)\"",
      "${local.homebrew_path}/bin/brew list --versions",
      "java -version",
      // @TODO: Solve the problem with the Xcode version.
      //"xcodebuild -version"
    ]
  }
  // Configure ccache to use a shared directory and enable path integration.
  provisioner "shell" {
    inline = [
      "echo 'Configuring ccache...'",
      "mkdir -p /Users/admin/.ccache",

      # Use an HCL heredoc (<<-EOT) to pass a multi-line script to the shell.
      # The shell will then execute its own heredoc (cat <<'EOF').
      <<-EOT
        cat <<'EOF' > /Users/admin/.ccache/ccache.conf
        # This file is managed by Packer.
        # Set the cache directory to a shared volume provided by the CI system.
        remote_only = true
        remote_storage = file:/Volumes/orka/ccache_${var.architecture}|umask=002
        debug = false
        debug_dir = /Users/admin/.ccache/debug
        debug_level = 2
        EOF
      EOT
      , # Note the comma here to separate elements in the HCL list

      "chown -R admin:staff /Users/admin/.ccache",

      # Add ccache to the PATH in .zprofile for login shells (which CI uses).
      # This makes 'cc' an alias for 'ccache cc', etc.
      "echo 'export PATH=\"${local.homebrew_path}/opt/ccache/libexec:$PATH\"' >> /Users/admin/.zprofile"
    ]
  }

   provisioner "file" {
     source = "files/com.mount9p.plist"
     destination = "/Users/admin/com.mount9p.plist"
   }

   // Set permissions on the shared filesystem launch daemon
   provisioner "shell" {
     inline = [
       "source /Users/admin/.zprofile",
       "if [ $IMAGE_ARCHITECTURE = x64 ]; then",
       "sudo mv /Users/admin/com.mount9p.plist /Library/LaunchDaemons/com.mount9p.plist",
       "sudo chown root:wheel /Library/LaunchDaemons/com.mount9p.plist",
       "sudo chmod 600 /Library/LaunchDaemons/com.mount9p.plist",
       "else",
       "echo 'Skipping 9p mount setup'",
       "fi"
     ]
   }

   // Fix admin user on intel builds so that they can use the shared ccache.
  provisioner "shell" {
    script = "files/admin_uid_change.sh"
    execute_command = "chmod +x {{ .Path }}; sudo -E /bin/bash -x {{ .Path }}"
  }

}
