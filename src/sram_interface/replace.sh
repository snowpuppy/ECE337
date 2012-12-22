#!/usr/local/bin/bash

files=*.vhd

#echo $files

file1=`echo $files | sed 's/.vhd//g'`
file2=`echo $files | sed 's/.vhd /\\\|/g'`
file3="\\(`echo $file2 | sed 's/.vhd//g'`\\)"
echo $file3

if [[ "`cat address_buffer.vhd`" =~ $file3 ]]
then
    echo "found it."
fi

#for i in $files
#do
#    sed -e "s/${file3}/sram_\\1/g" $i > source2/sram_${i}
#done

# verify
for i in $file1
do
    grep "$i" source2/*
done
