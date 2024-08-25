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
    echo $SSH_USERNAME
    echo $SSH_PASSWORD
    ```

## Validate the template

You can validate all the templates by running the following command:

```shell
packer validate -var "orka_endpoint=$ORKA_ENDPOINT" -var "orka_auth_token=$ORKA_AUTH_TOKEN" -var "ssh_username=$SSH_USERNAME" -var "ssh_password=$SSH_PASSWORD" .
```

You can validate a specific template by running the following command:

```shell
packer validate -var "orka_endpoint=$ORKA_ENDPOINT" -var "orka_auth_token=$ORKA_AUTH_TOKEN" -var "ssh_username=$SSH_USERNAME" -var "ssh_password=$SSH_PASSWORD" <template_name>
```

## Build the image

You can build all the templates by running the following command:

```shell
packer build -var "orka_endpoint=$ORKA_ENDPOINT" -var "orka_auth_token=$ORKA_AUTH_TOKEN" -var "ssh_username=$SSH_USERNAME" -var "ssh_password=$SSH_PASSWORD" .
```

You can build a specific template by running the following command:

```shell
packer build -var "orka_endpoint=$ORKA_ENDPOINT" -var "orka_auth_token=$ORKA_AUTH_TOKEN" -var "ssh_username=$SSH_USERNAME" -var "ssh_password=$SSH_PASSWORD" <template_name>
```

## Continuous Integration

The templates are initialized and validated in the CI pipeline using GitHub Actions. The pipeline runs on every push to the repository that modifies the templates. You can find the pipeline in the `.github/workflows/orka-templates.yml` directory.

We don't plan to build the images in the CI pipeline. The images are built manually by the team once the PRs are merged or just before merged. 