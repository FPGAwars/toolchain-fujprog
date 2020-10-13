#!/bin/bash
##################################
# fujprog apio package builder   #
##################################

# Set english language for propper pattern matching
export LC_ALL=C

# Generate toolchain-fujprog-arch-ver.tar.gz
# sources and releases: https://github.com/kost/fujprog/

# -- fujprog apio package version
VERSION=2020.10.6

# -- fujprog version to download
# -- Current v4.6
SRC_MAYOR=4
SRC_MINOR=6
SRC_VER=v$SRC_MAYOR.$SRC_MINOR

# -- Target architectures
ARCH=$1
TARGET_ARCHS="linux_x86_64 windows_amd64 darwin"

# -- Tools name
NAME=toolchain-fujprog

# -- Source fujprov filename (without arch)
SRC_NAME="fujprog-v"$SRC_MAYOR$SRC_MINOR"-"

# -- Source URL
SRC_URL="https://github.com/kost/fujprog/releases/download/$SRC_VER/"

# -- Store current dir
WORK_DIR=$PWD

# -- Folder for storing the downloaded packages
PACKAGES_DIR=$WORK_DIR/_packages

# -- Create the packages directory
mkdir -p $PACKAGES_DIR

# -- Print function
function print {
  echo ""
  echo $1
  echo ""
}

# -- Check ARCH
if [[ $# > 1 ]]; then
  echo ""
  echo "Error: too many arguments"
  exit 1
fi

if [[ $# < 1 ]]; then
  echo ""
  echo "Usage: bash build.sh TARGET"
  echo ""
  echo "Targets: $TARGET_ARCHS"
  exit 1
fi

if [[ $ARCH =~ [[:space:]] || ! $TARGET_ARCHS =~ (^|[[:space:]])$ARCH([[:space:]]|$) ]]; then
  echo ""
  echo ">>> WRONG ARCHITECTURE \"$ARCH\""
  exit 1
fi

# -- Directory for installating the target files
PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

# -- Create the package folders
mkdir -p $PACKAGE_DIR/$NAME/bin

echo ""
echo ">>> ARCHITECTURE \"$ARCH\""

# -- Source architecture: should be the same than target
# -- architecture, but the names in the fujprog and apio
# -- are different: Convert from fujprog to apio
if [ $ARCH == "windows_amd64" ]; then
  SRC_ARCH="win64"
  EXE=".exe"
  SRC_NAME=$SRC_NAME$SRC_ARCH$EXE
  echo "Source filename: "$SRC_NAME
fi

if [ $ARCH == "linux_x86_64" ]; then
  SRC_ARCH="linux-x64"
  EXE=""
  SRC_NAME=$SRC_NAME$SRC_ARCH$EXE
  echo "Source filename: "$SRC_NAME
fi

echo "Download from: "$SRC_URL


# --- Enter to the package bin directory
cd $PACKAGE_DIR/$NAME/bin

# --- Download the executable file, if it does not exist yet
if [[ -f fujprog ]]; then
  echo "FILE Already exist"
else
  wget $SRC_URL/$SRC_NAME

  # -- Rename the file to fujprog
  mv $SRC_NAME fujprog$EXE

  # -- Give the executable permision to fujprog
  chmod a+x fujprog$EXE
fi


# -- Create package script

# -- Copy templates/package-template.json
cp -r $WORK_DIR/build-data/templates/package-template.json $PACKAGE_DIR/$NAME/package.json

if [ $ARCH == "linux_x86_64" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"linux_x86_64\"/;" $PACKAGE_DIR/$NAME/package.json
fi

if [ $ARCH == "windows_amd64" ]; then
  sed -i "s/%VERSION%/\"$VERSION\"/;" $PACKAGE_DIR/$NAME/package.json
  sed -i "s/%SYSTEM%/\"windows_amd64\"/;" $PACKAGE_DIR/$NAME/package.json
fi

## --Create a tar.gz package

cd $PACKAGE_DIR/$NAME

tar -czvf ../$NAME-$ARCH-$VERSION.tar.gz *

# -- Create the releases folder
mkdir -p $WORK_DIR/releases

## -- Copy the package to the releases folder
cd $PACKAGE_DIR
cp $NAME-$ARCH-$VERSION.tar.gz $WORK_DIR/releases

# --------- DEBUG ------------------------------------
#  . $WORK_DIR/scripts/install_dependencies.sh

# --------- Compile lsusb ------------------------------------------
# . $WORK_DIR/scripts/compile_lsusb.sh

# --------- Create the package -------------------------------------
# . $WORK_DIR/scripts/create_package.sh

echo ""