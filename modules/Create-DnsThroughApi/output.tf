output "vm_dns_record_ids" {
  value = "${null_resource.vm_dns_records.*.id}"
}

output "lb_dns_record_ids" {
  value = "${null_resource.lb_dns_records.*.id}"
}

output "dns_record_publication_ids" {
  value = "${null_resource.dns_records_publication.*.id}"
}
