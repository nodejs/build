#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime

with open('out/index.csv') as index:
  index_csv = filter(lambda line: line, index.read().split('\n'))

with open('out/index.html', 'w') as out:
  out.write(
'''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Node.js Code Coverage</title>

    <link rel="dns-prefetch" href="http://fonts.googleapis.com">
    <link rel="dns-prefetch" href="http://fonts.gstatic.com">

    <meta name="author" content="Node.js Foundation">
    <meta name="robots" content="index, follow">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="apple-touch-icon" href="https://nodejs.org/static/apple-touch-icon.png">
    <link rel="icon" sizes="32x32" type="image/png" href="https://nodejs.org/static/favicon.png">

    <link rel="stylesheet" href="https://nodejs.org/layouts/css/styles.css" media="all">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600">
    <style>
        #logo { margin-bottom: 1rem; }
        main { margin-bottom: 2rem; }
        .table-header,
        .table-row {
          box-sizing: border-box;
          display: flex;
          width: 100%;
          padding: 2px 10px;
        }
        .table-header { font-weight: bold;}
        .table-header > div,
        .table-row > div {
          flex-grow: 1;
          width: 100px;
        }
        .table-row:nth-child(even) { background-color: #eee; }
        .sha .cell-value { font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace; }
        .cell-header { display: none; }
        @media screen and (min-width: 690px) and (max-width: 850px) {
          .table-header > div:nth-child(n+3),
          .table-row > div:nth-child(n+3) {
            flex-grow: 0.2;
          }
          .table-header > div:first-child,
          .table-row > div:first-child {
            flex-grow: 0.4;
          }
        }
        @media screen and (max-width: 690px) {
          .cell-header { display: block; font-weight: bold; }
          .table-header { display: none; }
          .table-row { display: block; }
          .table-row > div { width: 100%; text-align: center; margin-bottom: 12px;}
        }
    </style>
  </head>
  <body>
  <header>
    <div class="container" id="logo">
      <img src="https://nodejs.org/static/images/logos/nodejs-new-white-pantone.png" alt="node.js">
    </div>
  </header>
  <div id="main">
    <div class="container">
      <h1>Node.js Nightly Code Coverage</h1>
      <h3>
        Node.js Core&nbsp;&nbsp;<a href="https://github.com/nodejs/node">&rarr;</a>
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
      </div>
    </div>
    <footer class="no-margin-top">
      <div class="linuxfoundation-footer">
        <div class="container">
          <a class="linuxfoundation-logo" href="http://collabprojects.linuxfoundation.org">Linux Foundation Collaborative Projects</a>
          <p>&copy; 2016 Node.js Foundation. All Rights Reserved. Portions of this site originally &copy; 2016 Joyent. </p>
          <p>Node.js is a trademark of Joyent, Inc. and is used with its permission. Please review the <a href="https://nodejs.org/static/documents/trademark-policy.pdf">Trademark Guidelines of the Node.js Foundation</a>.</p>
          <p>Linux Foundation is a registered trademark of The Linux Foundation.</p>
          <p>Linux is a registered <a href="http://www.linuxfoundation.org/programs/legal/trademark" title="Linux Mark Institute">trademark</a> of Linus Torvalds.</p>
        </div>
      </div>
    </footer>
  </body>
</html>''')
