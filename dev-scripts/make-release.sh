#!/bin/bash



### Check working directory
if [ ! -d "dev-scripts" ]; then
	echo "ERROR: You have to run this script in the root of repository"
	exit 1
fi



### Check release tag
RELEASE_TAG="$1"
if [ "x$RELEASE_TAG" == "x" ]; then
	echo "ERROR: No release tag given. Use $0 X.Y.Z"
	exit 1
fi



### Check if release tag exists
if [ `git tag | grep -c "^$RELEASE_TAG\$"` -ne 1 ]; then
	echo "ERROR: Release tag does not exist, please create it: $RELEASE_TAG"
	exit 2
fi



### Check if temporary directory exists
PKGDIRNAME="snoopy-$RELEASE_TAG"
PKGDIR="../tmp/$PKGDIRNAME"
if [ -e $PKGDIR ]; then
	echo "ERROR: Temporary package directory already exists: $PKGDIR"
	exit 3
fi
mkdir $PKGDIR



### Create copy of trunk
git checkout $RELEASE_TAG &&
cp -pR ./* $PKGDIR &&
git log > $PKGDIR/ChangeLog &&
cd $PKGDIR &&
rm -rf dev-scripts &&
autoheader &&
autoconf &&
cd .. &&
tar -c -z -f $PKGDIRNAME.tar.gz $PKGDIRNAME &&
rm -rf $PKGDIRNAME &&
echo "SUCCESS! Package created: $PKGDIRNAME.tar.gz (in `dirname $PKGDIR`)"
