# Cloud Resume Challenge with Terraform

## Introduction

Welcome to my Cloud Resume Challenge project using Terraform! This repository is part of my journey to showcase my skills and experiences in cloud computing, specifically using Terraform to provision cloud resources.

## Project Overview

In this initial commit, I've set up a basic infrastructure using Terraform to create a storage account capable of hosting a static website on Azure. The website content can be uploaded to the storage account, and the storage account is configured to serve the content as a static website.

## Table of Contents

- [Getting Started](#getting-started)
- [Infrastructure Overview](#infrastructure-overview)
- [Usage](#usage)
- [Next Steps](#next-steps)
- [Resources](#resources)

## Getting Started

To get started with this project, you'll need:

- An Azure account
- Terraform installed on your local machine
- Azure CLI installed (optional but recommended for authentication)

## Infrastructure Overview

The infrastructure created in this commit consists of:

- **Azure Storage Account**: Used to store website files and serve them as a static website.

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/your-username/cloud-resume-challenge.git
   ```

2. Navigate to the project directory:

   ```bash
   cd cloud-resume-challenge
   ```

3. Initialize Terraform:

   ```bash
   terraform init
   ```

4. Review and modify `main.tf` and `variables.tf` files as needed.

5. Apply the Terraform configuration:

   ```bash
   terraform apply
   ```

6. After the provisioning is complete, Terraform will output the endpoint URL of the static website.

7. Upload your website content to the storage account.

8. Access your static website using the provided endpoint URL.

## Next Steps

For the next steps in the Cloud Resume Challenge, I will be adding more features to my infrastructure such as:

- Deployment of a virtual machine (VM) to run my resume website backend.
- Integration with Azure CDN for improved website performance.
- Automate SSL certificate provisioning using Let's Encrypt or Azure Key Vault.
- Implement infrastructure as code (IaC) best practices such as modularization and parameterization.

## Resources

- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Terraform Documentation](https://learn.hashicorp.com/collections/terraform/azure-get-started)
