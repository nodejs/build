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
  default = ""
}

variable "xcode_version" {
  type    = string
  default = null
}

variable "ssh_default_username" {
  type    = string
  default = "admin"
}

# The password to access the image via ssh
variable "ssh_image_password" {
  type    = string
  default = "admin"
  sensitive = true
}

# The public key we will put on the image for future access
variable "ssh_new_public_key" {
  type    = string
  default = ""
}

# The password that gets assigned to the image for future access
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

# The password that gets assigned to the image for future access
variable "apple_signing_password" {
  type    = string
  default = ""
  sensitive = true
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
  //no_delete_vm      = true
}


# The release images are based on the test images.
build {
  name = "release"

  sources = [
    "macstadium-orka.orka-image"
  ]

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
      "sudo scutil --set HostName macos-${var.macos_version}-${var.architecture}-release"
    ]
  }
  // Change ssh key to the release key to reduce the number of amount of granted access.
  provisioner "shell" {
    inline = [
      "echo 'Adding SSH key access...'",
      "echo '${var.ssh_new_public_key}' >> /Users/${var.ssh_default_username}/.ssh/authorized_keys",
      "chown -R ${var.ssh_default_username}:staff /Users/${var.ssh_default_username}/.ssh",
      "chmod 700 /Users/${var.ssh_default_username}/.ssh",
      "chmod 600 /Users/${var.ssh_default_username}/.ssh/authorized_keys"
    ]
  }

  // Add direct.nodejs.org host key to known hosts.
  provisioner "shell" {
    inline = [
      "echo 'Adding direct.nodejs.org host key to known hosts...'",
      "ssh-keyscan direct.nodejs.org >> /Users/${var.ssh_default_username}/.ssh/known_hosts"
    ]
  }



  // Set the default keychain password and unlock it
  provisioner "shell" {
    inline = [
      "echo 'Setting default keychain password'",
      "security set-keychain-password -o admin -p ${var.ssh_new_password}",
      "security unlock-keychain -p ${var.ssh_new_password}",
    ]
  }


  // Configure Notarytool to use the nodejs profile
  provisioner "shell" {
    inline = [
      "echo 'Configuring notarytool profile'",
      "security unlock-keychain -u /Library/Keychains/System.keychain",
      "sudo xcrun notarytool store-credentials NODE_RELEASE_PROFILE --apple-id apple-operations@openjsf.org --team-id HX7739G8FX --password ${var.apple_signing_password} --keychain /Library/Keychains/System.keychain"
    ]
  }// Configure Notarytool to use the nodejs profile
  provisioner "shell" {
    inline = [
      "security unlock-keychain -p ${var.ssh_new_password}",
      "echo 'Proving notarytool works'",
      "xcrun notarytool history --keychain-profile NODE_RELEASE_PROFILE"
    ]
  }

  # Upload cert file
  provisioner "file" {
    source      = "files/secrets/Apple Developer ID Node.js Foundation.p12"
    destination = "/tmp/applecert.p12"
  }

  # Add ssh config for node-www
  provisioner "file" {
    source      = "files/ssh_config.txt"
    destination = "/Users/admin/.ssh/config"
  }

  # Add id_rsa key so builds can publish to node-www
  provisioner "file" {
    source      = "files/secrets/id_rsa"
    destination = "/Users/admin/.ssh/id_rsa"
  }
  # Fix permissions on id_rsa (must be 600 for SSH to use it)
  provisioner "shell" {
    inline = [
      "chmod 600 /Users/admin/.ssh/id_rsa"
    ]
  }

  provisioner "shell" {
     inline = [
      "security unlock-keychain -p ${var.ssh_new_password}",
      "sudo security import /tmp/applecert.p12  -k /Library/Keychains/System.keychain -P ${var.apple_signing_password} -T /usr/bin/codesign -T /usr/bin/productsign"
    ]
  }

  // Install rosetta on arm images so we can build universal binaries.
   provisioner "shell" {
     inline = [
       "source /Users/admin/.zprofile",
       "if [ $IMAGE_ARCHITECTURE = arm64 ]; then",
       "sudo /usr/sbin/softwareupdate --install-rosetta --agree-to-license",
       "else",
       "echo 'Skipping rosetta installation'",
       "fi"
     ]
   }
  // Xcode versions should be manually downloaded to (example) /Volumes/orka/xcode/Xcode_16.4.xip
  provisioner "shell" {
    script = "files/update_xcode.sh"
    execute_command = "chmod +x {{ .Path }}; sudo -E sh {{ .Path }} ${var.xcode_version}"
  }

}
