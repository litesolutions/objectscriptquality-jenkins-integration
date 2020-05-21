# ObjectScript Quality Jenkins Integration

This repository contains the following files:

* _base-workflow.yml_: GitHub workflow definition that is executed "on push" action. This file must be included in ".github/workflows" folder inside the repository that want to be integrated
* _base-hook.sh_: script that implements the commands that interactuate with [ObjectScript Quality Jenkins](https://community-jenkins.objectscriptquality.com/) REST API. This file is downloaded and executed from "workflow.yml"
* _base-job-generator.sh_: script to be executed by the "Job Generator" job. This script replace parameters on "job_template.xml" and call objectscriptQuality Jenkins REST API
* _base-job-template.xml_: Jenkins job definition with following parameters
  * GIT_URL: URL of the Git repository
  * GIT_BRANCH: branch of Git repository to analyze
  * DISPLAY_NAME: name that will be displayed for the job
