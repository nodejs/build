Node.js Build Working Group
===========================

Chat with us! We use IRC: [#node-build at Freenode](irc://irc.freenode.net/node-build)

Wut?
----

This repository contains information used to set up and maintain the **Node.js** and **libuv** CI infrastructure. It is intended to be open and transparent, if you see any relevant information missing please open an issue.

Infrastructure Providers
------------------------

The Node.js Foundation is proud to receive contributions from many companies, both in the form of monetary contributions in exchange for membership or in-kind contributions for required resources. The Build Working Group collaborates with the following companies who contribute various kinds of cloud and physical hardware to the Node.js project.

### Tier-1 Providers

The Node.js Foundation's tier-1 infrastructure providers contribute the largest share of infrastructure to the Node.js project. Without these companies, the project would not be able to provide the quality, speed and availability of test coverage that it does today.

![Tier 1 Infrastructure Providers](./provider-logos/tier-1-providers.png)

**[DigitalOcean](http://digitalocean.com/)**, a popular cloud hosting service, provide a significant amount of the resources required to run the Node.js project including key CI infrastructure and servers required to host [nodejs.org](https://nodejs.org/).

**[Rackspace](https://www.rackspace.com/)**, a popular managed cloud company, provide significant resources used to power much of the Node.js project's CI system, including key Windows compilation servers, along with additional services such as object storage for backups via [Cloud Files](http://www.rackspace.com/en-au/cloud/files) and [Mailgun](http://www.mailgun.com/) for some [nodejs.org email](https://github.com/nodejs/email) services.

### Tier-2 Providers

The Node.js Foundation's tier-2 infrastructure providers fill essential gaps in architecture and operating system variations and shoulder some of the burden from the tier-1 providers, contributing to availability and speed in our CI system.

![Tier 2 Infrastructure Providers](./provider-logos/tier-2-providers.png)

**[Microsoft Azure](https://azure.microsoft.com/en-us/)**, a cloud services platform, provide Windows test infrastructure for the Node.js CI system.

**[Joyent](https://www.joyent.com/)**, a public/private cloud infrastructure company, provide SmartOS test and build resources for the Node.js CI system.

**[IBM](https://www.ibm.com/)**, via their cloud company, [SoftLayer](https://www.softlayer.com/) and the [Oregon State University Open Source Lab](https://osuosl.org/services/powerdev) provide PPC-based test and build infrastructure and other key hardware for testing and benchmarking for the Node.js project's CI system.

**[Voxer](https://voxer.com/)**, a voice, text, photo and video messaging service and well-known Node.js early-adopter provide and host OS X hardware for building and testing via the Node.js project's CI 
system.

**[Scaleway](https://www.scaleway.com/)**, a "BareMetal" SSD cloud server provider, contributes key ARMv7 hardware for test and build for the Node.js CI system.

**[NodeSource](https://nodesource.com/)**, a Node.js enterprise products and services company, donate hardware and hosting for most of the Node.js project's ARM test and build infrastructure.

**[CloudFlare](https://www.cloudflare.com/)**, a CDN and internet traffic management provider, are responsible for providing fast and always-available access to [nodejs.org](https://nodejs.org).

**[ARM](https://www.arm.com/)**, semiconductor intellectual property supplier, have donated ARMv8 hardware for use by the Node.js CI system for build and testing Node.js.

CI Software
-----------

Build and test orchestration is performed by [Jenkins](http://jenkins-ci.org).

* A summary of build and test jobs can be found at: <https://ci.nodejs.org>
* A listing of connected servers for testing, building and benchmarking can be found at: <http://ci.nodejs.org/computer/>


People
------

* Johan Bergström [@jbergstroem](https://github.com/jbergstroem)
* João Reis [@joaocgreis](https://github.com/joaocgreis)
* Rod Vagg [@rvagg](https://github.com/rvagg)
* Alexis Campailla [@orangemocha](https://github.com/orangemocha)
* Michael Dawson [@mhdawson](https://github.com/mhdawson)
* Hans Kristian Flaatten [@Starefossen](https://github.com/Starefossen)
* Julien Gilli [@misterdjules](https://github.com/misterdjules)
* Rich Trott [@trott](https://github.com/trott)
* Myles Borins [@thealphanerd](https://github.com/thealphanerd)
