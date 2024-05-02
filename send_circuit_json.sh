#!/usr/bin/env sh

curl -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -d '{"circuit_json": "やすひと", "qubit_count": 1}' \
    -XGET http://localhost:3000/
