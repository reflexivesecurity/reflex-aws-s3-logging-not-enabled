# reflex-aws-s3-logging-not-enabled

A Reflex rule for detecting when a bucket is created without bucket-level logging enabled.

## Usage

To use this rule either add it to your `reflex.yaml` configuration file:

```terraform
version: 0.1

providers:
  - aws

measures:
  - aws-enforce-s3-logging:
      email: "example@example.com"
```

or add it directly to your Terraform:

```terraform
...

module "enforce-s3-logging" {
  source           = "github.com/cloudmitigator/reflex-aws-s3-logging-not-enabled"
  email            = "example@example.com"
}

...
```

## License

This Reflex rule is made available under the MPL 2.0 license. For more information view the [LICENSE](https://github.com/cloudmitigator/reflex-aws-enforce-s3-encryption/blob/master/LICENSE)
