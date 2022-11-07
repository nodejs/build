const { Storage } = require('@google-cloud/storage')
const storage = new Storage({
    keyFilename: "metrics-processor-service-key.json",
  });
const express = require('express')
const bodyParser = require('body-parser')
const app = express()  
app.use(bodyParser.json())


async function getFileList() {

      let fileList = []

      const [files] = await storage.bucket('access-logs-summaries-nodejs').getFiles()
      for (const file of files){
          if (!file.name.includes('html')){
            fileList.push(file.name)
          }
      }
      return fileList
}


async function generateIndex() {
    
    let fileList = []
    fileList = await getFileList()

    const baseURL = "https://storage.googleapis.com/access-logs-summaries-nodejs/"
    let body = ''

    for (file of fileList){
        let bodyString = '<p> <a href="' + baseURL.concat(file) + '"> ' + file + ' </a></p>\n'
        body += (bodyString)
    }

    indexfile = '<html>\n<head>\n</head>\n<body>\n' + body + '</body>\n</html>'    

    storage.bucket('access-logs-summaries-nodejs').file('index.html').save(indexfile, function (err) {
        if (err) {
          console.log('ERROR UPLOADING: ', err)
        } else {
          console.log('Upload complete')
        }
      })
}

app.post('/', async (req, res) => {
    if (req.body.message.attributes.objectId != 'index.html'){
        await generateIndex()
    }
    res.status(200).send()
  })
  
  const port = process.env.PORT || 8080
  app.listen(port, () => {
    console.log('Listening on port: ', port)
  })
  
  module.exports = app
