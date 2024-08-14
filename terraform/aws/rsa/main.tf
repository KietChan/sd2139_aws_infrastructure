# Generate an RSA key pair
resource "tls_private_key" "k_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create a key pair in AWS using the generated public key
# NOTE: Or we can just load an existing one and have owner create the rest for footprint track
resource "aws_key_pair" "k_key_pair" {
  key_name   = "k-key"
  public_key = tls_private_key.k_private_key.public_key_openssh
}


# Output the private key so you can save it locally
output "private_key_pem" {
  value     = tls_private_key.k_private_key.private_key_pem
  sensitive = true
}

output "key_name" {
  value = aws_key_pair.k_key_pair.key_name
}
