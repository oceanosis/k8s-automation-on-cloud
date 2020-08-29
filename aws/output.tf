//
//output "worker_private_ip_addresses" {
//  value = {
//  for instance in module.worker:
//    instance.instance_id => instance.private_ip
//  }
//}
//
//output "master_private_ip_addresses" {
//  value = {
//  for instance in module.master:
//  instance.instance_id => instance.private_ip
//  }
//}
//
//output "bastion_private_ip_addresses" {
//  value = {
//  for instance in module.bastion:
//  instance.instance_id => instance.private_ip
//  }
//}