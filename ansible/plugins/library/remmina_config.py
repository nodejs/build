#!/usr/bin/python
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

from __future__ import print_function

import base64
import os

from ansible.module_utils.basic import AnsibleModule
from Crypto.Cipher import DES3
from jinja2 import Environment
try:
    import configparser  # Python 3
except ImportError:
    import ConfigParser as configparser  # Python 2


host_template = \
    '''[remmina]
group=Node.js-{{ metadata.type }}-{{ metadata.provider }}
name={{ hostname }}
protocol=RDP
server={{ metadata.ansible_host }}:{{ metadata.rdp_port }}
username={{ metadata.ansible_user }}
password={{ password }}
colordepth=15
scale=1
window_width=800
window_height=600
window_maximize=1
viewmode=1

'''


def render_template(hostname, metadata, password):
    render = Environment()
    return render.from_string(host_template).render(hostname=hostname,
                                                    metadata=metadata,
                                                    password=password)


def remmina_encrypt(secret, password):
    key = secret[:24]
    iv = secret[24:]
    cipher = DES3.new(key, DES3.MODE_CBC, iv)
    result = password.encode('utf-8')
    result = result + b"\0" * (8 - len(result) % 8)
    result = cipher.encrypt(result)
    result = base64.b64encode(result)
    result = result.decode('utf-8')
    return result


def remmina_get_secret(remmina_config):
    conf = configparser.RawConfigParser()
    conf.read(remmina_config)
    secret = conf.get('remmina_pref', 'secret')
    secret = secret.strip()
    secret = base64.b64decode(secret)
    return secret


def find_remmina():
    # Snap packaged Remmina.
    config = os.path.expanduser('~/snap/remmina/current/.config/remmina/remmina.pref')
    target = os.path.expanduser('~/snap/remmina/current/.local/share/remmina')
    if os.path.isfile(config) and os.path.isdir(target):
        return (config, target)

    # Flatpak packaged Remmina.
    config = os.path.expanduser('~/.var/app/org.remmina.Remmina/config/remmina/remmina.pref')
    target = os.path.expanduser('~/.var/app/org.remmina.Remmina/data/remmina')
    if os.path.isfile(config) and os.path.isdir(target):
        return (config, target)

    # Current versions of Remmina follows XDG directories.
    xdg_config_home = os.environ.get('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))
    xdg_data_home = os.environ.get('XDG_DATA_HOME', os.path.expanduser('~/.local/share'))
    config = os.path.join(xdg_config_home, 'remmina/remmina.pref')
    target = os.path.join(xdg_data_home, 'remmina')
    if os.path.isfile(config) and os.path.isdir(target):
        return (config, target)

    # Older versions of Remmina.
    config = os.path.expanduser('~/.remmina/remmina.pref')
    target = os.path.expanduser('~/.remmina')
    if os.path.isfile(config) and os.path.isdir(target):
        return (config, target)

    return (None, None)


def main():
    module = AnsibleModule(
        argument_spec={
            'hostinfo': {
                'required': True,
                'type': 'dict',
            }
        }
    )

    (remmina_config, target_dir) = find_remmina()
    if remmina_config is None:
        module.exit_json(changed=False, meta='Could not find Remmina config')

    remmina_secret = remmina_get_secret(remmina_config)

    for hostname, metadata in module.params['hostinfo'].items():
        if 'rdp_port' not in metadata:
            continue

        password = remmina_encrypt(remmina_secret, metadata['ansible_password'])
        rendered = render_template(hostname, metadata, password)
        filename = os.path.join(target_dir, '%s.remmina' % hostname)

        try:
            with open(filename, 'w+') as f:
                f.write(rendered)
            f.close()
        except IOError:
            module.fail_json(msg='Couldn\'t write file for host %s. Check permissions' % hostname)

        os.chmod(filename, 0o600)

    module.exit_json(changed=True, meta=('Updated %s successfully' % target_dir))


if __name__ == '__main__':
    main()
