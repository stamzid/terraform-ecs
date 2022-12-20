resource "aws_s3_bucket" "sqlite-db-backup" {
   bucket = "unstructured-poc"
}

resource "aws_s3_bucket_acl" "sqlite_bucket_acl" {
  bucket = aws_s3_bucket.sqlite-db-backup.id
  acl    = "private"
}
