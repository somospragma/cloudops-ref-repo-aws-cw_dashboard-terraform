resource "aws_cloudwatch_dashboard" "main" {
  for_each       = { for d in var.dashboard_configs : d.functionality => d }
  dashboard_name = "${var.client}-${var.project}-${var.environment}-${var.application}-${each.value.functionality}"
  dashboard_body = jsonencode({
    "widgets" =  concat(
    ######################################################################
    # Monitoreo ECS
    ######################################################################  
     lookup(each.value.services, "ec2", false) ? [
      {
        "type"   = "text"
        "width"  = 24
        "height" = 1
        "properties" = {
          "markdown" = "# **Monitoreo Comportamiento Computo**"
        }
      },
      {
        "type"   = "text"
        "width"  = 24
        "height" = 1
        "properties" = {
          "markdown" = "## [**Amazon Elastic Compute Cloud (Amazon EC2)**](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Home:)"
        }
      }
    ] : [],
     lookup(each.value.services, "ec2", false) ? [
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{ "expression" : "SEARCH('{AWS/EC2,InstanceId} MetricName=\"CPUUtilization\"', 'Average', 300)", "label" : "CPUUtilization(Average)", "id" : "cpuutilization", "region" : "us-east-1" }]]
          "title"   = "Widget de Procesamiento EC2"
        })
      },
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{ "expression" : "SEARCH('{AWS/EC2,InstanceId} MetricName=\"NetworkPacketsOut\"', 'Average', 300)", "label" : "NetworkPacketsOut(Average)", "id" : "networkpacketsout", "region" : "us-east-1" }]]
          "title"   = "Widget de Red EC2"
        })
      },
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('CWAgent,InstanceId,path=\"/\" MetricName=\"disk_used_percent\"', 'Maximum', 300)",
            "label" : "disk_used_percent(Maximum)",
            "id" : "diskusage",
            "region" : "us-east-1"
          }]]
          "title" = "Uso de Disco EC2"
        })
      },
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('{AWS/EC2,InstanceId} MetricName=\"StatusCheckFailed\"', 'Maximum', 300)",
            "label" : "StatusCheckFailed(Maximum)",
            "id" : "statuscheckfailed",
            "region" : "us-east-1"
          }]]
          "title" = "Estado de Verificación EC2"
        })
      }

    ] : [],

    ######################################################################
    # Monitoreo RDS
    ######################################################################  
     lookup(each.value.services, "rds", false) ? [
      {
        "type"   = "text"
        "width"  = 24
        "height" = 1
        "properties" = {
          "markdown" = "# **Monitoreo Comportamiento Base De Datos**"
        }
      },
      {
        "type"   = "text"
        "width"  = 24
        "height" = 1
        "properties" = {
          "markdown" = "## [**Amazon Relational Database Service (Amazon RDS)**](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Home:)"
        }
      }
    ] : [],
    lookup(each.value.services, "rds", false) ? [
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{ "expression" : "SEARCH('{AWS/RDS,DBInstanceIdentifier} MetricName=\"CPUUtilization\"', 'Average', 300)", "label" : "CPUUtilization(Average)", "id" : "cpuutilization", "region" : "us-east-1" }]]
          "title"   = "Widget de CPU RDS"
        })
      },
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{ "expression" : "SEARCH('{AWS/RDS,DBInstanceIdentifier} MetricName=\"FreeableMemory\"', 'Average', 300)", "label" : "FreeableMemory(Average)", "id" : "freeablememory", "region" : "us-east-1" }]]
          "title"   = "Widget de Memoria RDS"
        })
      },
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{ "expression" : "SEARCH('{AWS/RDS,DBInstanceIdentifier} MetricName=\"DatabaseConnections\"', 'Average', 300)", "label" : "DatabaseConnections(Average)", "id" : "databaseconnections", "region" : "us-east-1" }]]
          "title"   = "Widget de Conexiones RDS"
        })
      },
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{ "expression" : "SEARCH('{AWS/RDS,DBInstanceIdentifier} MetricName=\"VolumeBytesUsed\"', 'Average', 300)", "label" : "VolumeBytesUsed(Average)", "id" : "volumebytesused", "region" : "us-east-1" }]]
          "title"   = "Widget de Uso de Almacenamiento RDS"
        })
      }
    ] : [],

    ######################################################################
    # Monitoreo AWS DynamoDB
    ######################################################################
    lookup(each.value.services, "dynamodb", false) ? [
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "# **Monitoreo AWS DynamoDB**"
        }
      },
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "## [**AWS DynamoDB**](https://console.aws.amazon.com/dynamodb/home?region=us-east-1)"
        }
      }
    ] : [],
    lookup(each.value.services, "dynamodb", false)  ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/DynamoDB\" MetricName=\"ConsumedReadCapacityUnits\"', 'Sum', 300)",
            "label"      : "Lecturas Consumidas",
            "id"         : "read_capacity",
            "region"     : "us-east-1"
          }]],
          "title" = "Lecturas Consumidas"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/DynamoDB\" MetricName=\"ConsumedWriteCapacityUnits\"', 'Sum', 300)",
            "label"      : "Escrituras Consumidas",
            "id"         : "write_capacity",
            "region"     : "us-east-1"
          }]],
          "title" = "Escrituras Consumidas"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/DynamoDB\" MetricName=\"ThrottledRequests\"', 'Sum', 300)",
            "label"      : "Solicitudes Limitadas",
            "id"         : "throttled_requests",
            "region"     : "us-east-1"
          }]],
          "title" = "Solicitudes Limitadas"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/DynamoDB\" MetricName=\"SuccessfulRequestLatency\"', 'Average', 300)",
            "label"      : "Latencia de Solicitudes Exitosas",
            "id"         : "successful_latency",
            "region"     : "us-east-1"
          }]],
          "title" = "Latencia de Solicitudes Exitosas"
        })
      }
    ] : [],

    ######################################################################
    # Monitoreo Amazon ECS
    ######################################################################
    lookup(each.value.services, "ecs", false)  ? [
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "# **Monitoreo Amazon ECS**"
        }
      },
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "## [**Amazon ECS**](https://console.aws.amazon.com/ecs/home?region=us-east-1)"
        }
      }
    ] : [],

    ######################################################################
    # ECS Cluster Metrics (CPUUtilization, MemoryUtilization)
    ######################################################################
    lookup(each.value.services, "ecs", false)  ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"CPUUtilization\"', 'Average', 300)",
            "label"      : "Uso de CPU del Cluster",
            "id"         : "cpu_cluster",
            "region"     : "us-east-1"
          }]],
          "title" = "Uso de CPU del Cluster (%)"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"MemoryUtilization\"', 'Average', 300)",
            "label"      : "Uso de Memoria del Cluster",
            "id"         : "memory_cluster",
            "region"     : "us-east-1"
          }]],
          "title" = "Uso de Memoria del Cluster (%)"
        })
      }
    ] : [],

    ######################################################################
    # ECS Service Metrics (CPUUtilization, MemoryUtilization, DesiredCount, RunningCount, PendingCount)
    ######################################################################
    lookup(each.value.services, "ecs", false)  ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"CPUUtilization\" ServiceName!=NULL', 'Average', 300)",
            "label"      : "Uso de CPU del Servicio",
            "id"         : "cpu_service",
            "region"     : "us-east-1"
          }]],
          "title" = "Uso de CPU del Servicio (%)"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"MemoryUtilization\" ServiceName!=NULL', 'Average', 300)",
            "label"      : "Uso de Memoria del Servicio",
            "id"         : "memory_service",
            "region"     : "us-east-1"
          }]],
          "title" = "Uso de Memoria del Servicio (%)"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"DesiredTaskCount\"', 'Maximum', 300)",
            "label"      : "Tareas Deseadas",
            "id"         : "desired_tasks",
            "region"     : "us-east-1"
          }]],
          "title" = "Tareas Deseadas"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"RunningTaskCount\"', 'Maximum', 300)",
            "label"      : "Tareas en Ejecución",
            "id"         : "running_tasks",
            "region"     : "us-east-1"
          }]],
          "title" = "Tareas en Ejecución"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"PendingTaskCount\"', 'Maximum', 300)",
            "label"      : "Tareas Pendientes",
            "id"         : "pending_tasks",
            "region"     : "us-east-1"
          }]],
          "title" = "Tareas Pendientes"
        })
      }
    ] : [],

    ######################################################################
    # ECS Task Metrics (CPUUtilization, MemoryUtilization)
    ######################################################################
    lookup(each.value.services, "ecs", false)  ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"CPUUtilization\" TaskDefinitionFamily!=NULL', 'Average', 300)",
            "label"      : "Uso de CPU por Tarea",
            "id"         : "cpu_task",
            "region"     : "us-east-1"
          }]],
          "title" = "Uso de CPU por Tarea (%)"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/ECS\" MetricName=\"MemoryUtilization\" TaskDefinitionFamily!=NULL', 'Average', 300)",
            "label"      : "Uso de Memoria por Tarea",
            "id"         : "memory_task",
            "region"     : "us-east-1"
          }]],
          "title" = "Uso de Memoria por Tarea (%)"
        })
      }
    ] : [],

    ######################################################################
    # Monitoreo Amazon SES
    ######################################################################
    lookup(each.value.services, "ses", false)  ? [
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "# **Monitoreo Amazon SES**"
        }
      },
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "## [**Amazon SES**](https://console.aws.amazon.com/ses/home?region=us-east-1)"
        }
      }
    ] : [],
    lookup(each.value.services, "ses", false) ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/SES\" MetricName=\"Send\"', 'Sum', 300)",
            "label"      : "Correos Enviados",
            "id"         : "send",
            "region"     : "us-east-1"
          }]],
          "title" = "Correos Enviados"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/SES\" MetricName=\"DeliveryAttempts\"', 'Sum', 300)",
            "label"      : "Intentos de Entrega",
            "id"         : "delivery_attempts",
            "region"     : "us-east-1"
          }]],
          "title" = "Intentos de Entrega"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/SES\" MetricName=\"Bounces\"', 'Sum', 300)",
            "label"      : "Correos Rebotados",
            "id"         : "bounces",
            "region"     : "us-east-1"
          }]],
          "title" = "Correos Rebotados"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/SES\" MetricName=\"Complaints\"', 'Sum', 300)",
            "label"      : "Quejas de Usuarios",
            "id"         : "complaints",
            "region"     : "us-east-1"
          }]],
          "title" = "Quejas de Usuarios"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/SES\" MetricName=\"Rejects\"', 'Sum', 300)",
            "label"      : "Correos Rechazados",
            "id"         : "rejects",
            "region"     : "us-east-1"
          }]],
          "title" = "Correos Rechazados"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/SES\" MetricName=\"Reputation.BounceRate\"', 'Average', 300)",
            "label"      : "Tasa de Rebote de Reputación",
            "id"         : "reputation_bounce_rate",
            "region"     : "us-east-1"
          }]],
          "title" = "Tasa de Rebote (%)"
        })
      }
    ] : [],

    ######################################################################
    # Monitoreo AWS CloudFront
    ######################################################################
    lookup(each.value.services, "cloudfront", false) ? [
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "# **Monitoreo AWS CloudFront**"
        }
      },
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "## [**AWS CloudFront**](https://console.aws.amazon.com/cloudfront/home?region=us-east-1)"
        }
      }
    ] : [],
    lookup(each.value.services, "cloudfront", false) ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/CloudFront\" MetricName=\"Requests\"', 'Sum', 300)",
            "label"      : "Solicitudes",
            "id"         : "requests",
            "region"     : "us-east-1"
          }]],
          "title" = "Total de Solicitudes"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/CloudFront\" MetricName=\"BytesDownloaded\"', 'Sum', 300)",
            "label"      : "Bytes Descargados",
            "id"         : "bytes_downloaded",
            "region"     : "us-east-1"
          }]],
          "title" = "Bytes Descargados"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/CloudFront\" MetricName=\"BytesUploaded\"', 'Sum', 300)",
            "label"      : "Bytes Subidos",
            "id"         : "bytes_uploaded",
            "region"     : "us-east-1"
          }]],
          "title" = "Bytes Subidos"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/CloudFront\" MetricName=\"TotalErrorRate\"', 'Average', 300)",
            "label"      : "Tasa de Errores Total",
            "id"         : "total_error_rate",
            "region"     : "us-east-1"
          }]],
          "title" = "Tasa de Errores Total (%)"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/CloudFront\" MetricName=\"4xxErrorRate\"', 'Average', 300)",
            "label"      : "Tasa de Errores 4xx",
            "id"         : "4xx_error_rate",
            "region"     : "us-east-1"
          }]],
          "title" = "Tasa de Errores 4xx (%)"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/CloudFront\" MetricName=\"5xxErrorRate\"', 'Average', 300)",
            "label"      : "Tasa de Errores 5xx",
            "id"         : "5xx_error_rate",
            "region"     : "us-east-1"
          }]],
          "title" = "Tasa de Errores 5xx (%)"
        })
      }
    ] : [],

    ######################################################################
    # Monitoreo AWS SQS
    ######################################################################
    lookup(each.value.services, "sqs", false) ? [
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "# **Monitoreo AWS SQS**"
        }
      },
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "## [**AWS SQS**](https://console.aws.amazon.com/sqs/home?region=us-east-1)"
        }
      }
    ] : [],
    lookup(each.value.services, "sqs", false) ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/SQS\" MetricName=\"NumberOfMessagesSent\"', 'Sum', 300)",
            "label"      : "Mensajes Enviados",
            "id"         : "messages_sent",
            "region"     : "us-east-1"
          }]],
          "title" = "Mensajes Enviados"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/SQS\" MetricName=\"NumberOfMessagesReceived\"', 'Sum', 300)",
            "label"      : "Mensajes Recibidos",
            "id"         : "messages_received",
            "region"     : "us-east-1"
          }]],
          "title" = "Mensajes Recibidos"
        })
      }
    ] : [],
  
    ######################################################################
    # Monitoreo AWS Lambda
    ######################################################################
    lookup(each.value.services, "lambda", false) ? [
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "# **Monitoreo AWS Lambda**"
        }
      },
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "## [**AWS Lambda**](https://console.aws.amazon.com/lambda/home?region=us-east-1)"
        }
      }
    ] : [],
    lookup(each.value.services, "lambda", false) ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/Lambda\" MetricName=\"Invocations\"', 'Sum', 300)",
            "label"      : "Invocaciones",
            "id"         : "invocations",
            "region"     : "us-east-1"
          }]],
          "title" = "Total de Invocaciones"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/Lambda\" MetricName=\"Errors\"', 'Sum', 300)",
            "label"      : "Errores",
            "id"         : "errors",
            "region"     : "us-east-1"
          }]],
          "title" = "Errores en Lambda"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/Lambda\" MetricName=\"Duration\"', 'Average', 300)",
            "label"      : "Duración Promedio",
            "id"         : "duration",
            "region"     : "us-east-1"
          }]],
          "title" = "Duración Promedio (ms)"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/Lambda\" MetricName=\"Throttles\"', 'Sum', 300)",
            "label"      : "Throttle Count",
            "id"         : "throttles",
            "region"     : "us-east-1"
          }]],
          "title" = "Throttle Count"
        })
      }
    ] : [],

    ######################################################################
    # Monitoreo S3
    ######################################################################
    lookup(each.value.services, "s3", false) ? [
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "# **Monitoreo Amazon S3**"
        }
      },
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "## [**Amazon S3**](https://s3.console.aws.amazon.com/s3/home?region=us-east-1)"
        }
      }
    ] : [],
    lookup(each.value.services, "s3", false) ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/S3\" MetricName=\"NumberOfObjects\"', 'Average', 86400)",
            "label"      : "Número de Objetos (Promedio)",
            "id"         : "num_objects",
            "region"     : "us-east-1"
          }]],
          "title" = "Número de Objetos en S3"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/S3\" MetricName=\"BucketSizeBytes\"', 'Average', 86400)",
            "label"      : "Tamaño del Bucket (Promedio)",
            "id"         : "bucket_size",
            "region"     : "us-east-1"
          }]],
          "title" = "Tamaño del Bucket en S3 (Bytes)"
        })
      }
    ] : [],

    ######################################################################
    # Monitoreo NLB
    ######################################################################
    lookup(each.value.services, "nlb", false) ? [
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "# **Monitoreo Network Load Balancer (NLB)**"
        }
      },
      {
        "type"   = "text",
        "width"  = 24,
        "height" = 1,
        "properties" = {
          "markdown" = "## [**Amazon Network Load Balancer**](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#LoadBalancers:)"
        }
      }
    ] : [],
    lookup(each.value.services, "nlb", false) ? [
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/NetworkELB\" MetricName=\"ActiveFlowCount\"', 'Average', 300)",
            "label"      : "ActiveFlowCount (Average)",
            "id"         : "activeflowcount",
            "region"     : "us-east-1"
          }]],
          "title" = "Flujos Activos en NLB"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/NetworkELB\" MetricName=\"ProcessedBytes\"', 'Sum', 300)",
            "label"      : "ProcessedBytes (Sum)",
            "id"         : "processedbytes_nlb",
            "region"     : "us-east-1"
          }]],
          "title" = "Bytes Procesados por NLB"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/NetworkELB\" MetricName=\"NewFlowCount\"', 'Sum', 300)",
            "label"      : "NewFlowCount (Sum)",
            "id"         : "newflowcount",
            "region"     : "us-east-1"
          }]],
          "title" = "Nuevos Flujos en NLB"
        })
      },
      {
        "type"   = "metric",
        "width"  = 12,
        "height" = 6,
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=\"AWS/NetworkELB\" MetricName=\"HealthyHostCount\"', 'Average', 300)",
            "label"      : "HealthyHostCount (Average)",
            "id"         : "healthyhostcount_nlb",
            "region"     : "us-east-1"
          }]],
          "title" = "Hosts Saludables en NLB"
        })
      }
    ] : [],

    ######################################################################
    # Monitoreo ALB
    ######################################################################
    lookup(each.value.services, "alb", false) ? [
        {
          "type"   = "text",
          "width"  = 24,
          "height" = 1,
          "properties" = {
            "markdown" = "# **Monitoreo Application Load Balancer (ALB)**"
          }
        },
        {
          "type"   = "text",
          "width"  = 24,
          "height" = 1,
          "properties" = {
            "markdown" = "## [**Amazon Application Load Balancer**](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#LoadBalancers:)"
          }
        }
      ] : [],
      lookup(each.value.services, "alb", false) ? [
        {
          "type"   = "metric",
          "width"  = 12,
          "height" = 6,
          "properties" = merge(local.common_widget_properties, {
            "metrics" = [[{
              "expression" : "SEARCH('Namespace=\"AWS/ApplicationELB\" MetricName=\"RequestCount\"', 'Sum', 300)",
              "label"      : "RequestCount (Sum)",
              "id"         : "requestcount",
              "region"     : "us-east-1"
            }]],
            "title" = "Conteo de Solicitudes ALB"
          })
        },
        {
          "type"   = "metric",
          "width"  = 12,
          "height" = 6,
          "properties" = merge(local.common_widget_properties, {
            "metrics" = [[{
              "expression" : "SEARCH('Namespace=\"AWS/ApplicationELB\" MetricName=\"HTTPCode_ELB_4XX_Count\"', 'Sum', 300)",
              "label"      : "HTTPCode_ELB_4XX_Count (Sum)",
              "id"         : "httpcode_elb_4xx_count",
              "region"     : "us-east-1"
            }]],
            "title" = "Errores 4XX en ALB"
          })
        },
        {
          "type"   = "metric",
          "width"  = 12,
          "height" = 6,
          "properties" = merge(local.common_widget_properties, {
            "metrics" = [[{
              "expression" : "SEARCH('Namespace=\"AWS/ApplicationELB\" MetricName=\"HTTPCode_ELB_5XX_Count\"', 'Sum', 300)",
              "label"      : "HTTPCode_ELB_5XX_Count (Sum)",
              "id"         : "httpcode_elb_5xx_count",
              "region"     : "us-east-1"
            }]],
            "title" = "Errores 5XX en ALB"
          })
        },
        {
          "type"   = "metric",
          "width"  = 12,
          "height" = 6,
          "properties" = merge(local.common_widget_properties, {
            "metrics" = [[{
              "expression" : "SEARCH('Namespace=\"AWS/ApplicationELB\" MetricName=\"TargetResponseTime\"', 'Average', 300)",
              "label"      : "TargetResponseTime (Average)",
              "id"         : "targetresponsetime",
              "region"     : "us-east-1"
            }]],
            "title" = "Tiempo de Respuesta de Objetivos ALB"
          })
        },
        {
          "type"   = "metric",
          "width"  = 12,
          "height" = 6,
          "properties" = merge(local.common_widget_properties, {
            "metrics" = [[{
              "expression" : "SEARCH('Namespace=\"AWS/ApplicationELB\" MetricName=\"UnHealthyHostCount\"', 'Average', 300)",
              "label"      : "UnHealthyHostCount (Average)",
              "id"         : "unhealthyhostcount",
              "region"     : "us-east-1"
            }]],
            "title" = "Conteo de Hosts No Saludables ALB"
          })
        },
        {
          "type"   = "metric",
          "width"  = 12,
          "height" = 6,
          "properties" = merge(local.common_widget_properties, {
            "metrics" = [[{
              "expression" : "SEARCH('Namespace=\"AWS/ApplicationELB\" MetricName=\"HealthyHostCount\"', 'Average', 300)",
              "label"      : "HealthyHostCount (Average)",
              "id"         : "healthyhostcount",
              "region"     : "us-east-1"
            }]],
            "title" = "Conteo de Hosts Saludables ALB"
          })
        },
        {
          "type"   = "metric",
          "width"  = 12,
          "height" = 6,
          "properties" = merge(local.common_widget_properties, {
            "metrics" = [[{
              "expression" : "SEARCH('Namespace=\"AWS/ApplicationELB\" MetricName=\"ProcessedBytes\"', 'Sum', 300)",
              "label"      : "ProcessedBytes (Sum)",
              "id"         : "processedbytes",
              "region"     : "us-east-1"
            }]],
            "title" = "Bytes Procesados por ALB"
          })
        },
        {
          "type"   = "metric",
          "width"  = 12,
          "height" = 6,
          "properties" = merge(local.common_widget_properties, {
            "metrics" = [[{
              "expression" : "SEARCH('Namespace=\"AWS/ApplicationELB\" MetricName=\"ActiveConnectionCount\"', 'Average', 300)",
              "label"      : "ActiveConnectionCount (Average)",
              "id"         : "activeconnectioncount",
              "region"     : "us-east-1"
            }]],
            "title" = "Conexiones Activas en ALB"
          })
        }
      ] : [],

    ######################################################################
    # Monitoreo API Gateway
    ######################################################################
     lookup(each.value.services, "apigateway", false) ? [
      {
        "type"   = "text"
        "width"  = 24
        "height" = 1
        "properties" = {
          "markdown" = "# **Monitoreo Comportamiento MicroServicios**"
        }
      },
      {
        "type"   = "text"
        "width"  = 24
        "height" = 1
        "properties" = {
          "markdown" = "## [**Amazon API Gateway**](https://us-east-1.console.aws.amazon.com/apigateway/main/apis?region=us-east-1)"
        }
      }
    ] : [],
    lookup(each.value.services, "apigateway", false) ? [
      # Widget para Errores 4XX
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=AWS/ApiGateway MetricName=4XXError', 'SampleCount', 300)",
            "label" : "Errores 4XX",
            "id" : "errors4XX",
            "region" : "us-east-1"
          }]]
          "title" = "Errores 4XX en API Gateway"
          "stat"  = "SampleCount"
        })
      },

      # Widget para Errores 5XX
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=AWS/ApiGateway MetricName=5XXError', 'SampleCount', 300)",
            "label" : "Errores 5XX",
            "id" : "errors5XX",
            "region" : "us-east-1"
          }]]
          "title" = "Errores 5XX en API Gateway"
          "stat"  = "SampleCount"
        })
      },

      # Widget para Conteo de Solicitudes
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=AWS/ApiGateway MetricName=Count', 'SampleCount', 300)",
            "label" : "Conteo de Solicitudes",
            "id" : "requestCount",
            "region" : "us-east-1"
          }]]
          "title" = "Conteo de Solicitudes en API Gateway"
          "stat"  = "SampleCount"
        })
      },

      # Widget para Latencia
      {
        "type"   = "metric"
        "width"  = 12
        "height" = 6
        "properties" = merge(local.common_widget_properties, {
          "metrics" = [[{
            "expression" : "SEARCH('Namespace=AWS/ApiGateway MetricName=Latency', 'Average', 300)",
            "label" : "Latencia",
            "id" : "latency",
            "region" : "us-east-1"
          }]]
          "title" = "Latencia en API Gateway"
          "stat"  = "Average"
        })
      }
    ] : []
  )
  })
}
