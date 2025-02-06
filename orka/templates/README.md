# Using Packer with Orka

## Pre-requisites

You need to install Packer in your local machine. You can find the installation instructions [here](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli).

Once installed, you can verify the installation by running the following command:

```shell
packer --version
```

While writing this document, the latest version of Packer is `1.11.2`.

## Install dependencies

You need to run the following command to install the dependencies:

```shell
packer init .
```

## Access the Orka environment

You need to connect to the Orka VPN. You can find the instructions in the secrets repository. 

## Load the environment variables

You need to load the environment variables:

1. Get the `.env` file from the secrets repository. You will find the instructions in the repository.
2. Copy the `.env` file to this directory.
3. Run the following command:
    ```shell
    source .env
    ```
4. Verify that the environment variables are loaded by running the following command:
    ```shell
    echo $ORKA_ENDPOINT
    echo $ORKA_AUTH_TOKEN
    echo $SSH_DEFAULT_USERNAME
    echo $SSH_DEFAULT_PASSWORD
    echo $SSH_TEST_PASSWORD
    echo $SSH_TEST_PUBLIC_KEY
    ```

## Validate the template

You can validate a specific template by running the following command:

```shell
packer validate -var "orka_endpoint=$ORKA_ENDPOINT" -var "orka_auth_token=$ORKA_AUTH_TOKEN" -var "ssh_default_username=$SSH_DEFAULT_USERNAME" -var "ssh_default_password=$SSH_DEFAULT_PASSWORD" -var "ssh_test_password=$SSH_TEST_PASSWORD" -var "ssh_release_password=$SSH_RELEASE_PASSWORD" -var "ssh_release_public_key=$SSH_RELEASE_PUBLIC_KEY" -var "ssh_test_public_key=$SSH_TEST_PUBLIC_KEY" <template_name>
```

## Build the image

You can build a specific template by running the following command:

```shell
packer build -var "orka_endpoint=$ORKA_ENDPOINT" -var "orka_auth_token=$ORKA_AUTH_TOKEN" -var "ssh_default_username=$SSH_DEFAULT_USERNAME" -var "ssh_default_password=$SSH_DEFAULT_PASSWORD" -var "ssh_test_password=$SSH_TEST_PASSWORD" -var "ssh_release_password=$SSH_RELEASE_PASSWORD" -var "ssh_release_public_key=$SSH_RELEASE_PUBLIC_KEY" -var "ssh_test_public_key=$SSH_TEST_PUBLIC_KEY" <template_name>
```

## Continuous Integration

The templates are initialized and validated in the CI pipeline using GitHub Actions. The pipeline runs on every push to the repository that modifies the templates. You can find the pipeline in the `.github/workflows/orka-templates.yml` directory.

We don't plan to build the images in the CI pipeline. The images are built manually by the team once the PRs are merged or just before merged. 

## Adding new images

Orka provides a base image that we need to customize to our needs. 

1. find the image that you want to extend by running the following command:
    ```shell
    orka3 remote-image list
    ```
2. pull the image by running the following command:
    ```shell
    orka3 remote-image pull <image_name>
    ```
    Note: this can take a while, use `orka3 image list <image_name>` to check the progress of the image. Wait until the image is in status `Ready`.

3. Create a new vm from the image by running the following command:
    ```shell
    orka3 vm deploy -i <image_name>
    ```
4. Access the vm using vnc and then do the following manual steps (see setion below). The credentials can be found in the secrets repository.
5. Save the vm as a new image by running the following command:
    ```shell
    orka3 vm save <vm_name> <new_image_name>
    ```
    Note: Don't stop the vm and use this pattern: `macos13-intel-base.img` or `macos13-arm-base.orkasi` for the image name. The generation can take a while.
6. Delete the vm by running the following command:
    ```shell
    orka3 vm delete <vm_name>
    ```
    Note: Don't delete the vm until you have saved the image, check by running the command `orka3 image list`



### Manual Steps for all the images

1. Update Sudoers file:

this requires `NOPASSWD` to be added to the sudoers file to enable elevation

`sudo visudo`
and change:
`%admin          ALL = (ALL) ALL`
to
`%admin          ALL = (ALL) NOPASSWD:ALL`

2. Allow ssh access

```bash
sudo systemsetup -setremotelogin on
```
3. Install xcode

```bash
sudo xcode-select --install
```

Do a an update using the UI. Check the available updates and install them (click in "more info"). Note that you don't want to update the OS, just the software.

### Manual Steps for the release images

1. Full Xcode installation

    Xcode Command-line tools are not enough to perform a full notarization cycle, full Xcode must be installed manually.

    As root:

    * Download Xcode: https://developer.apple.com/download/more/ - find non-beta version, open Developer Tools in browser, Networking tab, start download (then cancel), in Networking tab "Copy as cURL" (available in Chrome & FF)
        * On OSX 13 we currently install 14.13.1.
    * Go to downloads folder, decompress the xip file (double click) and delete the xip file
    * Move the Xcode.app to /Applications
    * Open xcode, accept the license, install the built-in components and close xcode
    * `sudo xcode-select --switch /Applications/Xcode.app`
    * `sudo xcodebuild -license` - accept license
    * `git` - check that git is working (confirming license has been accepted)
    * Empty the trash


2. OSX Keychain Profile

    Unblok the keychain:

    ```bash
    security unlock-keychain -u /Library/Keychains/System.keychain
    ```

    Create a keychain profile (`NODE_RELEASE_PROFILE`) for the release machine: 

    ```bash
    sudo xcrun notarytool store-credentials NODE_RELEASE_PROFILE \
    --apple-id XXXX \
    --team-id XXXX \
    --password XXXX \
    --keychain /Library/Keychains/System.keychain  
    ```

    Note: `XXXX` values are found in `secrets/build/release/apple.md`

    The expected output is:

    ```
    This process stores your credentials securely in the Keychain. You reference these credentials later using a profile name.

    Validating your credentials...
    Success. Credentials validated.
    Credentials saved to Keychain.
    To use them, specify `--keychain-profile "NODE_RELEASE_PROFILE" --keychain /Library/Keychains/System.keychain`
    ```

3. Signing certificates

    * Go to the `build/release` folder in the secrets repo.
    * Extract from secrets/build/release: `dotgpg cat Apple\ Developer\ ID\ Node.js\ Foundation.p12.base64 | base64 -D > /tmp/Apple\ Developer\ ID\ Node.js\ Foundation.p12`
    * Transfer to release machine (scp to /tmp)
    * `sudo security import /tmp/Apple\ Developer\ ID\ Node.js\ Foundation.p12 -k /Library/Keychains/System.keychain -T /usr/bin/codesign -T /usr/bin/productsign -P 'XXXX'` (where XXXX is found in secrets/build/release/apple.md) (`security unlock-keychain -u /Library/Keychains/System.keychain` _may_ be required prior to running this command).

4. Validating certificates are in date and valid

    1. `security -i unlock-keychain` Enter the password for the machine located in secrets
    2. `security find-certificate -c "Developer ID Application" -p > /tmp/app.cert` outputs the PEM format of the cert so we can properly inspect it
    3. `security find-certificate -c "Developer ID Installer" -p > /tmp/installer.cert`
    4. `openssl x509 -inform PEM -text -in /tmp/app.cert | less`
    5. `openssl x509 -inform PEM -text -in /tmp/installer.cert | less`
    6. `security find-identity -p codesigning -v`

    The steps 4 and 5 will show the details of the certificates allowing to see expiry dates.

    Example:

    ```
    Not Before: Jan 22 03:40:05 2020 GMT
    Not After : Jan 22 03:40:05 2025 GMT
    ```

    The step 6 will show the list of certificates available on the machine.

    Example:

    ```
    1) XXXXXXXXXXX "Developer ID Application: Node.js Foundation (XXXXXXX)"
    1 valid identities found
    ```

5. Change the default password

    Use the password found in the secrets repository to change the default password:

    ```shell
    passwd
    ```

    Also change the keychain password:

    ```shell
    security set-keychain-password
    ```

    **:warning: IMPORTANT** We do this step manually at this point and not while using Packer because we added already sensitive information to the image.