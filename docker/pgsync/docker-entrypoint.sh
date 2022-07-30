#!/bin/sh
set -eu

export PYTHONPATH=/home/

timeout 60s sh -c 'until nc -zv postgres 5432 &>/dev/null ; do sleep 0 ; done'
timeout 60s sh -c 'until nc -zv redis 6379 &>/dev/null ; do sleep 0 ; done'
timeout 60s sh -c 'until nc -zv elasticsearch 9200 &>/dev/null ; do sleep 0 ; done'
# delete all existing elasticsearch indexes (we must regenerate since they could have changed)
curl -sL -X DELETE http://elasticsearch:9200/_all
rm -f .search_mem_leak*

bootstrap --config ./config/schema.json
echo 'post boot'
# pgsync generates a view named _view when bootstrapped, we need to grant privlidges
# https://github.com/toluaina/pgsync/issues/223
# psql -c 'grant select on _view to memleak_authed'

exec pgsync --config ./config/schema.json -d 
# echo "Running..."
# while pgsync --config ./config/generated.json ; do sleep 1 ; echo 'Rerunning...' ; done
# exit "$?"

