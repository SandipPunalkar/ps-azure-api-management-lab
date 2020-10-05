
# variable configuration
NTSAPINAME=NTSTrafficInfoAPI$(openssl rand -hex 5)
RES_GROUP=$(az group list --query "[0].name" -o tsv)
DEPLOY_USER="randomUser1$(openssl rand -hex 5)"
DEPLOY_PASSWORD="Pw1$(openssl rand -hex 10)"
REMOTE_NAME=production
GIT_USER=randomgitName
GIT_EMAIL=random@test.com
DEPLOY_URL="https://$DEPLOY_USER@$NTSAPINAME.scm.azurewebsites.net/$NTSAPINAME.git"

# Git configuration

git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

# Azure Resource Creation

az appservice plan create --name $NTSAPINAME --resource-group $RES_GROUP --location centralus --sku FREE --verbose
az webapp create --name $NTSAPINAME --resource-group $RES_GROUP --plan $NTSAPINAME --deployment-local-git --verbose
az webapp deployment user set --user-name $DEPLOY_USER --password $DEPLOY_PASSWORD --verbose

# Deployment of app to App Service 

cd ps-azure-api-management-lab

git remote add $REMOTE_NAME $DEPLOY_URL
git add .
git commit -m "Initial"
git push "https://$DEPLOY_USER:$DEPLOY_PASSWORD@$NTSAPINAME.scm.azurewebsites.net/$NTSAPINAME.git" 

printf "Swagger UI Test page: https://$NTSAPINAME.azurewebsites.net/swagger\n\n"
printf "Swagger JSON URL. Copy for later: https://$NTSAPINAME.azurewebsites.net/swagger/v1/swagger.json\n\n"