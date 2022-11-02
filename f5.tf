resource "random_string" "password" {
  length  = 10
  special = false
}

resource "aws_instance" "f5" {
  #F5 BIGIP-14.1.0.3-0.0.6 PAYG-Good 25Mbps-190326002717
  #ami = "ami-00a9fd893d5d15cf6" for east coast ami
  ami = "ami-09ae9af26d2e96786"

  instance_type               = "m5.xlarge"
  private_ip                  = "10.0.0.200"
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.f5.id]
  user_data                   = data.template_file.f5_init.rendered
  key_name                    = aws_key_pair.demo.key_name
  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name = "${var.prefix}-f5"
    Env  = "vault"
  }
}

data "template_file" "f5_init" {
  template = file("template/f5.tpl")

  vars = {
password = random_string.password.result
  }

}

output "F5_ui" {
  value = "https://${aws_eip.f5.public_ip}:8443"
}


output "F5_Password" {
  value = random_string.password.result
}

