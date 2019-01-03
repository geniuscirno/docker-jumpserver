#! /bin/bash
set -e
set -x

if [[ "$1" == "supervisord" ]]; then
    socket="/var/run/mysqld/mysqld.sock"
    mysqld --skip-networking --socket="${socket}" &
    pid="$!"
    mysql=(mysql --protocol=socket --socket="$socket")
    for i in {30..0}; do
        if echo "select 1" | ${mysql[@]} &> /dev/null; then
            break
        fi

        echo "MySQL init process in progress..."
        sleep 1
        if [[ "$i" = 0 ]]; then
            echo >&2 'MySQL init process failed.'
            exit 1
        fi
    done

    echo "create database if not exists jumpserver default charset 'utf8';" | ${mysql[@]}

    if ! echo "show grants for jumpserver@localhost" | "${mysql[@]}" > /dev/null 2>&1; then
        echo "grant all on jumpserver.* to 'jumpserver'@'localhost' identified by '$DB_PASSWD';" | "${mysql[@]}"
        echo "flush privileges;" | "${mysql[@]}"
    fi

    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo >&2 'MySQL init process failed.'
        exit 1
    fi

    echo
        echo 'MySQL init process done. Ready for start up.'
    echo
fi

exec "$@"

