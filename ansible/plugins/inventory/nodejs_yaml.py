#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright Node.js contributors. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#

import argparse
try:
    import configparser
except ImportError:
    import ConfigParser as configparser
try:
    from itertools import ifilter
except ImportError:
    from itertools import filter as ifilter
import json
import yaml
import os
import sys


valid = {
  # taken from nodejs/node.git: ./configure
  'arch': ('armv6l', 'armv7l', 'arm64', 'ia32', 'mips', 'mipsel', 'ppc',
           'ppc64', 'x32', 'x64', 'x86', 's390', 's390x'),

  # valid roles - add as necessary
  'type': ('infra', 'release', 'test'),

  # providers - validated for consistency
  'provider': ('azure', 'digitalocean', 'joyent', 'ibm', 'linuxonecc',
               'macstadium', 'marist', 'mininodes', 'msft', 'osuosl',
               'rackspace', 'requireio', 'scaleway', 'softlayer', 'voxer',
               'packetnet', 'nearform')
}

# customisation options per host:
#
# - ip [string] (required): ip address of host
# - alias [string]: 'nickname', will be used in ssh config
# - labels [sequence]: passed to jenkins
#
# parsing done on host naming:
#
# - *freebsd*: changes path to python interpreter
# - *smartos*: changes path to python interpreter
#
# @TODO: properly support --list and --host $host


def main():

    hosts = {}
    export = {'_meta': {'hostvars': {}}}

    # get inventory
    with open("inventory.yml", 'r') as stream:
        try:
            hosts = yaml.load(stream)

        except yaml.YAMLError as exc:
            print(exc)
        finally:
            stream.close()

    # get special cases
    config = configparser.ConfigParser()
    config.read('ansible.cfg')

    for host_types in hosts['hosts']:
        for host_type, providers in host_types.iteritems():
            export[host_type] = {}
            export[host_type]['hosts'] = []

            key = '~/.ssh/nodejs_build_%s' % host_type
            export[host_type]['vars'] = {
                'ansible_ssh_private_key_file': key
            }

            for provider in providers:
                for provider_name, hosts in provider.iteritems():
                    for host, metadata in hosts.iteritems():

                        # some hosts have metadata appended to provider
                        # which requires underscore
                        delimiter = "_" if host.count('-') is 3 else "-"
                        hostname = '{}-{}{}{}'.format(host_type, provider_name,
                                                      delimiter, host)

                        export[host_type]['hosts'].append(hostname)

                        c = {}

                        try:
                            parsed_host = parse_host(hostname)
                            for k, v in parsed_host.iteritems():
                                c.update({k: v[0] if type(v) is dict else v})
                        except Exception, e:
                            raise Exception('Failed to parse host: %s' % e)

                        c.update({'ansible_host': metadata['ip']})

                        if 'port' in metadata:
                            c.update({'ansible_port': str(metadata['port'])})

                        if 'user' in metadata:
                            c.update({'ansible_user': metadata['user']})
                            c.update({'ansible_become': True})

                        if 'labels' in metadata:
                            c.update({'labels': metadata['labels']})

                        if 'alias' in metadata:
                            c.update({'alias': metadata['alias']})

                        if 'vs' in metadata:
                            c.update({'vs': metadata['vs']})

                        # add specific options from config
                        for option in ifilter(lambda s: s.startswith('hosts:'),
                                              config.sections()):
                            # remove `hosts:`
                            if option[6:] in hostname:
                                for o in config.items(option):
                                    # configparser returns tuples of key, value
                                    c.update({o[0]: o[1]})

                        export['_meta']['hostvars'][hostname] = {}
                        export['_meta']['hostvars'][hostname].update(c)

    print(json.dumps(export, indent=2))


def parse_host(host):
    """Parses a host and validates it against our naming conventions"""

    hostinfo = dict()
    info = host.split('-')

    expected = ['type', 'provider', 'os', 'arch', 'uid']

    if len(info) is not 5:
        raise Exception('Host format is invalid: %s,' % host)

    for key, item in enumerate(expected):
        hostinfo[item] = has_metadata(info[key])

    for item in ['type', 'provider', 'arch']:
        if hostinfo[item] not in valid[item]:
            raise Exception('Invalid %s: %s' % (item, hostinfo[item]))

    return hostinfo


def has_metadata(info):
    """Checks for metadata in variables. These are separated from the "key"
       metadata by underscore. Not used anywhere at the moment for anything
       other than descriptiveness"""

    param = dict()
    metadata = info.split('_', 1)

    try:
        key = metadata[0]
        metadata = metadata[1]
    except IndexError:
        metadata = False
        key = info

    return key if metadata else info


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--list', action='store_true')
    parser.add_argument('--host', action='store')
    args = parser.parse_args()

    main()
