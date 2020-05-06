#!/bin/bash

JENKINS_URL=https://community-jenkins.objectscriptquality.com
JENKINS_USER=$JENKINS_OBJECTSCRIPTQUALITY_USER
JENKINS_TOKEN=$JENKINS_OBJECTSCRIPTQUALITY_PASSWORD
JOB_BUILD_TRIGGER_ACCESS_TOKEN=$JENKINS_OBJECTSCRIPTQUALITY_TRIGGER_ACCESS_TOKEN
JOB_GENERATOR=intersystems_iris_contests_job_generator
TARGET_FOLDER=intersystems_iris_contests
GIT_URL=https://github.com/$GITHUB_REPOSITORY
BRANCH=master
COOKIE_JAR=/tmp/cookies

JENKINS_CRUMB=$(curl --silent --cookie-jar $COOKIE_JAR -s -u $JENKINS_USER:$JENKINS_TOKEN $JENKINS_URL'/crumbIssuer/api/json' | sed -E 's/.*"crumb":"?([^,"]*)"?.*/\1/')
echo "Jenkins crumb: "$JENKINS_CRUMB
JOB_DISPLAY_NAME=${GIT_URL##*/}
JOB_NAME_TO_CALL=$JOB_DISPLAY_NAME
echo "Job name to call: "$JOB_NAME_TO_CALL

JENKINS_JOB_URL=
if [ -z "$TARGET_FOLDER" ]
then
    JENKINS_JOB_URL=$JENKINS_URL'/job/'$JOB_NAME_TO_CALL
else
    JENKINS_JOB_URL=$JENKINS_URL'/job/'$TARGET_FOLDER'/job/'$JOB_NAME_TO_CALL
fi

EXISTING_JOB_NAME=$(curl $JENKINS_JOB_URL'/api/json' -u $JENKINS_USER:$JENKINS_TOKEN | sed -E 's/.*"name":"?([^,"]*)"?.*/\1/')
echo "Name of existing job: "$EXISTING_JOB_NAME

if [ "$EXISTING_JOB_NAME" != "$JOB_NAME_TO_CALL" ]
then
    echo "Job does not exists"

    curl -G -I --cookie $COOKIE_JAR $JENKINS_URL'/job/job_generator/job/'$JOB_GENERATOR'/buildWithParameters?token='$JOB_BUILD_TRIGGER_ACCESS_TOKEN --data-urlencode 'GIT_URL='$GIT_URL --data-urlencode 'BRANCH='$BRANCH -H "Content-Type:text/xml" -u $JENKINS_USER:$JENKINS_TOKEN -v
    
    sleep 30
    
    echo "Job '"$JOB_NAME_TO_CALL"' created!"
fi

echo "Invoke "$JOB_NAME_TO_CALL
curl -X POST -s --cookie $COOKIE_JAR $JENKINS_JOB_URL'/build' -H 'Jenkins-Crumb:'$JENKINS_CRUMB -u $JENKINS_USER:$JENKINS_TOKEN -v
echo "Job '"$JOB_NAME_TO_CALL"' Executed!"

