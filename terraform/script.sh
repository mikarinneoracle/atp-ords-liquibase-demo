echo $1 > wallet64
base64 --decode wallet64 > wallet.zip
mkdir -p ./network/admin
mv wallet.zip ./network/admin/
echo "------------- quick fix to run with older version of SQLcli (scripts fail with the latest Nov 27th 2022) ----------"
wget https://objectstorage.eu-amsterdam-1.oraclecloud.com/p/BydeV7ct283Y4F2S9PECPEyeNI-U3xoaghdLQ0EuzNUEDIMoieyqu5uA7xJ-syyq/n/frsxwtjslf35/b/oracledb/o/jdk-11.0.16_linux-x64_bin.tar.gz -q
tar -xzf jdk-11.0.16_linux-x64_bin.tar.gz
export PATH=./jdk-11.0.16/bin:$PATH
export JAVA_HOME=./jdk-11.0.16
wget https://objectstorage.eu-amsterdam-1.oraclecloud.com/p/rBz7NIZQsEXsXN6yqnLn8m9fLmTHZUY7Z5uhPBBUzsoiW0ceUoY1jyU5y7DjEWJx/n/frsxwtjslf35/b/oracledb/o/V1022102-01.zip -q
unzip -q V1022102-01.zip
./sqlcl/bin/sql -v
echo "-------------------------------------------------------------------------------------------------------------------"
sh gen_apex.sh
cd ./network/admin
unzip -q wallet.zip
cd ../..
ls -R
grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo $(head -n 1)
