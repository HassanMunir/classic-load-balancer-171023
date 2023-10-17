# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_public]

  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("private-key/hm-keypair.pem")
  }

  ## File Provisioner: Copies the hm-keypair.pem file to /tmp/hm-keypair.pem
  provisioner "file" {
    source      = "private-key/hm-keypair.pem"
    destination = "/tmp/hm-keypair.pem"
  }

  ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/hm-keypair.pem"
    ]
  }
}
