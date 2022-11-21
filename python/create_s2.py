import boto3

client = boto3.client('s3')
response = client.create_bucket(
    ACL='private',
    Bucket='ganesh.jegadish.orafile',
    CreateBucketConfiguration={
        'LocationConstraint': 'ap-south-1'
    },
    )

print (response)
