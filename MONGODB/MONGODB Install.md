# MONGODB Install

## MAC OS

# Install necessary tools
```
# Go to https://www.mongodb.com/download-center/community
cd ~/Downloads
tar -zxvf mongodb-macos-x86_64-4.2.0.tgz
chmod +x mongodb-macos-x86_64-4.2.0/bin/mongodump
chmod +x mongodb-macos-x86_64-4.2.0/bin/mongorestore
mv mongodb-macos-x86_64-4.2.0/bin/mongodump /usr/local/bin
mv mongodb-macos-x86_64-4.2.0/bin/mongorestore /usr/local/bin
mongodump --version
mongorestore --version
rm -rf mongodb*
```



