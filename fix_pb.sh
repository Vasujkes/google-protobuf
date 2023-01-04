#!/bin/bash

sed -i '' 's/var global = Function('\''return this'\'')();/const proto = {};/g' "$@"
if grep -qrE "[^a-zA-Z]Function\(" "$@"; then
  echo "Error: Function( still present"
  exit -1
fi

sed -i '' 's/, global);/, { proto });/g' "$@"
if grep -qrE '(^|[^a-zA-Z."])global([^a-zA-Z]|$)' "$@"; then
  echo "Error: global still present"
  exit -1
fi

sed -i '' "s/require('google-protobuf'/require('@vasujke\/google-protobuf'/g"  "$@" > /dev/null
sed -i '' "s/require('google-protobuf\//require('@vasujke/google-protobuf\//g"  "$@" > /dev/null
if grep -qrE '\(.google-protobuf' "$@"; then
  echo "Error: google-protobuf still present"
  exit -1
fi

# Extra checks

if grep -qrE "[^a-zA-Z]eval\(" "$@"; then
  echo "Error: eval( is present"
  exit -1
fi

if grep -qrEi "[^ae]script" "$@"; then
  echo "Error: 'script' is present"
  exit -1
fi