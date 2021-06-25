/*
  Description:
  Setup common infrastructure
*/

module "sap_landscape" {
  providers = {
    azurerm.main     = azurerm.main
    azurerm.deployer = azurerm.deployer
  }
  source                      = "../../terraform-units/modules/sap_landscape"
  infrastructure              = var.infrastructure
  options                     = local.options
  authentication              = var.authentication
  naming                      = module.sap_namegenerator.naming
  service_principal           = local.service_principal
  key_vault                   = var.key_vault
  deployer_tfstate            = try(data.terraform_remote_state.deployer[0].outputs, [])
  diagnostics_storage_account = var.diagnostics_storage_account
  witness_storage_account     = var.witness_storage_account

  use_deployer               = length(var.deployer_tfstate_key) > 0
  dns_label                  = var.dns_label
  dns_resource_group_name    = length(var.private_dns_resource_group) > 0 ? var.private_dns_resource_group :local.saplib_resource_group_name
}

module "sap_namegenerator" {
  source             = "../../terraform-units/modules/sap_namegenerator"
  environment        = var.infrastructure.environment
  location           = var.infrastructure.region
  iscsi_server_count = local.iscsi_count
  codename           = lower(try(var.infrastructure.codename, ""))
  random_id          = module.sap_landscape.random_id
  sap_vnet_name      = local.vnet_logical_name
}
