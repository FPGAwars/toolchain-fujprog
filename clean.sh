#!/bin/bash

# -- Target architectures
ARCH=$1
TARGET_ARCHS="linux_x86_64 windows_amd64 windows_x86 darwin"

# -- Store current dir
WORK_DIR=$PWD

# -- Folder for storing the downloaded packages
PACKAGES_DIR=$WORK_DIR/_packages

# -- Check ARCH
if [[ $# -gt 1 ]]; then
  echo ""
  echo "Error: too many arguments"
  exit 1
fi

if [[ $# -gt 1 ]]; then
  echo ""
  echo "Usage: bash clean.sh TARGET"
  echo ""
  echo "Targets: $TARGET_ARCHS"
  exit 1
fi

if [[ $ARCH =~ [[:space:]] || ! $TARGET_ARCHS =~ (^|[[:space:]])$ARCH([[:space:]]|$) ]]; then
  echo ""
  echo ">>> WRONG ARCHITECTURE \"$ARCH\""
  echo "Targets: $TARGET_ARCHS"
  echo ""
  exit 1
fi

echo ""
echo ">>> ARCHITECTURE \"$ARCH\""

printf "Are you sure? [y/N]:" 
read -r RESP
case "$RESP" in
    [yY][eE][sS]|[yY])

      # -- Directory for installation the target files
      PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

      # -- Remove the package dir
      rm -r -f "$PACKAGE_DIR"

      # -- Remove the package from the releases folder
      rm -f releases/toolchain-*-"$ARCH"*

      echo ""
      echo ">> CLEAN"
      ;;
    *)
      echo ""
      echo ">> ABORT"
      ;;
esac
