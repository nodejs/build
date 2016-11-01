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
    <meta charset="utf-8">
    <title>Node.js Code Coverage</title>

    <link rel="dns-prefetch" href="http://fonts.googleapis.com">
    <link rel="dns-prefetch" href="http://fonts.gstatic.com">

    <meta name="author" content="Node.js Foundation">
    <meta name="robots" content="index, follow">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="apple-touch-icon" href="https://nodejs.org/static/apple-touch-icon.png">
    <link rel="icon" sizes="32x32" type="image/png" href="https://nodejs.org/static/favicon.png">

    <link rel="stylesheet" href="https://nodejs.org/en/styles.css" media="all">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600">
    <style>
        #logo { margin-bottom: 1rem; }
        #graphs {
            overflow: hidden;
            clear: both;
            list-style-type: none;
            margin: 0;
            padding: 0;
        }
        #graphs li {
            float: left;
            border: 1px solid #999;
            margin-left: 1%;
            margin-bottom: 1rem;
            padding: 0.25rem;
            max-width: 48%;
        }
        #graphs li:nth-child(odd) {
            clear: both;
            margin-left: 0;
        }
        #graphs img {
            max-width: 100%;
        }
        @media (max-width:850px) {
            #graphs li {
                float: none;
                margin-left: 0;
                max-width: 100%;
            }
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

          <h1>Node.js Code Coverage</h1>

  <div class="mdl-layout__drawer">
    <nav class="mdl-navigation">
        <a class="mdl-navigation__link" href="https://github.com/nodejs/node">Node.js Core</a>
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
   </div>
 </div>
    <script defer src="https://code.getmdl.io/1.1.3/material.min.js"></script>
    <footer class="no-margin-top">

        <div class="linuxfoundation-footer">
            <div class="container">
                <a class="linuxfoundation-logo" href="http://collabprojects.linuxfoundation.org">Linux Foundation Collaborative Projects</a>

                <p>© 2016 Node.js Foundation. All Rights Reserved. Portions of this site originally © 2016 Joyent. </p>
                <p>Node.js is a trademark of Joyent, Inc. and is used with its permission. Please review the <a href="https://nodejs.org/static/documents/trademark-policy.pdf">Trademark Guidelines of the Node.js Foundation</a>.</p>
                <p>Linux Foundation is a registered trademark of The Linux Foundation.</p>
                <p>Linux is a registered <a href="http://www.linuxfoundation.org/programs/legal/trademark" title="Linux Mark Institute">trademark</a> of Linus Torvalds.</p>
            </div>
        </div>
    </footer>
  </body>
</html>''')
