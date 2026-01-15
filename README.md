# AVD and Azure Firewall Deployment with Terraform and GitHub Actions

This repository contains a Proof of Concept for deploying Azure Virtual Desktop (AVD) and Azure Firewall using Terraform, with a CI/CD pipeline for automation and governance.

## Project Structure

```
.
├── .github
│   └── workflows
│       └── terraform.yml
├── terraform
│   ├── environments
│   │   └── dev
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   └── modules
│       ├── avd
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       ├── firewall
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       └── network
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
└── README.md
```

- **`.github/workflows`**: Contains the GitHub Actions workflow for CI/CD.
- **`terraform/modules`**: Contains reusable Terraform modules for AVD, Firewall, and Networking.
- **`terraform/environments/dev`**: Contains the root Terraform configuration for the `dev` environment, which consumes the modules.

## CI/CD Pipeline

The CI/CD pipeline is defined in `.github/workflows/terraform.yml` and is triggered on every push to the `main` branch or any pull request.

The pipeline consists of two main jobs:

1.  **`plan`**: This job runs on every push and pull request. It initializes Terraform, validates the configuration, and creates an execution plan. The plan is then saved as an artifact.
2.  **`apply`**: This job runs only after the `plan` job is successful on a push to the `main` branch. It requires **manual approval** before running. Once approved, it downloads the plan artifact and applies the changes to your Azure environment.

This two-step process with manual approval serves as a digital CAB review, ensuring that changes are reviewed and verified before being deployed.

### Enabling Manual Approval (CAB Gate)

To enforce the manual approval step, you must configure a protection rule for the `production` environment in your GitHub repository. Without this rule, the workflow will run automatically.

1.  Go to your repository's **Settings** > **Environments**.
2.  Click **New environment**.
3.  Name the environment `production` and click **Configure environment**.
4.  Under **Deployment protection rules**, check the box for **Required reviewers**.
5.  Add yourself or your team as a reviewer and click **Save protection rules**.

### Setup Azure Credentials

To allow GitHub Actions to deploy to Azure, you need to create a service principal and add its credentials as a secret in your GitHub repository.

1.  **Create a Service Principal**:

    ```bash
    az ad sp create-for-rbac --name "<your-sp-name>" --role "Contributor" --scopes "/subscriptions/<your-subscription-id>" --sdk-auth
    ```

    The output will be a JSON object. Ensure it contains `clientId`, `clientSecret`, `subscriptionId`, and `tenantId`.

    **Example JSON:**
    ```json
    {
      "clientId": "<GUID>",
      "clientSecret": "<GUID>",
      "subscriptionId": "<GUID>",
      "tenantId": "<GUID>",
      ...
    }
    ```

2.  **Add the Secret to GitHub**: 

    - Go to your GitHub repository's **Settings** > **Secrets and variables** > **Actions**.
    - Click **New repository secret**.
    - Name the secret `AZURE_CREDENTIALS`.
    - Paste the JSON output from the `az ad sp create-for-rbac` command as the value.

## How to Use

1.  Clone this repository.
2.  Set up the `AZURE_CREDENTIALS` secret as described above.
3.  Push a change to the `main` branch to trigger the deployment.

<!-- Trigger workflow -->
