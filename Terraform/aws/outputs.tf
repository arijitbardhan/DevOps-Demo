output "private_key_pem_file" {
  value = local_sensitive_file.private_key_pem.filename
  description = "Path to the private key PEM file"
}