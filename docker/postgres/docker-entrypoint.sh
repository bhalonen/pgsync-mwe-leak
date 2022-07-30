#!/usr/bin/env bash

source /usr/local/bin/docker-entrypoint.orig.sh

copy_func() {
	local ORIG_FUNC=$(declare -f $1)
	local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
	eval "$NEWNAME_FUNC"
}

copy_func docker_setup_env docker_setup_env_
docker_setup_env() {
	docker_setup_env_ "$@"
	
	declare -g DATABASE_ALREADY_EXISTS_
	DATABASE_ALREADY_EXISTS_="$DATABASE_ALREADY_EXISTS"
	unset -v DATABASE_ALREADY_EXISTS
	
	declare -g DATABASE_IS_NOT_RESTORED
	# look specifically for PG_VERSION, as it is expected in the DB dir
	if [ -s "$PGDATA/backup_label" ]; then
		DATABASE_IS_NOT_RESTORED='true'
		touch "$PGDATA/recovery.signal"
	fi
}

copy_func docker_verify_minimum_env docker_verify_minimum_env_
docker_verify_minimum_env() {
	if [ -z "$DATABASE_ALREADY_EXISTS_" ]; then
		docker_verify_minimum_env_ "$@"
	fi
}

copy_func docker_init_database_dir docker_init_database_dir_
docker_init_database_dir() {
	if [ -z "$DATABASE_ALREADY_EXISTS_" ]; then
		docker_init_database_dir_ "$@"
	fi
}

copy_func pg_setup_hba_conf pg_setup_hba_conf_
pg_setup_hba_conf() {
	if [ -z "$DATABASE_ALREADY_EXISTS_" ]; then
		pg_setup_hba_conf_ "$@"
	fi
	if ! grep -e "${POSTGRES_USER}" "$PGDATA/pg_hba.conf" &> /dev/null; then
		cat >> "$PGDATA/pg_hba.conf" <<EOF
host replication ${POSTGRES_USER} samenet md5
EOF
	fi
}

copy_func docker_setup_db docker_setup_db_
docker_setup_db() {
	if [ -z "$DATABASE_ALREADY_EXISTS_" ]; then
		docker_setup_db_ "$@"
	fi
}

copy_func docker_process_init_files docker_process_init_files_
docker_process_init_files() {
	# wait for elasticsearch to be available
	timeout 5m bash -c 'until wget http://elasticsearch:9200 -O - &>/dev/null ; do sleep 10 ; done'
	
	if [ -z "$DATABASE_IS_NOT_RESTORED" ]; then
		(
			cd /init
			export PGUSER="${PGUSER:-$POSTGRES_USER}"
			export DATABASE_URL="socket://${PGUSER}:${PGPASSWORD}@/var/run/postgresql?db=${POSTGRES_DB}"
			#psql -c 'create extension if not exists zombodb; alter extension zombodb update;'
			# /init/node_modules/graphile-migrate/dist/cli.js migrate
		)
	fi
}

if ! _is_sourced; then
	# if first arg looks like a flag, assume we want to run postgres server
	if [ "${1:0:1}" = '-' ]; then
		set -- postgres "$@"
	fi
	
	if [ "$1" = 'postgres' ] && ! _pg_want_help "$@"; then
		docker_setup_env
		# setup data directories and permissions (when run as root)
		docker_create_db_directories
		if [ "$(id -u)" = '0' ]; then
			# if run as root, switch to postgres user
			exec su-exec postgres "$BASH_SOURCE" "$@"
		fi
	fi
	
	_main "$@"
fi
