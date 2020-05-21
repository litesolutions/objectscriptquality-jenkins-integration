# Set variables
TARGET_FOLDER=intersystems_iris_community
JOB_DISPLAY_NAME=${GIT_URL##*/}
TEMPLATE_FILE=iris-community-job-template.xml
TEMPLATE_PATH=/tmp/$TEMPLATE_FILE

# Replace values from template
cp $TEMPLATE_FILE /tmp
sed -i -e 's|{{GIT_URL}}|'"$GIT_URL"'|' $TEMPLATE_PATH
sed -i -e 's|{{BRANCH}}|'"$BRANCH"'|' $TEMPLATE_PATH
sed -i -e 's|{{DISPLAY_NAME}}|'"$JOB_DISPLAY_NAME"'|' $TEMPLATE_PATH

cat $TEMPLATE_PATH

# Generate job
export COOKIE_JAR=/tmp/cookies

JENKINS_CRUMB=$(curl --silent --cookie-jar $COOKIE_JAR -s -u $JENKINS_USER:$JENKINS_PASSWORD $JENKINS_URL'/crumbIssuer/api/json' | sed -E 's/.*"crumb":"?([^,"]*)"?.*/\1/')
JOB_NAME_TO_GENERATE=$JOB_DISPLAY_NAME

JENKINS_JOB_URL=$JENKINS_URL'/job'
if [ ! -z "$TARGET_FOLDER" ]
then
    JENKINS_JOB_URL=$JENKINS_URL'/job/'$TARGET_FOLDER
fi

curl -s --cookie $COOKIE_JAR $JENKINS_JOB_URL'/createItem?name='$JOB_NAME_TO_GENERATE -H 'Jenkins-Crumb:'$JENKINS_CRUMB -H "Content-Type:text/xml" -u $JENKINS_USER:$JENKINS_PASSWORD --data-binary @$TEMPLATE_PATH
rm $TEMPLATE_PATH
