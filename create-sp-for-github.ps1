
$SUBSCRIPTION_ID = az account show --query id --output tsv

az ad sp create-for-rbac --name DevLab --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID --sdk-auth