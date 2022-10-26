export region='eu-amsterdam-1'
export compt_ocid='<YOUR COMPARTMENT OCID>'
cd terraform
zip stack.zip *
export ocid=$(oci resource-manager stack create --config-source stack.zip --compartment-id $compt_ocid --terraform-version 0.12.x | jq '.data.id' | tr -d '"')
cd ..
oci resource-manager stack update --stack-id $ocid --variables file://vars.json --force
cat vars.json
export jobId=$(oci resource-manager job --stack-id $ocid --operation APPLY --execution-plan-strategy AUTO_APPROVED | jq '.data.id' | tr -d '"')
export tries=0
export status=''
while [ $tries -le 100 ] && [[ $status != 'SUCCEEDED' ]] 
do
  export status=$(oci resource-manager job get --job-id $jobId | jq '.data."lifecycle-state"' | tr -d '"')
  echo "stack status: $tries $status"
  tries=$(( $tries + 1 ))
  sleep 5
done
if [ "$status" != "SUCCEEDED" ]; then
  echo "${stackName} stack apply not completed in 500 seconds .. exiting"
  exit 1
fi
oci resource-manager job get-job-logs-content --job-id $jobId > log.txt
sed -i 's/\\n/\n/g' log.txt
tail -n 3 log.txt | head -n 1 > out.txt
export ocid=$(grep -oP '(?<=ocid = \\")[^\\"]*' out.txt)
echo "ATP: $ocid"
exit

export tries=0
export atp_status=''
while [ $tries -le 30 ] && [[ $atp_status != 'AVAILABLE' ]] 
do
  atp_status=$(oci db autonomous-database get --autonomous-database-id $ocid | jq -r '.data["lifecycle-state"]')
  echo "atp status: $tries $atp_status"
  tries=$(( $tries + 1 ))
  sleep 5
done
oci db autonomous-database generate-wallet --autonomous-database-id $ocid --password 'WelcomeFolks123#!' --file wallet.zip
mkdir -p ./network/admin
mv wallet.zip ./network/admin/
sh gen_apex.sh
cd ./network/admin
unzip -q wallet.zip
cd ../..
export url=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/priceadmin")
export apex=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/r/priceadmin/price-admin/login")
echo $url
echo $apex
sed -i "s|URL|$url|g" vue.js
sed -i "s|URL|$apex|g" index.html
oci os bucket create --compartment-id  $compt_ocid --name pricing --public-access-type ObjectReadWithoutList
oci os object put --force --bucket-name pricing --file index.html --content-type "text/html" --force
oci os object put --force --bucket-name pricing --file vue.js --content-type "text/javascript" --force
oci os object put --force --bucket-name pricing --file pricing.css  --content-type "text/css" --force