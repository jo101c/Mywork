## Platform Landing Zone Modules ##

Author: Joshua Cavallo

Introduction:

This document provides a step-by-step guide for developers on how to create and modify modules within the Platform Landing Zone Modules repository.

Prerequisites:

Visual Studio Code (VS Code) installed.
Git installed.
Access to the Platform Landing Zone Modules Git repository Project in Gitlab

Steps:
Setting Up Your Development Environment

1. Open VS Code.
Open the integrated terminal from within VS Code.
Clone the Repository

2. Use the git clone command followed by the URL to the Platform Landing Zone Modules repository.
Navigate to the cloned repository directory.
Create a Feature Branch

3. For best practices, always create a feature branch for new features, changes, or fixes rather than making changes directly to the main or nonprod branches.
Use the git checkout command with the -b flag followed by a descriptive name for your feature branch.
Modify or Add Terraform Modules

4. Navigate to the appropriate directory for your module or changes.
Use VS Code to edit or add Terraform files as required.
Commit Your Changes

5. rack your changes using the git add command.
Commit your changes with a descriptive message using the git commit command.
Push Your Changes to the Repository

6. Push your feature branch to the repository using the git push command.
Open a Pull/Merge Request

7. Go to the Git repository's web interface.
Open a new Pull/Merge Request from your feature branch to the desired target branch, like nonprod or main.
CI/CD Pipeline

**The Pull/Merge Request will activate the CI/CD pipeline**

The pipeline consists of several stages including Authentication, Quality Checks, Initialization, Plan, and Apply. The Apply stage is manual and will require approval to run.

Best Practices:
Consistent Naming: Make sure branch names and commit messages are descriptive and consistent for clarity.

Keep Modules Simple: Aim for modules that are focused and composable, avoiding overly complex modules.

Regularly Sync with Main: Regularly pull from the main or nonprod branches to stay updated and avoid merge conflicts.

Test Changes: Before pushing changes, run a terraform plan and review, review TFSec results.

Stay Updated with Terraform: Refer to Terraform's official documentation for updates and best practices.

Security: Don't hardcode any sensitive data, use Gitlab variables or a key vault data source. 