resource "aws_instance" "ziyotek-instance-1" {
  ami                         = data.aws_ami.example.image_id
  instance_type               = var.instance_type
  associate_public_ip_address = true #bool
  subnet_id                   = aws_subnet.devops_subnet_1.id
  key_name                    = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids      = [aws_security_group.ziyotek_devops_all_all.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.id
  user_data                   = file("userdata.sh")
  lifecycle {
      #create_before_destroy = true
      #prevent_destroy = true
      ignore_changes = [tags]
 }
 tags = {
     Terraform = "true"
 }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ziyo_key.public_key_openssh
}

resource "tls_private_key" "ziyo_key" {
  algorithm   = "RSA"
  ecdsa_curve = "P384" 
}

resource "local_file" "ziyo_send" {
    content     = tls_private_key.ziyo_key.private_key_pem
    filename = "../../Keys/devops-class-key.pem"
}

