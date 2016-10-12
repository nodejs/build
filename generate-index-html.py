#!/usr/bin/env python
# -*- coding: utf-8 -*-

with open('out/index.csv') as index:
  index_csv = filter(lambda line: line, index.read().split('\n'))

with open('out/index.html', 'w') as out:
  out.write(
'''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Node.js Core Coverage</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" type="text/css">
    <link rel="stylesheet" href="https://code.getmdl.io/1.1.3/material.yellow-indigo.min.css" />
    <style media="screen" type="text/css">
      .table-container {
        display: flex;
        justify-content: center;
        margin-top: 50px;
      }
    </style>
  </head>
  <body>

  <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header">
  <header class="mdl-layout__header">
    <div class="mdl-layout__header-row">
      <!-- Title -->
      <span class="mdl-layout-title">Node.js Core Coverage</span>
      <!-- Add spacer, to align navigation to the right -->
      <div class="mdl-layout-spacer"></div>
      <!-- Navigation. We hide it in small screens. -->
      <nav class="mdl-navigation mdl-layout--large-screen-only">
        <a class="mdl-navigation__link" href="https://github.com/nodejs/node">Node.js Core</a>
        <a class="mdl-navigation__link" href="https://github.com/addaleax/node-core-coverage">Project</a>
      </nav>
    </div>
  </header>
  <div class="mdl-layout__drawer">
    <nav class="mdl-navigation">
        <a class="mdl-navigation__link" href="https://github.com/nodejs/node">Node.js Core</a>
        <a class="mdl-navigation__link" href="https://github.com/addaleax/node-core-coverage">Project</a>
    </nav>
  </div>

  <main class="table-container mdl-layout__content">
      <div class="page-content">
      <table class="mdl-data-table mdl-js-data-table mdl-shadow--2dp">
        <thead>
          <tr>
            <th>Date</th>
            <th>HEAD</th>
            <th>JS Coverage</th>
            <th>C++ Coverage</th>
          </tr>
        </thead>
      <tbody>
''')
  for line in reversed(index_csv):
    jscov, cxxcov, date, sha = line.split(',')
    out.write('''
          <tr>
            <td>{0}</td>
            <td><a href="https://github.com/nodejs/node/commit/{1}">{1}</a></td>
            <td><a href="coverage-{1}/index.html">{2:05.2f}&nbsp;%</a></td>
            <td><a href="coverage-{1}/cxxcoverage.html">{3:05.2f}&nbsp;%</a></td>
          </tr>'''.format(date, sha, float(jscov), float(cxxcov)))
  out.write('''
          </tbody>
        </table>
      </div>
    </main>
    <script defer src="https://code.getmdl.io/1.1.3/material.min.js"></script>
  </body>
</html>''')
