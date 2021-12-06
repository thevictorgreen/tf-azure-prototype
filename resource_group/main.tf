module "data_platform_resource_group" {
    source = "../modules/resource_group"
    resource_group_settings = var.resource_group_settings
}