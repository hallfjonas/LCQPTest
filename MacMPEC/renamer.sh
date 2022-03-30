#!/bin/bash

echo "Directory to perform action: $1"
echo "                 Search for: $2"
echo "                 Replace by: $3"
echo "                  Seperator: $4"

for FILE in $1/*; do 

echo $FILE; 
sed -i "s$4$2$4$3$4g" $FILE

done