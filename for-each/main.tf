provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
}

/*
For each value in the env_regions map variable, we create
a bucket with the map key in the bucket name and the map
value as the region.
*/
resource aws_s3_bucket sample {
  for_each = var.env_regions
  bucket = "${var.unique_prefx}-sample-${each.key}"
  region = each.value
  acl = "private"
}

/*
For each of the sample buckets, create an access block using
the set of buckets to iterate over "aws_s3_bucket.sample". With
that, each bucket ID can be access with each.value.id.
*/
resource aws_s3_bucket_public_access_block sample {
  for_each = aws_s3_bucket.sample
  bucket = each.value.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


/*
A single policy document (no for_each) that permits "s3:PutObject"
access to all of the sample S3 buckets.
*/
data aws_iam_policy_document sample_put_object {
  statement {
    actions = [
      "s3:PutObject"]
    resources = values(aws_s3_bucket.sample)[*].arn
  }
}

resource aws_iam_policy sample_put_object {
  name = "sample-put"
  policy = data.aws_iam_policy_document.sample_put_object.json
}
