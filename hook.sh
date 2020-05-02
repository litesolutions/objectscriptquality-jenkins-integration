#!/bin/bash

JENKINS_URL=https://community-jenkins.objectscriptquality.com
JENKINS_USER=$JENKINS_OBJECTSCRIPTQUALITY_USER
JENKINS_TOKEN=$JENKINS_OBJECTSCRIPTQUALITY_PASSWORD
JOB_BUILD_TRIGGER_ACCESS_TOKEN=$JENKINS_OBJECTSCRIPTQUALITY_TRIGGER_ACCESS_TOKEN
GIT_URL=http://github.com/$GITHUB_REPOSITORY
BRANCH=master
COOKIE_JAR=/tmp/cookies

JENKINS_CRUMB=$(curl --silent --cookie-jar $COOKIE_JAR -s -u $JENKINS_USER:$JENKINS_TOKEN $JENKINS_URL'/crumbIssuer/api/json' | sed -E 's/.*"crumb":"?([^,"]*)"?.*/\1/')
echo "JENKINS CRUMB: "$JENKINS_CRUMB
JOB_DISPLAY_NAME=${GIT_URL##*/}
JOB_NAME_TO_CALL=intersystems_iris_contests_$JOB_DISPLAY_NAME
echo "JOB NAME TO CALL: "$JOB_NAME_TO_CALL

EXISTING_JOB_NAME=$(curl $JENKINS_URL'/job/intersystems_iris_contests_generated_jobs/job/'$JOB_NAME_TO_CALL'/api/json' -u $JENKINS_USER:$JENKINS_TOKEN | sed -E 's/.*"name":"?([^,"]*)"?.*/\1/')
echo "NAME OF EXISTING JOB: "$EXISTING_JOB_NAME

if [ "$EXISTING_JOB_NAME" != "$JOB_NAME_TO_CALL" ]
then
    echo "JOB NOT EXISTS"

    curl -G -I --cookie $COOKIE_JAR $JENKINS_URL'/job/intersystems_iris_contests_job_generator/job/intersystems_iris_contests_job_generator/buildWithParameters?token='$JOB_BUILD_TRIGGER_ACCESS_TOKEN --data-urlencode 'GIT_URL='$GIT_URL --data-urlencode 'BRANCH='$BRANCH -H "Content-Type:text/xml" -u $JENKINS_USER:$JENKINS_TOKEN -v
    
    sleep 10
    
    echo "JOB "$JOB_NAME_TO_CALL" CREATED!"
fi  

echo "INVOKE "$JOB_NAME_TO_CALL
curl -X POST -s --cookie $COOKIE_JAR $JENKINS_URL'/job/intersystems_iris_contests_generated_jobs/job/'$JOB_NAME_TO_CALL'/build' -H 'Jenkins-Crumb:'$JENKINS_CRUMB -u $JENKINS_USER:$JENKINS_TOKEN -v
echo $JOB_NAME_TO_CALL" EXECUTED!"

