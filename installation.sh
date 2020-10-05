
# variable configuration
ntsApiName=NTSTrafficInfoAPI$(openssl rand -hex 5)
RESOURCE_GROUP=$(az group list --query "[0].name" -o tsv)
PLAN_NAME=myPlan
DEPLOY_USER="randomUser1$(openssl rand -hex 5)"
DEPLOY_PASSWORD="Pw1$(openssl rand -hex 10)"
REMOTE_NAME=production

# Git configuration
GIT_USERNAME=randomgitName
GIT_EMAIL=random@test.com

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

# Azure Resource Creation

az appservice plan create --name $ntsApiName --resource-group $RESOURCE_GROUP --location centralus --sku FREE --verbose

az webapp create --name $ntsApiName --resource-group $RESOURCE_GROUP --plan $ntsApiName --deployment-local-git --verbose

az webapp deployment user set --user-name $DEPLOY_USER --password $DEPLOY_PASSWORD --verbose

GIT_URL="https://$DEPLOY_USER@$ntsApiName.scm.azurewebsites.net/$ntsApiName.git"

cd ps-azure-api-management-lab

git remote add $REMOTE_NAME $GIT_URL

git add .
git commit -m "temp"
git push "https://$DEPLOY_USER:$DEPLOY_PASSWORD@$ntsApiName.scm.azurewebsites.net/$ntsApiName.git" 

printf "Swagger URL: https://$ntsApiName.azurewebsites.net/swagger\n"

printf "Example URL: https://$ntsApiName.azurewebsites.net/swagger/v1/swagger.json\n\n"