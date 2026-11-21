# StatusPage

This document relates to the [StatusPage](https://www.statuspage.io/) for Node.js, which can be
found at [status.nodejs.org](https://status.nodejs.org).

## Access

The following people have access to the StatusPage control panel. New accounts can be added via the
[User Management](https://admin.atlassian.com/s/f6b1a2fe-1302-40aa-9a3f-4f7523370639/users) page.

Atlassian StatusPage has three groups available, `site-admins` that have full administration access
in Atlassian, `statuspage-administrators` that have full administration access specifically for the
StatusPage product, and `statuspage-users` who have regular operational access to StatusPage.

Atlassian organizations also have a separate concept of org-wide administrators, that have full
access to everything (this is technically different from `site-admins` as that is scoped to the
"site", but this org only has one site, so they are effectively the same).

| GitHub                                         | Site Role          | Org Admin |
|------------------------------------------------|--------------------|-----------|
| [@MattIPv4](https://github.com/MattIPv4)       | `site-admins`      | Yes       |
| OpenJSF Operations                             | `site-admins`      | Yes       |
| [@MylesBorins](https://github.com/MylesBorins) | `statuspage-users` | No        |

## Twitter

There is also a Twitter account, [@NodejsStatus](https://twitter.com/NodejsStatus), for the
status page.

This account is run via the
[Twitter integration](https://manage.statuspage.io/pages/rxy2rhgm8q1n/twitter) on StatusPage and
will automatically tweet any incident updates (if tweeting is selected for an incident update).

## Customisations

The [statuspage](../statuspage) directory in this repository contains a backup of the major
customisations applied to the Node.js status page. These should be updated whenever the
customisations are changed on the status page.

[colors.md](../statuspage/colors.md) contains the custom color set for the whole status page
(including emails for subscribers) in
[Your Page > Customize page and emails > Colors](https://manage.statuspage.io/pages/rxy2rhgm8q1n/design#colors-container).

[styles.scss](../statuspage/styles.scss) stores the custom styling that is applied to all web pages
of the Node.js StatusPage site. This is controlled from the
[Customize HTML & CSS](https://manage.statuspage.io/pages/rxy2rhgm8q1n/full-customize) view
accessed from the button top-right on
[Your Page > Customize page and emails > Customize status page](https://manage.statuspage.io/pages/rxy2rhgm8q1n/design#design-container).

[header.html](../statuspage/header.html) contains the custom HTML used for the header on the
status page. It is important to note that this replaces the default header (logo & subscribe
button), so using this should be avoided if possible. Like the custom styling, this is managed from
the [Customize HTML & CSS](https://manage.statuspage.io/pages/rxy2rhgm8q1n/full-customize) page.

[footer.html](../statuspage/footer.html) contains custom HTML injected into the footer of the
status page website. This doesn't replace any default content and is a good place for custom
scripting if needed. This is also controlled from the
[Customize HTML & CSS](https://manage.statuspage.io/pages/rxy2rhgm8q1n/full-customize) page.
