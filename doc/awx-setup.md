# Recreating the AWX server

First step is to run the AWX playbook:

```sh 
$ ansible-playbook playbooks/create-awx.yml
```

_note_: the playbook is currently targeted against `infra-ibm-ubuntu2004-x64-1` so if that changes don't forget to update the playbook

# Manual Setup

## Authentication

To setup the authentication for AWX you need the github OAuth credentials which can be found in the secrets repo (Infra level).

Under `Settings` -> `GitHub Settings`, click on the `GitHub Organization` tab and then the edit button.

These are the follow fields you need to fill in:

 - OAuth2 key: `in $secrets`

 - OAuth2 secret: `in $secrets`

 - GitHub Organization Name: `nodejs`

 - Organization Map: 
    ```
    {
    "nodejs": {
        "admins": false
        }
    }
    ```

- Team Map: 

    ```
    {
    "nodejs": {
        "organization": "nodejs",
        "users": true,
        "remove": false
        }
    }
    ```
