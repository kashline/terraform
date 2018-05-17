provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-east-1"
}

resource "aws_instance" "jenkins_master" {
  # Use an Ubuntu image in eu-west-1
  ami = "ami-43a15f3e"

  instance_type = "t2.micro"

  tags {
    Name = "Jenkins01"
  }

  # We're assuming the subnet and security group have been defined earlx1ier on

  subnet_id                   = "subnet-94889fab"
  security_groups             = ["sg-5a5d8a12"]
  associate_public_ip_address = true
  # We're assuming there's a key with this name already
  key_name = "Default"
  # This is where we configure the instance with ansible-playbook
  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./~/keys/default.pem -i '${aws_instance.jenkins_master.public_ip},' main.yml"
  }
}
