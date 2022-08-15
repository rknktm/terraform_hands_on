#Create  IAM role 
# Iam Role
resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = file("assumerolepolicy.json")
}

# Creating an AWS IAM policy
resource "aws_iam_policy" "s3policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = file("policys3bucket.json")
}

# Attaching the policy to the role
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = [aws_iam_role.ec2_s3_access_role.name]
  policy_arn = aws_iam_policy.s3policy.arn
}

# Creat the IAM instance profile 
resource "aws_iam_instance_profile" "ec2-profile" {
  name  = "ec2-profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

resource "aws_instance" "web-server" {
  ami           = "xxxxxxxxxxxxxxxxx"
  instance_type = "t2.micro"
  key_name = "xxxxxxxxxxxx"
  iam_instance_profile  {
    name = aws_iam_instance_profile.ec2-profile.name
    }
  user_data = file("userdata.sh")
  tags = {
    Name = "my_server"
  }
}