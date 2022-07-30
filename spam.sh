#!/bin/bash
for i in {1..100}
do
    ./psql.sh -c  'SELECT * FROM spammer();'
done