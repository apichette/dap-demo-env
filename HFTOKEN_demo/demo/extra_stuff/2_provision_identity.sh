#!/bin/bash 
if [[ "$1" == "" ]]; then
  echo "Provide name of input file."
  exit -1
fi
INPUT_FILE=$1
i=1
while read line
  do
    case $i in
      1)
        HF_TOKEN=$line
        ;;
      2)
        APP_HOSTNAME=$line
        ;;
      3)
        VAR_ID=$line
    esac
    (( i++ ))
done < "$INPUT_FILE"

# delete old identity files
rm -f /root/.conjurrc /root/conjur*.pem /etc/conjur*

# initialize client environment
conjur init -h $CONJUR_MASTER_HOSTNAME:$CONJUR_MASTER_PORT << EOF
yes
EOF
        # configure policy plugin
sed -i.bak -e "s#\[\]#\[ policy \]#g" /root/.conjurrc
conjur authn login -u admin -p Cyberark1

# create configuration and identity files (AKA conjurize the host)
cp ~/conjur-$CONJUR_ACCOUNT.pem /etc

		# generate new host and api key from hf token
api_key=$(conjur hostfactory hosts create $HF_TOKEN $APP_HOSTNAME | jq -r .api_key)

				# copy over identity file
echo "Generating identity file..."
cat <<IDENTITY_EOF | tee /etc/conjur.identity
machine $CONJUR_APPLIANCE_URL/authn
  login host/$APP_HOSTNAME
  password $api_key
IDENTITY_EOF

echo
echo "Generating host configuration file..."
cat <<CONF_EOF | tee /etc/conjur.conf
---
appliance_url: $CONJUR_APPLIANCE_URL
account: $CONJUR_ACCOUNT
netrc_path: "/etc/conjur.identity"
cert_file: "/etc/conjur-$CONJUR_ACCOUNT.pem"
plugins: [ policy ]
CONF_EOF

# delete user identity files to force use of /etc/conjur* host identity files.
rm ~/.conjurrc ~/.netrc
