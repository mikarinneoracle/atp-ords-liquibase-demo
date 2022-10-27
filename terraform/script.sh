echo $1 > wallet64
base64 --decode wallet64 > wallet.zip
mkdir -p ./network/admin
mv wallet.zip ./network/admin/
#sh gen_apex.sh
cd ./network/admin
unzip -q wallet.zip
cd ../..
ls -R
export url=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/priceadmin")
export apex=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/r/priceadmin/price-admin/login")
echo $url
echo $apex
