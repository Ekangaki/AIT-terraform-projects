resource "aws_s3_bucket" "ekangakis3bucket" {

	bucket = "${var.bucket_name}"
	acl = "private"

	versioning {
		enabled = true
	}
}
