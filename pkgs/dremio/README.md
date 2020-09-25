### On providing access to S3

1. Dremio 4.5.0 does not support providing AWS credentials using K8s service accounts.

From the documentation:

```
  # AWS S3
  # For more details of S3 configuration, see https://docs.dremio.com/deployment/dist-store-config.html#amazon-s3
  #
  # bucketName: The name of the S3 bucket for distributed storage.
  # path: The path, relative to the bucket, to create Dremio's directories.
  # authentication: Valid types are: accessKeySecret or instanceMetadata.
  #   - Note: Instance metadata is only supported in AWS EKS and requires that the
  #       EKS worker node IAM role is configured with sufficient access rights. At this time,
  #       Dremio does not support using an K8s service account based IAM role.
```

To work around this, we need to use the IAM role of the EKS worker node. 
This means that we need to run dremio works on a node group with such permissions.




 
