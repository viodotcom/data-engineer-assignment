import os, boto3, json
from botocore.config import Config
from datetime import datetime

def handler(event, context):
    s3_client = boto3.client(
        's3',
        endpoint_url=f"http://{os.getenv('LOCALSTACK_HOSTNAME')}:4566",
        use_ssl=False,
        aws_access_key_id='test',
        aws_secret_access_key='test',
        region_name='eu-west-1',
        config=Config(
            s3 = {
                'addressing_style': 'path'
            }
        )
    )
    s3_client.put_object(
        Bucket=os.getenv('BUCKET'),
        Key=f"{datetime.now().strftime('%Y%m%d%H%M%S')}.json",
        Body=json.dumps({
            'timestamp': datetime.now().strftime('%Y%m%d%H%M%S')
        })
    )
