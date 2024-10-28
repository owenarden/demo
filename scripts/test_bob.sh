#!/usr/bin/env bash

# create users

printf "\n******** sign-in bob!\n"
curl -b cookies.txt -c cookies.txt -H "Content-Type: application/json" --data @scripts/login_bob.json http://localhost:3000/api/signin

printf "\n******** list items for alice ...\n"
curl -b cookies.txt -c cookies.txt http://localhost:3000/api/list/1

printf "\n******** logout\n"
rm cookies.txt
