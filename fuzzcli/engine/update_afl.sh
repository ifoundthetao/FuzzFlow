#!/bin/bash 

# Update radamsa
rm -f master.zip
wget https://github.com/AFLplusplus/AFLplusplus/archive/master.zip
unzip master.zip
rm -f master.zip
[ -d "afl" ] && mv afl afl.bak.$RANDOM
mv AFLplusplus-master afl 
( 
    cd afl
    make
)
