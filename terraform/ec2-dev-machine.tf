provider "aws" {
  region     = "us-east-1"
}

resource "aws_key_pair" "smacleod" {
  key_name   = "smacleod-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCPtOkU+zVUm80H0ZiEA7B81wUAzXQDYyBaU1QQFNhuMFw9e6htBXaUII3N2grcNR0RZpttRMtwdf2pDT8SIzYJnElP783fZoYjoeZ5EOQTtq/R6iOnr0oPNLGvRt4bq2/zEWnmhYk36xhfyl/L1F/U9+uRjQTldHGZ7/xC+bif1Wu3UzlX4pSskU+VOL15obd2/6r0JdO/eBsImIc1cMQDzEDkqO37V8T5ywwtv8mIEqdaUtfsRpiG1jC+QjCZn1P2V8tLVuTxR3KTMt8w0hpWjsEg/DCmN8uGYpZ67EmUwqSucLFRzdwxQU02MLxPNkP5nw847eWKpAJZCLNQ6e1LxhlRTvRhqU/5Rd0MykoJtKwI2E/wCvP9zyCsHQFpMaBsWXcgoVsEBraraErCOfeVJ4WnbQkiV/n2/p/KM+1o0ZYWTvE5LEFDHio4w2xvo6AyHPHqxzAmxGdutFdVk7QUbUxLL9prEhHALV/fT/BsNmesPn9Pr4HhooevMS/w6BWF44fA2hkjACbWcxHNMthVtDbNAh2mZC3gXtlARs/aw9JqVs0KcYjxdw1cGews7Shss/2tGAMIxV9lVOcU5KSjgwddDdFylR3Aqg8SEikmRXl2tI4P5ek+dSqGOiKOvQngJADA/FSxPQfL68AbOTZc77++XgBrHkI3xZaz/VfSw== Key for Mozilla Workstation 02"
}

resource "aws_instance" "dev-machine" {
  ami           = "ami-cbae11b1"
  instance_type = "m4.xlarge"
  key_name = "${aws_key_pair.smacleod.id}"

  tags {
    Owner = "smacleod"
    App = "smacleod"
    Type = "smacleod"
    REAPER_SPARE_ME = "true"
  }
}


variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_domain" {}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

# Add a record to the domain
resource "cloudflare_record" "mozilla-dev-machine" {
  domain = "${var.cloudflare_domain}"
  name   = "mozilla-dev-machine"
  value  = "${aws_instance.dev-machine.public_ip}"
  type   = "A"
}
