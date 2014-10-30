#!/bin/bash 

NAME=graphophone
DIR=tmp/$NAME

mkdir tmp
mkdir $DIR
mkdir $DIR/library
mkdir $DIR/examples

#copy the library
cp -r dist/*.jar $DIR/library/

#copy the sources 
cp -r src $DIR/

echo "Copy the sources" 
cp -R ProCam/src $DIR/

echo "Copy the JavaDoc" 
cp -R dist/javadoc $DIR/

echo "Copy Examples"
cp -R ../examples/* $DIR/examples

echo "Go to the folder" 
cd tmp

echo "create the archive"
tar -zcf $NAME.tgz $NAME

cd ..
mv tmp/$NAME.tgz .

echo "Clean " 
rm -rf tmp
