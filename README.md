# AWS DMS Vertical Autoscaler

This repository contains code for the blog article {{link for the blog}}.

## How to auto-scale AWS Database Migration Service (DMS) replication instance 

AWS Database Migration Service (DMS) helps to migrate databases to AWS quickly and securely. The AWS DMS migration process encompasses setting up a replication instance, source and target endpoints, and replication tasks. The replication task runs on the replication instance and moves data from the source endpoint to the target endpoint. 
Replication instance uses resources like CPU, Memory, storage and IO which may get constrained depending on the size of the instance chosen and the kind of workload. 

This post gives a quick overview of how you can auto-scale AWS DMS replication instance to handle higher load (scale up) when required and save money (scale down) when load is low.

## Problem/use case
- When setting up an AWS DMS replication instance, customers must analyze 
- The number of tables in the database
- The volume of data in those tables 
- Number of concurrent replication tasks
- Traffic to source database
In order to have the AWS DMS replication instance right-sized, we must be able to predict the right resource utilization (CPU and memory).

## Solution

AWS DMS best practices whitepaper outlines a number of strategies to provision the right-sized AWS DMS replication instance. In this post, we will show you how to achieve even higher flexibility in sizing the AWS DMS replication instance using Amazon CloudWatch (CW) to monitor AWS DMS replication instance for CPU utilization or memory utilization or both. Once the cloudwatch alarm threshold reaches, it triggers Amazon Simple Notification Service (Amazon SNS) notification subscribed by AWS Lambda function to modify replication instance and also notifies if the tasks running on the new replication instance started successfully or not.
We will show you how to do this in five main steps.
1.	Create an IAM Role and Policy that grants Lambda function permissions to access the AWS resources needed.
2.	Create an Amazon Simple Notification Service (SNS) topic that will be used by the Lambda function to notify the user regarding the status of the AWS DMS replication instance. 
3.	Create a Lambda function that performs the AWS replication instance modification, and creates an Amazon Cloudwatch Scheduled event. This event invokes Lambda function every one minute to poll AWS DMS replication instance for its status after instance modification started. Once the replication modification completes then, it deletes the Amazon Cloudwatch Scheduled event.
4.	Create another Amazon Simple Notification Service (SNS) topic that is invoked by Cloudwatch Alarm state changes. Subscribe the Lambda function to this SNS topic.
 5.	Create Amazon Cloudwatch alarms that watch metrics for the AWS DMS replication instance for 
    - High CPU utilization
    - Low CPU utilization
    - High memory utilization.


AWS DMS is region-based, and it is necessary to set up your alarm and resources in each AWS Region separately.


![DMS autoscaler architecture](https://i.imgur.com/xs5dLSX.png)

You can use the [dms_autoscaler-cfn.yaml](dms_autoscaler-cfn.yaml) to setup everything.