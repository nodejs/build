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

from ansible.errors import AnsibleFilterError
import re


def match_key(value, dictionary, raise_error=True, feedback_name='os'):
    for key, val in dictionary.iteritems():
        # yes, yes; we can lambda this but my old self in
        # two years will cry having to understand
        if type(val) is list:
            for list_key in val:
                if value.startswith(list_key):
                    return key
        elif value.startswith(val):
            return key
    if raise_error:
        raise AnsibleFilterError(
            "Couldn\'t find %s in supported %s types" % (value, feedback_name)
        )
    return False


def starts_with(value, query):
    return value.startswith(query)


def stripversion(value):
    # returns stuff up to first digit
    match = re.search(r'^\D+', value)
    return match.group() if match else False


class FilterModule(object):
    ''' Query filter '''

    def filters(self):
        return {
            'match_key': match_key,
            'startswith': starts_with,
            'stripversion': stripversion
        }
