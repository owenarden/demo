#!/usr/bin/env bash

# create users

printf "\n********* add users\n"
scripts/adduser.sh

# login and insert as alice 

printf "\n******** sign-in alice!\n"
curl -b cookies.txt -c cookies.txt -H "Content-Type: application/json" --data @scripts/login.json http://localhost:3000/api/signin

printf "\n******** add items for alice\n"
curl -b cookies.txt -c cookies.txt -H "Content-Type: application/json" --data @scripts/items_alice.json http://localhost:3000/api/add

printf "\n******* logout\n"
rm cookies.txt

# login and view as alice 

printf "\n******** sign-in alice!\n"
curl -b cookies.txt -c cookies.txt -H "Content-Type: application/json" --data @scripts/login.json http://localhost:3000/api/signin

printf "\n******** list items for alice ...\n"
curl -b cookies.txt -c cookies.txt http://localhost:3000/api/list/1

printf "\n******** logout\n"
rm cookies.txt

# login and view as bob 

printf "\n******** sign-in bob!\n"
curl -b cookies.txt -c cookies.txt -H "Content-Type: application/json" --data @scripts/login_bob.json http://localhost:3000/api/signin

printf "\n******** list items for alice ...\n"
curl -b cookies.txt -c cookies.txt http://localhost:3000/api/list/1

printf "\n******** logout\n"
rm cookies.txt

# login and view as carlos

printf "\n******** sign-in carlos!\n"
curl -b cookies.txt -c cookies.txt -H "Content-Type: application/json" --data @scripts/login_carlos.json http://localhost:3000/api/signin

printf "\n******** list items for alice ...\n"
curl -b cookies.txt -c cookies.txt http://localhost:3000/api/list/1

printf "\n******** logout\n"
rm cookies.txt
