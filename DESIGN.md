# Design

This measure detects when a bucket is created, or an existing bucket's logging settings are updated.

The SQS waits 60 seconds and then alerts the lambda to do a boto call on the bucket.  This allows time for the asynchronous event of PutBucketLogging on a newly created bucket.

## Detection

Since there are no responseElements in the events, we do not know the state of bucket logging **just after** the event was generated.  This means we need to do describe the resource anyway to retreive the current state of the bucket.

