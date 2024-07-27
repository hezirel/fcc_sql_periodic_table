#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# If no argument or more than one is provided, return an error message
if [ "$#" -ne 1 ]; then
    echo "Please provide an element as an argument."
    exit
    fi
