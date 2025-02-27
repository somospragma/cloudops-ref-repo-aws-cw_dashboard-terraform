
######################################################################
# Metricas 
###################################################################### 
locals {
  common_widget_properties = {
    "view"    = "timeSeries"
    "stacked" = false
    "region"  = "us-east-1"
    "period"  = 300
  }
}