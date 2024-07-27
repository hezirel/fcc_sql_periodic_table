#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

function format_output {
  local atomic_number=$1
  local name=$2
  local symbol=$3
  local type=$4
  local atomic_mass=$5
  local melting_point=$6
  local boiling_point=$7

  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
}

function get_info {
    local atomic_number=$1
    local element_info=($($PSQL "SELECT name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types ON properties.type_id = types.type_id WHERE atomic_number = $atomic_number;"))

    IFS='|' read -ra details <<< "$element_info"
    format_output $atomic_number "${details[@]}"
}
# If no argument or more than one is provided, return an error message
if [ "$#" -ne 1 ]; then
    echo "Please provide an element as an argument."
    exit
else
    # Different searches based on argument type
    # If the argument is a number, search by atomic number
    # If the argument is a two letter strings max, search by element symbol
    # If the argument is a string, search by element name
    ELT=$1

    if [[ $ELT =~ ^[0-9]+$ ]]; then
        ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ELT")
    elif [[ $ELT =~ ^[A-Z][a-z]?$ ]]; then
        ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ELT'")
    else
        ID=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ELT'")
    fi

    if [ -z "$ID" ]; then
        echo "I could not find that element in the database."
        exit
    fi
    get_info $ID
    fi
