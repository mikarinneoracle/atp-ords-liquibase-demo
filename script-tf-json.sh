export region='eu-amsterdam-1'
export compt_ocid='<YOUR COMPARTMENT OCID>'
cd terraform
cp ../gen_apex.sh .
mkdir html
cp ../index.html html/.
cp ../vue.js html/.    
cp ../pricing.css html/. 
zip -r stack.zip *
export ocid=$(oci resource-manager stack create --config-source stack.zip --compartment-id $compt_ocid --terraform-version 0.12.x | jq '.data.id' | tr -d '"')
cd ..
echo "--------- Update Terraform with vars.json ---------"
cat vars.json
echo "---------------------------------------------------"
oci resource-manager stack update --stack-id $ocid --variables file://vars.json --force
export jobId=$(oci resource-manager job create --stack-id $ocid --operation APPLY --apply-job-plan-resolution '{"isAutoApproved": true }' | jq '.data.id' | tr -d '"')
export tries=0
export status=''
while [ $tries -le 100 ] && [[ $status != 'SUCCEEDED' ]] 
do
  export status=$(oci resource-manager job get --job-id $jobId | jq '.data."lifecycle-state"' | tr -d '"')
  echo "stack status: $tries $status"
  tries=$(( $tries + 1 ))
  sleep 5
  if [ "$status" == "FAILED" ]; then
    echo "${stackName} stack apply failed .. exiting script."
    exit 1
  fi
done
if [ "$status" != "SUCCEEDED" ]; then
  echo "${stackName} stack apply not completed in 500 seconds .. exiting script."
  exit 1
fi
oci resource-manager job get-job-logs-content --job-id $jobId > log.txt
sed -i 's/\\n/\n/g' log.txt
tail -n 3 log.txt | head -n 1 > out.txt
export ocid=$(grep -oP '(?<=atp = \\")[^\\"]*' out.txt)
echo "ATP: $ocid"

exit

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
oci os object put --force --bucket-name pricing --file index.html --content-type "text/html" --force
oci os object put --force --bucket-name pricing --file vue.js --content-type "text/javascript" --force
