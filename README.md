# Dev Lab

**create-sp-for-github.ps1** is used to create a dedicated Service Principal for current deployment activity.

All the workflow is handled by **bicepDeploy.yml** file which uses *GitHub actions* and *Bicep templates*

Bicep templates are as granular as possible to provide and maintain required flexibility.

Secrets and credentials are stored in *GitHub secrets*