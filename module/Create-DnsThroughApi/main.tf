resource "null_resource" "dns_records_hosta" {
  count = "${var.Dns_Host_RecordsCount}"

  triggers = {
    dns_fqdn_api         = "${var.dns_fqdn_api}"
    dns_application_name = "${var.dns_application_name}"
    xpod_dns_zone_name   = "${var.xpod_dns_zone_name}"
    dns_hostname         = "${element(var.Dns_Hostnames,count.index)}"
    static_ip            = "${element(var.Dns_Ips,count.index)}"
  }

  provisioner "local-exec" {
    command = "bash ./module/Create-DnsThroughApi/Create-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${var.xpod_dns_zone_name} ${element(var.Dns_Hostnames,count.index)} ${element(var.Dns_Ips,count.index)}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ./module/Create-DnsThroughApi/Delete-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${var.xpod_dns_zone_name} ${element(var.Dns_Hostnames,count.index)} ${element(var.Dns_Ips,count.index)}"
  }
}

resource "null_resource" "dns_records_publication" {
  count = "${var.Dns_Wan_RecordsCount}"

  triggers = {
    dns_fqdn_api         = "${var.dns_fqdn_api}"
    dns_application_name = "${var.dns_application_name}"
    dns_zone_name        = "${var.vpod_dns_zone_name}"
    dns_hostname         = "${lookup(var.Dns_Wan_Records[count.index], "hostname")}"
    static_ip            = "${lookup(var.Dns_Wan_Records[count.index], "static_ip")}"
  }

  provisioner "local-exec" {
    command = "bash ./module/Create-DnsThroughApi/Publish-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${lookup(var.Dns_Wan_Records[count.index], "hostname")} ${lookup(var.Dns_Wan_Records[count.index], "static_ip")}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ./module/Create-DnsThroughApi/Unpublish-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${lookup(var.Dns_Wan_Records[count.index], "hostname")} ${lookup(var.Dns_Wan_Records[count.index], "static_ip")}"
  }
}
