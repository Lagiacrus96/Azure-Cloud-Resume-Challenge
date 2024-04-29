provider "azurerm" {
    features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
    name     = "WebsiteResourceGroup"
    location = "East US"
}

resource "azurerm_storage_account" "storage" {
    name                     = "meinemawebsitestorage2"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"

    static_website {
        index_document = "index.html"
        error_404_document = "404.html"
    }
}

resource "azurerm_storage_blob" "html_blob" {
    name                   = "index.html"
    storage_account_name   = azurerm_storage_account.storage.name
    storage_container_name = "$web"
    type                   = "Block"
    source                 = "index.html"
    content_type           = "text/html"
}

resource "azurerm_storage_blob" "css_blob" {
    name                   = "style.css"
    storage_account_name   = azurerm_storage_account.storage.name
    storage_container_name = "$web"
    type                   = "Block"
    source                 = "style.css"
    content_type           = "text/css"
}


