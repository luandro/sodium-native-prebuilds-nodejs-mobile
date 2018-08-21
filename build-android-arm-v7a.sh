#! /bin/bash

set -e

topDir=`cd $(dirname $0); pwd`
# NODEJS_HEADERS_DIR=$topDir/node_modules/nodejs-mobile-react-native/ios/libnode
NODEJS_MOBILE_GYP_BIN_FILE=$topDir/node_modules/nodejs-mobile-gyp/bin/node-gyp.js

export GYP_DEFINES="OS=android"
# export npm_config_nodedir="$NODEJS_HEADERS_DIR"
# export npm_config_node_gyp="$NODEJS_MOBILE_GYP_BIN_FILE"
export npm_config_platform="android"
export npm_config_node_engine="node"
export npm_config_arch="arm-v7a"
export PREBUILD_ARCH=arm-v7a
export PREBUILD_PLATFORM=android
export PREBUILD_NODE_GYP="$NODEJS_MOBILE_GYP_BIN_FILE"

if [ ! -d sodium-native ]; then
  #git clone git@github.com:sodium-friends/sodium-native.git
  git clone git@github.com:jimpick/sodium-native.git
fi

pushd sodium-native

git checkout ios-prebuild

SODIUM_NATIVE=1 npm install

rm -rf libsodium
npm run fetch-libsodium

npx prebuildify \
  --strip \
  --preinstall "node preinstall.js" \
  --postinstall "node postinstall.js" \
  --platform=android --arch=arm-v7a \
  --target=node@8.0.0

popd

tar cf - -C sodium-native prebuilds | tar xvf -
