workspace "Cloud Elite Group 4" "Retail Platform Architecture with Agentic AI on GCP" {
    model {
        user = person "Customer" "A web user who interacts with the retail store via a browser."
        employee = person "Employee" "An internal staff member overseeing operations and AI agent actions."

        group "Google Cloud Platform" {
            # Shared Managed Services
            cloudStorage = element "GCP Cloud Storage" "Storage" "Object storage bucket for media, documents, and AI artifacts." {
                tags "Google Cloud Platform - Cloud Storage" "Storage"
            }
            secretManager = element "GCP Secret Manager" "Security" "Stores credentials, database passwords, and AI API keys." {
                tags "Google Cloud Platform - Key Management Service" "Storage"
            }

            # Service A Data Tier
            cloudSqlA = element "Cloud SQL - Core DB" "Database" "Relational database for orders, products, and user accounts." {
                tags "Google Cloud Platform - Cloud SQL" "Database"
            }

            # Service B (AI Agent) Data Tier
            cloudSqlB = element "Cloud SQL - Agent DB" "Database" "Relational database for agent logs, workflows, memory, and task state." {
                tags "Google Cloud Platform - Cloud SQL" "Database"
            }

            # Compute Application System
            cloudRun = softwareSystem "GCP Cloud Run" "Microservices-based retail platform powered by Agentic AI." {
                tags "Google Cloud Platform - Cloud Run"

                frontendApp = container "Frontend Web App" "Serves user UI and handles SSR." "React / Next.js" {
                    tags "Web Browser"
                }

                serviceA = container "Server A - Core" "Manages products, orders, inventory, and checkout." "Java / Spring Boot" {
                    tags "Server"
                }
                
                serviceB = container "Server B - AI Agent" "Autonomous AI agent executing tasks using tools/LLMs." "Java / Spring Boot / LangChain4j" {
                    tags "AI Agent"
                }
            }
        }

        # User / Actor Relationships
        user -> frontendApp "Browses products, places orders, and chats with AI via HTTPS"
        employee -> frontendApp "Monitors agent workflows and store operations via HTTPS"

        # Frontend to Backend Communication
        frontendApp -> serviceA "Calls REST APIs for retail operations"
        frontendApp -> serviceB "Submits prompt requests & queries AI agent via REST/WebSocket"

        # Service-to-Service Communication (API-based, no shared DB)
        serviceB -> serviceA "Invokes domain tools/APIs on behalf of AI agent via REST"

        # Backend Service A Dependencies
        serviceA -> cloudSqlA "Reads/Writes relational transactional data via JDBC"
        serviceA -> cloudStorage "Uploads/Downloads product images & invoices"
        serviceA -> secretManager "Fetches DB credentials on startup"

        # Backend Service B (AI Agent) Dependencies
        serviceB -> cloudSqlB "Stores agent execution logs, memory, and task history via JDBC"
        serviceB -> cloudStorage "Reads documents/knowledge bases for RAG and tool execution"
        serviceB -> secretManager "Fetches LLM API keys and DB credentials on startup"
    }

    views {
        theme "https://static.structurizr.com/themes/google-cloud-platform-v1.5/theme.json"

        systemContext cloudRun "SystemContext" {
            include user employee cloudRun cloudStorage secretManager cloudSqlA cloudSqlB
            autoLayout lr
        }

        container cloudRun "Containers" {
            include *
        }

        styles {
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }
            element "Database" {
                shape cylinder
            }
            element "Storage" {
                shape folder
            }
            element "AI Agent" {
                shape Robot
            }
            element "Server" {
                shape roundedBox
            }
            element "Web Browser" {
                shape webbrowser
            }
            relationship "Relationship" {
                thickness 4
            }
        }
    }
}