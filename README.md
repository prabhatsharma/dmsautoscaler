# dms_autoscaling

This code helps to autoscale replication instance

Creation Process:

1. Create SNS topics "dms_mailer" and "dms_autoscaler". dms_mailer will be used to notify users of autoscaling activities. dms_autoscaler will be used to publish the message from cloudwatch alarm data. dms_autoscaler topic will target the lambda function for autoscaling.
2. create alarms:
    1. dms-cpu-high
    2. dms-cpu-low
    3. dms-memory-high
    4. dms-memory-low - How to create this?
3. Point both alarms to SNS topic "dms"
4. Create lambda function
5. subscribe your lambda function to sns "dms"


There can be 2 events that fire lambda function:
1. One of the preconfigured alarms get into "ALARM" state and send message to sns topic dms_autoscaler.
    1. lambda that is subscribed to sns would get triggered.
    2. lambda will initiate the instance modification process
    3. After the modification process is started (may take 3-20 minutes to complete), it creates a new cloudwatch scheduled event with replication instance and replication task details.
    4. scheduled event targets the same lambda function to execute every 1 minute.
    5. scheduled event contains metadata about the replication instance
2. scheduled event would trigger the lambda function every 1 minute
    1. lambda function needs to identify how it was triggered.
    2. Once lambda trigger identifies that it was triggered by scheduled event it should check for following:
        1. has the instance state become available?
        2. has the status of tasks become same as that of hat has been passed by the event.
        3. if both the above items are satisfied then send a mail to user about instance modification
        4. delete the scheduled event

![DMS autoscaler architecture](https://i.imgur.com/xs5dLSX.png)

To test cpu-high/low trigger function manually (need to add --cli-data parameter):

> aws cloudwatch set-alarm-state --alarm-name=dms-cpu-high --state-value="ALARM" --state-reason="Testing1"

> aws cloudwatch set-alarm-state --alarm-name=dms-cpu-low --state-value="ALARM" --state-reason="Testing1"

From - https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Monitoring.html 

Freeable memory is not a indication of the actual free memory available. It is the memory that is currently in use that can be freed and used for other uses; it's is a combination of buffers and cache in use on the replication instance.
While the FreeableMemory metric does not reflect actual free memory available, the combination of the FreeableMemory and SwapUsage metrics can indicate if the replication instance is overloaded.

Monitor these two metrics for the following conditions.
• The FreeableMemory metric approaching zero.
• The SwapUsage metric increases or fluctuates.

If you see either of these two conditions, they indicate that you should consider moving to a larger replication instance. You should also consider reducing the number and type of tasks running on the replication instance. Full Load tasks require more memory than tasks that just replicate changes.