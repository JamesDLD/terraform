resource "null_resource" "vm_dns_records" {
  count = "${var.Dns_Vms_RecordsCount}"

  triggers = {
    dns_fqdn_api         = "${var.dns_fqdn_api}"
    dns_application_name = "${var.dns_application_name}"
    xpod_dns_zone_name   = "${var.xpod_dns_zone_name}"
    dns_hostname         = "${var.vm_prefix}${lookup(var.Vms[count.index], "suffix_name")}${lookup(var.Vms[count.index], "id")}"
    static_ip            = "${lookup(var.Vms[count.index], "static_ip")}"
  }

  provisioner "local-exec" {
    command = "bash ./modules/Create-DnsThroughApi/Create-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${var.xpod_dns_zone_name} ${var.vm_prefix}${lookup(var.Vms[count.index], "suffix_name")}${lookup(var.Vms[count.index], "id")} ${lookup(var.Vms[count.index], "static_ip")}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ./modules/Create-DnsThroughApi/Delete-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${var.xpod_dns_zone_name} ${var.vm_prefix}${lookup(var.Vms[count.index], "suffix_name")}${lookup(var.Vms[count.index], "id")} ${lookup(var.Vms[count.index], "static_ip")}"
  }
}

resource "null_resource" "lb_dns_records" {
  count = "${var.Dns_Lbs_RecordsCount}"

  triggers = {
    dns_fqdn_api         = "${var.dns_fqdn_api}"
    dns_application_name = "${var.dns_application_name}"
    xpod_dns_zone_name   = "${var.xpod_dns_zone_name}"
    dns_hostname         = "${var.lb_prefix}${lookup(var.Lbs[count.index], "suffix_name")}"
    static_ip            = "${lookup(var.Lbs[count.index], "static_ip")}"
  }

  provisioner "local-exec" {
    command = "bash ./modules/Create-DnsThroughApi/Create-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${var.xpod_dns_zone_name} ${var.lb_prefix}${lookup(var.Lbs[count.index], "suffix_name")} ${lookup(var.Lbs[count.index], "static_ip")}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ./modules/Create-DnsThroughApi/Delete-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${var.xpod_dns_zone_name} ${var.lb_prefix}${lookup(var.Lbs[count.index], "suffix_name")} ${lookup(var.Lbs[count.index], "static_ip")}"
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
    command = "bash ./modules/Create-DnsThroughApi/Publish-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${lookup(var.Dns_Wan_Records[count.index], "hostname")} ${lookup(var.Dns_Wan_Records[count.index], "static_ip")}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ./modules/Create-DnsThroughApi/Unpublish-Dns.sh ${var.dns_fqdn_api} ${var.dns_secret} ${var.dns_application_name} ${lookup(var.Dns_Wan_Records[count.index], "hostname")} ${lookup(var.Dns_Wan_Records[count.index], "static_ip")}"
  }
}
