#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime

with open('jenkins/scripts/coverage/styles.css') as in_file:
  with open('out/styles.css') as out_file:
    out_file.write(in_file.read())

with open('out/index.csv') as index:
  index_csv = filter(lambda line: line, index.read().split('\n'))

with open('out/index.html', 'w') as out:
  out.write('''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Node.js Code Coverage</title>

    <link rel="dns-prefetch" href="https://fonts.googleapis.com">
    <link rel="dns-prefetch" href="https://fonts.gstatic.com">

    <meta name="author" content="Node.js Foundation">
    <meta name="robots" content="index, follow">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="apple-touch-icon" href="https://nodejs.org/static/images/favicons/apple-touch-icon.png">
    <link rel="icon" sizes="32x32" type="image/png" href="https://nodejs.org/static/images/favicons/favicon-32x32.png">

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600&display=fallback">
    <link rel="stylesheet" href="styles.css">
  </head>
  <body>
  <header>
    <div class="container" id="logo">
      <img src="https://nodejs.org/static/images/logo.svg" alt="node.js" width="122" height="75">
    </div>
  </header>
  <div id="main">
    <div class="container">
      <h1>Node.js Nightly Code Coverage</h1>
      Nightly combined JavaScript coverage for Windows and Linux can be found
      on <a href="https://codecov.io/gh/nodejs/node">codecov.io</a>:
      <a href="https://codecov.io/gh/nodejs/node">
        <img id="badge" src="https://codecov.io/gh/nodejs/node/branch/master/graph/badge.svg" alt="Combined coverage" width="112" height="20">
      </a>
      <h3>
        Nightly Linux Branch Coverage&nbsp;&nbsp;<a href="https://github.com/nodejs/node">&rarr;</a>
      </h3>
      <main>
        <div class="page-content">
          <div class="table">
            <div class="table-header">
              <div>Date (UTC)</div>
              <div>HEAD</div>
              <div>JS Coverage</div>
              <div>C++ Coverage</div>
            </div>
''')
  for line in reversed(index_csv):
    jscov, cxxcov, date, sha = line.split(',')
    date = datetime.datetime.strptime(date, '%Y-%m-%dT%H:%M:%S%fZ').strftime("%d/%m/%Y %H:%M")
    out.write('''
            <div class="table-row">
              <div><div class="cell-header">Date (UTC)</div><div class="cell-value">{0}</div></div>
              <div class="sha"><div class="cell-header">HEAD</div><div class="cell-value"><a href="https://github.com/nodejs/node/commit/{1}">{1}</a></div></div>
              <div><div class="cell-header">JS Coverage</div><div class="cell-value"><a href="coverage-{1}/index.html">{2:05.2f}&nbsp;%</a></div></div>
              <div><div class="cell-header">C++ Coverage</div><div class="cell-value"><a href="coverage-{1}/cxxcoverage.html">{3:05.2f}&nbsp;%</a></div></div>
            </div>'''.format(date, sha, float(jscov), float(cxxcov)))

  out.write('''
          </div>
        </div>
      </main>
    </div>
  </div>
  <footer class="no-margin-top">
    <div class="container">
      <div class="linuxfoundation-footer">
        <a class="linuxfoundation-logo" href="http://collabprojects.linuxfoundation.org/">Linux Foundation Collaborative Projects</a>
        <p>&copy; 2016 Node.js Foundation. All Rights Reserved. Portions of this site originally &copy; 2016 Joyent.</p>
        <p>Node.js is a trademark of Joyent, Inc. and is used with its permission. Please review the <a href="https://nodejs.org/static/documents/trademark-policy.pdf">Trademark Guidelines of the Node.js Foundation</a>.</p>
        <p>Linux Foundation is a registered trademark of The Linux Foundation.</p>
        <p>Linux is a registered <a href="http://www.linuxfoundation.org/programs/legal/trademark" title="Linux Mark Institute">trademark</a> of Linus Torvalds.</p>
      </div>
    </div>
  </footer>
  </body>
</html>''')
