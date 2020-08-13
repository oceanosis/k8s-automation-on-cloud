output "vpc_id" {
  value = aws_vpc.main.id
}

output "bastion_ip" {
  value = aws_instance.bastion.private_ip
}

output "master_ips" {
  value = aws_instance.k8s_master.*.private_ip
}

output "worker_ips" {
  value = aws_instance.k8s_worker.*.private_ip
}