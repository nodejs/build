# Recreating the AWX server

First step is to run the AWX playbook:

```sh 
$ ansible-playbook playbooks/create-awx.yml
```

_note_: the playbook is currently targeted against `infra-ibm-ubuntu2004-x64-1` so if that changes don't forget to update the playbook

# Manual Setup

## Authentication

To setup the authentication for AWX you need the GitHub OAuth credentials which can be found in the secrets repo (Infra level).

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

## Permissions

Unfortunatly you have to give everyone elevated permissions manually - there isnt a way to do this automatically that fits our use case. Best way to do this is to let the user log in so their profile is automatically created, then you can assign them roles/teams as fitting - Make sure you set the members of the build team as system administrators.

### Teams 

You can then create teams where you can set the levels of permissions - ensure the build helper team is set with permissions that they can see the inventories and exectute the playbooks - ensure they are only given the `use` permission for credentials and nothing higher. Once the teams are set up you can just add the user to the respective team which saves have to manually give them every permission.

## Credentials 

Any member of the build can upload the keys for the test machines as they have the access to the keys. Ensure you name it correctly after the key and select `machine` type credential.

## Creating templates

You can add job templates through the UI using the playbook dropdown that appears when you select the `nodejs/build` project, ensure you select the right inventory and that both `credentials` and `limit` are set to `prompt on launch` to prevent the jobs been run against all hosts at once.

## Inventories

Sometimes on creation the inventory doesn't load properly - to fix this navigate to `inventories` -> `nodejs_inventory_github`, click on `source` and hit the `start sync process` button. This should refresh the inventory and populate the hosts. To ensure it has worked navigate back to the `dashboard` and there should be ~160 `hosts` shown.
