#!/bin/bash

mongodb-runner start
parse-server --appId test --clientKey test --masterKey test --databaseURI mongodb://localhost/test --cloud /home/david/temp/precept/back4app/cloudCode/main.js
