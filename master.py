import dms
import json

f = open("dms-event.json", "rb")
# f = open("cloudwatch-scheduled-event.json", "rb")
data = json.loads(f.read())
f.close()

dms.lambda_handler(data,1)
