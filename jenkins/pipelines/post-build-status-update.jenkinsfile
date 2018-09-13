#!/usr/bin/env groovy

// DESCRIPTION:
// Updates the status of a GitHub pull request via the GitHub Bot. Primarily
// used for node-test-commit-* sub builds.

import groovy.json.JsonOutput

pipeline {
    agent { label 'jenkins-workspace' }

    parameters {
        string(defaultValue: 'node', description: 'GitHub repository', name: 'REPO')
        string(defaultValue: '', description: 'test/aix, linter, etc.', name: 'IDENTIFIER')
        string(defaultValue: '', description: 'pending, success, unstable, failure', name: 'STATUS')
        string(defaultValue: '', description: 'URL for upstream Jenkins job', name: 'URL')
        string(defaultValue: '', description: 'Current commit being tested in upstream Jenkins job', name: 'COMMIT')
        string(defaultValue: '', description: 'Current branch being tested in upstream Jenkins job', name: 'REF')
    }

    stages {
        stage('Send status report') {
            steps {
                validateParams(params)
                timeout(activity: true, time: 30, unit: 'SECONDS') {
                    sendBuildStatus(params.REPO, params.IDENTIFIER, params.STATUS, params.URL, params.COMMIT, params.REF)
                }
            }
        }
    }
}

def sendBuildStatus(repo, identifier, status, url, commit, ref) {
    def path = ""
    def message = ""

    if (status == "pending") {
        path = "start"
        message = "running tests"
    } else if (status == "failure") {
        path = "end"
        message = "tests failed"
    } else if (status == "unstable") {
        path = "end"
        message = "flaky tests failed"
        status = "success"
    } else if (status == "success") {
        path = "end"
        message = "tests passed"
    }

    def buildPayload = JsonOutput.toJson([
        'identifier': identifier,
        'status': status,
        'url': url,
        'commit': commit,
        'ref': ref,
        'message': message
        ])

    println(buildPayload)
    
    def response
    try {
        response = httpRequest(
            url: "http://github-bot.nodejs.org:3333/${repo}/jenkins/${path}",
            httpMode: "POST",
            timeout: 30,
            contentType: 'APPLICATION_JSON_UTF8',
            requestBody: buildPayload
        )
    } catch (Exception e) {
        println(e.toString())
        if (response) {
            println("Status: "+response.status)
            println("Content: "+response.content)
        }
    }
}

def validateParams(params) {
    if (params.IDENTIFIER == '' || params.STATUS == '' || params.URL == '' ||
        params.COMMIT == '' || params.REF == '') {
        error('All parameter fields are required.')
    }
}
