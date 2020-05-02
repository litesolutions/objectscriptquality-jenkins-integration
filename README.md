# ObjectScript Quality Jenkins Integration

This repository contains the following files:

* _workflow.yml_: GitHub workflow definition that is executed "on push" action. This file must be included in ".github/workflows" folder inside the repository that want to be integrated
* _hook.sh_: script that implements the commands that interactuate with [ObjectScript Quality Jenkins](https://community-jenkins.objectscriptquality.com/) REST API. This file is downloaded and executed from "workflow.yml"
