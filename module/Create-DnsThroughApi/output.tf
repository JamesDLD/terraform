output "dns_records_hosta_ids" {
  value = "${null_resource.dns_records_hosta.*.id}"
}

output "dns_record_publication_ids" {
  value = "${null_resource.dns_records_publication.*.id}"
}
