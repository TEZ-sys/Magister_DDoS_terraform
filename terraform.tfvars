vpc_cidr          = "172.16.0.0/16"
public_subnet     = "172.16.1.0/24"
sub_public_subnet = "172.16.2.0/24"
private_subnet    = "172.16.3.0/24"
CIDR              = ["0.0.0.0/0"]
ports             = ["22", "80", "443", "6379"]
inst_type         = "t3.small"
region            = "eu-west-2"

network_threshold = 2000000
comparison        = "GreaterThanOrEqualToThreshold"
email_address     = ""
secret_arn        = ""