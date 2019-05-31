#Call module/resource

resource "azurerm_log_analytics_workspace" "test" {
  name                = "${var.log_analytics_workspace_name}"
  location            = "${data.azurerm_resource_group.Infr.location}"
  resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  sku                 = "${var.log_analytics_workspace_sku}"
  tags                = "${data.azurerm_resource_group.Infr.tags}"
}

resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = "${azurerm_log_analytics_workspace.test.location}"
  resource_group_name   = "${data.azurerm_resource_group.Infr.name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.test.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.test.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

###
# Create a Key vault certifacte that will be re used by the Kubernetes AKS cluster, see https://www.terraform.io/docs/providers/azurerm/r/key_vault_certificate.html
###
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "test" {
  name                = "keyvaultcertexample"
  location            = "${data.azurerm_resource_group.Infr.location}"
  resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  tenant_id           = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.service_principal_object_id}"

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
  }

  tags = "${data.azurerm_resource_group.Infr.tags}"
}

resource "azurerm_key_vault" "test" {
  name                = "keyvaultcertexample"
  location            = "${data.azurerm_resource_group.Infr.location}"
  resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  tenant_id           = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.service_principal_object_id}"

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
  }

  tags = "${data.azurerm_resource_group.Infr.tags}"
}

resource "azurerm_key_vault_certificate" "test" {
  name         = "generated-cert"
  key_vault_id = "${azurerm_key_vault.test.id}"

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["internal.contoso.com", "domain.hello.world"]
      }

      subject            = "CN=hello-world"
      validity_in_months = 12
    }
  }
}
