# Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# Licensed under the MIT No Attribution aka MIT-Zero (https://github.com/aws/mit-0) license

import dms
import json

f = open("dms-event.json", "rb")
# f = open("cloudwatch-scheduled-event.json", "rb")
data = json.loads(f.read())
f.close()

dms.lambda_handler(data,1)
