# Using Packer with Orka

## Pre-requisites

You need to install Packer in your local machine. You can find the installation instructions [here](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli).

Once installed, you can verify the installation by running the following command:

```shell
packer --version
```

While writing this document, the latest version of Packer is `1.14.2`.

## Install dependencies

You need to run the following command to install the dependencies:

```shell
packer init .
```

## Access the Orka environment

1. You need to connect to the Orka VPN. You can find the instructions in the secrets repository. @TODO
2. Authenticate the cluster with `orka3 login` -> this will give a url to access to login to macstadium. This login lasts for 3600s. 
3. Once logged into macstadium, you can `orka3 user get-token` to get a user token to do other things, like build images. 

## Authenticate to ghcr.io

Some Macstadium base images are stored at ghcr.io (github's container registry).  To allow packer to seamlessly pull
those images, you must provide the orka3 cli with a github personal access token (PAT). See [here]https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic
```
orka3 regcred add https://ghcr.io --username GITHUB_USERNAME --password PAT_TOKEN
```

## Load the build variables

You need to configure the variables.auto.pkrvars.hcl file

1. Get the `orka.variables.auto.pkrvars.hcl` file from the secrets repository. There is one in release, and one in test
2. Copy the `orka.variables.auto.pkrvars.hcl` to `variables.auto.pkrvars.hcl` file to this directory.

## Load the file secrets

We need the private key for node-www for the release images, as well as the apple developer certificate for code signing.

1. Copy the `secrets/build/release/staging_id_rsa_private.key` to orka/templates/files/secrets/id_rsa
2. Go to the `build/release` folder in the secrets repo 
3. Extract from secrets/build/release and put it in this repo (adjust the orka path in this command): `dotgpg cat Apple\ Developer\ ID\ Node.js\ Foundation.p12.base64 | base64 -D > orka/templates/files/secrets/Apple\ Developer\ ID\ Node.js\ Foundation.p12`

## Download Xcode to the shared vm storage

1. Full Xcode installation

    Xcode Command-line tools are not enough to perform a full notarization cycle, full Xcode must be fully installed on the release images.

    * Login to https://developer.apple.com using the apple-operations@openjsf.org account
    * Download Xcode: https://developer.apple.com/download/more/ - find non-beta version, open Developer Tools in browser, Networking tab, start download (then cancel), in Networking tab "Copy as cURL" (available in Chrome & FF)
        * On OSX 15 we currently install 16.4
    * Manually launch one of the existing VM's (Arm ones are faster)
      * `orka3 images list` to see available images
      * `orka3 vm deploy --image IMAGE_NAME` to deploy a new image
      * NOTE: don't try to connect to an existing image as jenkins may delete it while you're working on it.
    * Connect to the VM with ssh, and navigate to /Volumes/orka/Xcode
      * use orkaconnect.sh VM_NAME (ie. `orkaconnect.sh vm-h1tcv`)
    * Execute the curl command to download Xcode, save it to a file named Xcode_{VERSION}.xip i.e. Xcode_16.4.xip 
      * This is where packer will look when installing xcode in the image. 

## Validate the template

You can validate a specific template by running the following command (replace test with release if doing release images)

```shell
ORKA_AUTH_TOKEN=$(orka3 user get-token) packer validate -var-file=variables.auto.pkrvars.hcl macos-test.pkr.hcl
 ```

## Build the image

You can build a specific template by running the following command:

```shell
ORKA_AUTH_TOKEN=$(orka3 user get-token) packer build -var-file=variables.auto.pkrvars.hcl macos-test.pkr.hcl
```

## Continuous Integration

The templates are initialized and validated in the CI pipeline using GitHub Actions. The pipeline runs on every push to the repository that modifies the templates. You can find the pipeline in the `.github/workflows/orka-templates.yml` directory.

We don't plan to build the images in the CI pipeline. The images are built manually by the team once the PRs are merged or just before merged. 

## Adding new images

Orka provides a base image that we need to customize to our needs. 

Note that orka3 remote-image command is only for interacting with x64 images. arm64 images are at ghcr.io: https://github.com/macstadium/orka-images

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
