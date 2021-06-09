resource "aws_instance" "k8s-master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  private_ip             = "10.0.0.100"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.k8s-master.id]
  user_data              = file("scripts/k8s-master.sh")
  iam_instance_profile   = aws_iam_instance_profile.k8s.name
  key_name               = aws_key_pair.demo.key_name
  tags = {
    Name = "${var.prefix}-k8s-master"
    Env  = "k8s-master"
  }
}

output "To_SSH_into_k8s-master_ubuntu" {
  value = "ssh -i ${aws_key_pair.demo.key_name}.pem ubuntu@${aws_instance.k8s-master.public_ip}"
}
