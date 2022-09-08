# Analyze your open source code for free

If you have your source code published on GitHub, you can analyze your ObjectScript code for free and check results in https://community.objectscriptquality.com.

You only need to create the file `.github/workflows/objectscript-quality.yml` in your project with following content:

```
name: objectscriptquality
on: push

jobs:
  linux:
    name: Linux build
    runs-on: ubuntu-latest

    steps:
    - name: Execute ObjectScript Quality Analysis
      run: wget https://raw.githubusercontent.com/litesolutions/objectscriptquality-jenkins-integration/master/iris-community-hook.sh && sh ./iris-community-hook.sh
```

That's all!! Now you only need to wait some minutes to get the results in https://community.objectscriptquality.com.

# ObjectScript Quality Jenkins Integration

This repository contains the base scripts to integrate GitHub with a Jenkins CI server. Also, it includes the specific files for IRIS community integration with the https://community.objectscriptquality.com/ service.

This repository contains the following files:

* _base-workflow.yml_: GitHub workflow definition that indicates to be executed `on push` action. This file must be included in `.github/workflows` folder inside the repository to be integrated. That file contains basic insructions to call `base-hook.sh` from a public repository, so any changes in process should not be done in `base-workflow.yml` but in `base-hook.sh` instead.
* _base-hook.sh_: This is the main script that implements the real operations to interactuate with [ObjectScript Quality Jenkins](https://community-jenkins.objectscriptquality.com/) REST API. This file is downloaded and executed from the `base-workflow.yml` and create the new jobs using the `base-job-generator.sh`.
* _base-job-generator.sh_: This script replace parameters on `base-job-template.xml` and call objectscriptQuality Jenkins REST API to create new projects and execute the code analysis.
* _base-job-template.xml_: This files is a Jenkins job definition with following parameters:
  * GIT_URL: URL of the Git repository
  * GIT_BRANCH: branch of Git repository to analyze
  * DISPLAY_NAME: name that will be displayed for the job
