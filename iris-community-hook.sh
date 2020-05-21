#!/bin/bash

# Free server usage for community projects
# Password and token are open to be used by any community user

JENKINS_URL=https://community-jenkins.objectscriptquality.com
JENKINS_USER=hook
JENKINS_PASSWORD=je3MD3z9zSu9hPWP
JOB_BUILD_TRIGGER_ACCESS_TOKEN=a412415d-d56c-4425-91b8-162fd434828d
JOB_GENERATOR=intersystems_iris_community_job_generator
TARGET_FOLDER=intersystems_iris_community
GIT_URL=https://github.com/$GITHUB_REPOSITORY
BRANCH=master
COOKIE_JAR=/tmp/cookies

JENKINS_CRUMB=$(curl --silent --cookie-jar $COOKIE_JAR -s -u $JENKINS_USER:$JENKINS_PASSWORD $JENKINS_URL'/crumbIssuer/api/json' | sed -E 's/.*"crumb":"?([^,"]*)"?.*/\1/')
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

EXISTING_JOB_NAME=$(curl $JENKINS_JOB_URL'/api/json' -u $JENKINS_USER:$JENKINS_PASSWORD | sed -E 's/.*"name":"?([^,"]*)"?.*/\1/')
echo "Name of existing job: "$EXISTING_JOB_NAME

if [ "$EXISTING_JOB_NAME" != "$JOB_NAME_TO_CALL" ]
then
    echo "Job does not exists"

    curl -G -I --cookie $COOKIE_JAR --data-urlencode 'GIT_URL='$GIT_URL --data-urlencode 'BRANCH='$BRANCH -H "Content-Type:text/xml" -u $JENKINS_USER:$JENKINS_PASSWORD -v $JENKINS_URL'/job/job_generator/job/'$JOB_GENERATOR'/buildWithParameters?token='$JOB_BUILD_TRIGGER_ACCESS_TOKEN
    
    sleep 120
    
    echo "Job '"$JOB_NAME_TO_CALL"' created!"
fi

echo "Invoke "$JOB_NAME_TO_CALL
curl -X POST -s --cookie $COOKIE_JAR $JENKINS_JOB_URL'/build' -H 'Jenkins-Crumb:'$JENKINS_CRUMB -u $JENKINS_USER:$JENKINS_PASSWORD -v
echo "Job '"$JOB_NAME_TO_CALL"' Executed!"

