#!/bin/bash 

# Update radamsa 
wget -O - https://gitlab.com/akihe/radamsa/-/archive/develop/radamsa-develop.tar.gz | tar xvz
[ -d "radamsa" ] && mv radamsa radamsa.$$.$RANDOM
mv radamsa-develop radamsa
( 
    cd radamsa 
    make
)