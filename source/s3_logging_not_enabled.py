""" Module for enforcing S3LoggingRule """

import json
import os

import boto3
from reflex_core import AWSRule


class S3LoggingRule(AWSRule):
    """ AWS rule for ensuring S3 bucket logging is enabled """

    client = boto3.client("s3")

    def __init__(self, event):
        super().__init__(event)

    def remediate(self):
        pass

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
            if ("LoggingEnabled" in response):
                return True
            else:
                return False
        except Exception:
            return False

    def get_remediation_message(self):
        if self.resource_compliant() is True:
            return f"Bucket has logging enabled. Bucket: {self.bucket_name}"
        else:
            return f"Bucket does not have logging enabled." \
                   f" bucket: {self.raw_event}," \
                   f" event: {self.raw_event}"

def lambda_handler(event, _):
    """ Handles the incoming event """
    print(event)
    s3_rule = S3LoggingRule(json.loads(event["Records"][0]["body"]))
    s3_rule.run_compliance_rule()
