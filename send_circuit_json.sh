#!/usr/bin/env sh

curl -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -d '{"circuit_json": "{ \"cols\": [[\"H\"]] }", "qubit_count": 1}' \
    -w'\n' \
    -XGET http://localhost:3000/
