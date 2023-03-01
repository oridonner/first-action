import sys
import filetype
import boto3
import smtplib
import ssl
import os
from email.message import EmailMessage

# set variables
s3Client = boto3.client('s3')
email_sender = os.environ.get('email_sender')
email_password = os.environ.get('email_password')
email_receiver = os.environ.get('email_receiver')

def handler(event, context):
    # get the bucket and file name
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # get object
    response = s3Client.get_object(Bucket=bucket, Key=key)
    
    # identify object type using filetype
    kind = filetype.guess(response['Body'].read())
    if kind is None:
        print('Cannot guess file type!')
        return

    # send email with requested data   
    subject = 'file upload update'
    body = """
    file name: {0}
    S3 bucket: {1}
    file type:{2}
    """.format(key, bucket, kind.extension)
    
    
    em = EmailMessage()
    em['From'] = email_sender
    em['To'] = email_receiver
    em['Subject'] = subject
    em.set_content(body)
    context = ssl.create_default_context()

    with smtplib.SMTP_SSL('smtp.gmail.com',465, context=context) as smtp:
        smtp.login(email_sender, email_password)
        smtp.sendmail(email_sender,email_receiver,em.as_string())
