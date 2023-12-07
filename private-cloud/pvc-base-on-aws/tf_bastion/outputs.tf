output "ssh_key_pair" {
  value = {
    name        = aws_key_pair.deployment.key_name
    public_key  = data.local_file.ssh_public_key_file
    fingerprint = aws_key_pair.deployment.fingerprint
  }
  description = "CDP Private Cloud bastion"
}

output "instance" {
  value = aws_instance.bastion
}

output "security_group" {
  value = aws_security_group.bastion
}
