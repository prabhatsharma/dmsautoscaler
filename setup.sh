#!/bin/bash

aws cloudformation delete-stack --stack-name=dmsautoscaler 
sleep 20
aws cloudformation create-stack --capabilities CAPABILITY_NAMED_IAM --stack-name=dmsautoscaler --parameters '[{"ParameterKey": "DMSInstance", "ParameterValue": "dms1"}, {"ParameterKey": "NotificationSNSTopic", "ParameterValue": "arn:aws:sns:us-west-2:107995894928:mailer"}, {"ParameterKey": "DMSInstance", "ParameterValue": "dms1"}, {"ParameterKey": "NotificationSNSTopic", "ParameterValue": "arn:aws:sns:us-west-2:107995894928:mailer"} ]' --template-body file://dms_autoscaler-cfn.yaml



