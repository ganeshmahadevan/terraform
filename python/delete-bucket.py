import boto3

client = boto3.client('s3')
response = client.delete_bucket(
    Bucket='ganesh.jegadish.orafile',
#    ExpectedBucketOwner='string'
)
