const { Storage } = require('@google-cloud/storage')
const storage = new Storage();
const express = require('express')
const app = express()
app.use(express.json())

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

    const fileContents = '<html>\n<head>\n</head>\n<body>\n' + body + '</body>\n</html>'
    const fileName = 'index.html'
    try {
      await storage.bucket('access-logs-summaries-nodejs').file(fileName).save(fileContents)
      console.log(`Upload complete: ${fileName}`)
    } catch (error) {
      console.error(`ERROR UPLOADING FILE: ${fileName} - ${error}`)
    }
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
