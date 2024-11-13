#!/bin/bash

# another commit
if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 1
fi

ELEMENT_INPUT=$1

query_element() {
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e
                         JOIN properties p ON e.atomic_number = p.atomic_number
                         JOIN types t ON p.type_id = t.type_id
                         WHERE e.atomic_number = '$ELEMENT_INPUT' OR e.symbol = '$ELEMENT_INPUT' OR e.name = '$ELEMENT_INPUT';")
  echo "$ELEMENT_INFO"
}

ELEMENT_RESULT=$(query_element)

if [[ -z "$ELEMENT_RESULT" ]]; then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT_RESULT" | while IFS="|" read atomic_number name symbol atomic_mass melting_point boiling_point type; do
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu."
    echo "$name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
  done
fi