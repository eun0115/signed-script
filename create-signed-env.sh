#!/bin/bash

# Construct the subject line
subject='/C=PH/ST=Philippines/L=Manila/O=eun0115/OU=eun0115/CN=eun0115/emailAddress=gianpaoloestacio5@gmail.com' 

# Print the subject line
echo "Using Subject Line:"
echo "$subject"

# Create Key
echo "Press ENTER TWICE to skip password (about 10-15 enter hits total). Cannot use a password for inline signing!"
mkdir ~/.android-certs

for x in bluetooth media networkstack nfc platform releasekey sdk_sandbox shared testkey verifiedboot; do \
    ./development/tools/make_key ~/.android-certs/$x "$subject"; \
done


## Create vendor for keys
mkdir -p vendor/lineage-priv
mv ~/.android-certs vendor/lineage-priv/keys
echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage-priv/keys/releasekey" > vendor/lineage-priv/keys/keys.mk
cat <<EOF > vendor/lineage-priv/keys/BUILD.bazel
filegroup(
    name = "android_certificate_directory",
    srcs = glob([
        "*.pk8",
        "*.pem",
    ]),
    visibility = ["//visibility:public"],
)
EOF

echo "Done! Now build as usual. If builds aren't being signed, add '-include vendor/lineage-priv/keys/keys.mk' to your device mk file"
echo "Make copies of your vendor/lineage-priv folder as it contains your keys!"
sleep 3
