provider "azurerm" {
    features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
    name     = "WebsiteResourceGroup"
    location = "East US"
}

resource "azurerm_storage_account" "storage" {
    name                     = "meinemawebsitestorage3"
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

resource "azurerm_storage_blob" "js_blob" {
    name                   = "main.js"
    storage_account_name   = azurerm_storage_account.storage.name
    storage_container_name = "$web"
    type                   = "Block"
    source                 = "main.js"
    content_type           = "application/javascript"
}

resource "azurerm_cosmosdb_account" "cosmosdb" {
    name                = "meinema-cloud-api-db-2"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    offer_type          = "Standard"
    kind                = "GlobalDocumentDB"
    geo_location {
        location          = azurerm_resource_group.rg.location
        failover_priority = 0
    }
    consistency_policy {
        consistency_level = "Session"
    }
}

resource "azurerm_cosmosdb_sql_database" "database" {
    name                = "CloudWebsiteDatabase"
    resource_group_name = azurerm_resource_group.rg.name
    account_name        = azurerm_cosmosdb_account.cosmosdb.name
}

resource "azurerm_cosmosdb_sql_container" "container" {
    name                = "VisitorCounter"
    resource_group_name = azurerm_resource_group.rg.name
    account_name        = azurerm_cosmosdb_account.cosmosdb.name
    database_name       = azurerm_cosmosdb_sql_database.database.name
    partition_key_path  = "/id"
}

resource "azurerm_service_plan" "appserviceplan" {
    name                = "WebsiteAppServicePlan"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    os_type             = "Linux"
    sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "functionapp" {
    name                       = "websitefunctionapp-meinemawebsite"
    location                   = azurerm_resource_group.rg.location
    resource_group_name        = azurerm_resource_group.rg.name
    service_plan_id            = azurerm_service_plan.appserviceplan.id
    storage_account_name       = azurerm_storage_account.storage.name
    storage_account_access_key = azurerm_storage_account.storage.primary_access_key

    site_config {
        application_stack {
            node_version = "20"
        }
    }

    app_settings = {
        "COSMOS_DB_ENDPOINT" = azurerm_cosmosdb_account.cosmosdb.endpoint
        "COSMOS_DB_KEY"      = azurerm_cosmosdb_account.cosmosdb.primary_key
    }
}

resource "azurerm_function_app_function" "function" {
  name            = "VisitorTrigger"
  function_app_id = azurerm_linux_function_app.functionapp.id
  language        = "Javascript"

  file {
    name    = "index.js"
    content = file("visitor_api/VisitorTrigger/index.js")
  }

  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "anonymous"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "res"
        "type"      = "http"
      },
    ]
  })
}
