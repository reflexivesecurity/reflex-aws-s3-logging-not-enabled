""" Module for enforcing S3LoggingNotEnabled """

import json
import os

import boto3
from reflex_core import AWSRule, subscription_confirmation


class S3LoggingNotEnabled(AWSRule):
    """ AWS rule for ensuring S3 bucket logging is enabled """

    client = boto3.client("s3")

    def __init__(self, event):
        super().__init__(event)

    def extract_event_data(self, event):
        """ To be implemented by every rule """
        self.raw_event = event
        self.bucket_name = event["detail"]["requestParameters"]["bucketName"]

    def resource_compliant(self):
        return self.get_bucket_logging()

    def get_bucket_logging(self):
        """
        Returns True if the bucket has LoggingEnabled, False otherwise

        Does NOT inspect TargetBucket, TargetGrants, or TargetPrefix
        """
        try:
            response = self.client.get_bucket_logging(Bucket=self.bucket_name)
            if "LoggingEnabled" in response:
                return True
            return False
        except Exception:
            return False

    def get_remediation_message(self):
        return f"Bucket {self.bucket_name} does not have logging enabled."

def lambda_handler(event, _):
    """ Handles the incoming event """
    print(event)
    if subscription_confirmation.is_subscription_confirmation(event):
        subscription_confirmation.confirm_subscription(event)
        return
    s3_rule = S3LoggingNotEnabled(json.loads(event["Records"][0]["body"]))
    s3_rule.run_compliance_rule()
