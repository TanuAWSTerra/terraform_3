resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })


  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_policy" "test_policy" {
  name = "test_policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },

      #second policy
      {
        Action = [
          "s3:readonly",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.test_policy.arn
}
resource "aws_iam_instance_profile" "ec2app" {
  name = "ec2app"
  role = aws_iam_role.test_role.name

}
resource "aws_instance" "Tanu1" {
  instance_type        = "t2.micro"
  ami                  = "ami-027d95b1c717e8c5d"
  key_name             = "webkey"
  iam_instance_profile = aws_iam_instance_profile.ec2app.name

}
