#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os
import tempfile
import errno
import subprocess

# from ansible import __version__
from ansible.errors import AnsibleParserError
from ansible.module_utils._text import to_bytes, to_native
from ansible.inventory.host import Host
from ansible.inventory.group import Group
from ansible.utils.vars import combine_vars

try:
    from ansible.plugins.vars import BaseVarsPlugin
except ImportError:
    class BaseVarsPlugin(object):
        def __init__(self, args):
            try:
                from __main__ import display
            except ImportError:
                from ansible.utils.display import Display
                display = Display()

            display.warning("%s will not work if ansible < 2.4" % __name__)

DECRYPT_TOOL = "gpg"
FOUND = {}


class VarsModule(BaseVarsPlugin):

    def _can_i_run(self):
        try:
            subprocess.Popen([DECRYPT_TOOL, "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        except OSError as e:
            if e.errno == errno.ENOENT:
                self._display.warning("load_secret plugin cannot find %s executable" % DECRYPT_TOOL)
            return False
        else:
            return True

    def _decrypt_file(self, file_path, temp_plain_file):
        self._display.display("Trying to decrypt %s" % file_path)
        command = [DECRYPT_TOOL, "-q", "--decrypt", file_path]
        process = subprocess.Popen(command, stdout=temp_plain_file, stderr=subprocess.PIPE)
        _, stderr = process.communicate()
        if process.returncode > 0:
            self._display.warning("Decryption failed with error %s for file %s" % (process.returncode, file_path))
            self._display.warning("Got following error while running '%s':" % " ".join(command[0:-1]))
            self._display.warning(stderr)
        return (process.returncode == 0)


    def get_vars(self, loader, path, entities, cache=True):

        data = {}
        if not self._can_i_run():
            return data

        ''' parses the inventory file '''
        if not isinstance(entities, list):
            entities = [entities]

        super(VarsModule, self).get_vars(loader, path, entities)
        for entity in entities:
            if isinstance(entity, Host):
                secrets_dir = os.path.realpath(os.environ.get('NODE_BUILD_SECRETS', os.path.join(os.getcwd(), '../../secrets/build/')))
                if not os.path.isdir(secrets_dir):
                    self._display.warning("Cannot find secrets folder, to autoload secrets either move the secret folder to %s or set NODE_BUILD_SECRETS env var to the path of the secret repo" % secrets_dir)
                    continue
            elif isinstance(entity, Group):
                self._display.debug("Entity is a group (%s), we only take care of Hosts" % entity)
                continue
            else:
                raise AnsibleParserError("Supplied entity must be Host or Group, got %s instead" % (type(entity)))
            # avoid 'chroot' type inventory hostnames /path/to/chroot
            if not entity.name.startswith(os.path.sep):
                try:
                    host_vars_path = os.path.realpath(os.path.join(os.getcwd(), 'host_vars', entity.name))

                    if os.path.isfile(host_vars_path):
                        self._display.debug("No need to decrypt secret, host_var already present in %s" % host_vars_path)
                        continue

                    for group in entity.get_groups():
                        host_vars_path = os.path.realpath(os.path.join(secrets_dir, group.name, 'host_vars'))

                        self._display.debug("Looking in %s" % (host_vars_path))
                        key = '%s.%s' % (entity.name, host_vars_path)

                        if not (cache and key in FOUND):
                            b_host_vars_path = to_bytes(host_vars_path)
                            # no need to do much if path does not exist for basedir
                            if os.path.isdir(b_host_vars_path):
                                self._display.debug("\tprocessing dir %s" % host_vars_path)
                                file_path = os.path.join(host_vars_path, entity.name)
                                if os.path.isfile(file_path):
                                    FOUND[key] = tempfile.NamedTemporaryFile(dir="./host_vars", prefix="%s-" % entity.name, suffix='-tmp-secrets')
                                    if not self._decrypt_file(file_path, FOUND[key]): continue # decrypt failed

                        if key in FOUND:
                            new_data = loader.load_from_file(FOUND[key].name, cache=True, unsafe=True)
                            if new_data:  # ignore empty files
                                data = combine_vars(data, new_data)

                except Exception as e:
                    raise AnsibleParserError(to_native(e))
        return data
