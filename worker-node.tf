resource "aws_instance" "k8s-worker" {
  count = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.k8s-wk.id]
  user_data              = file("scripts/k8s-wk.sh")
  iam_instance_profile   = aws_iam_instance_profile.k8s.name
  key_name               = aws_key_pair.demo.key_name
  tags = {
    Name = "${var.prefix}-k8s-wk-${count.index}"
    Env  = "k8s-wk"
  }
}

output "To_SSH_into_k8s-worker" {
  value = ["ssh -i ${aws_key_pair.demo.key_name}.pem ubuntu@${aws_instance.k8s-worker.0.public_ip}","ssh -i ${aws_key_pair.demo.key_name}.pem ubuntu@${aws_instance.k8s-worker.1.public_ip}" ]
}
