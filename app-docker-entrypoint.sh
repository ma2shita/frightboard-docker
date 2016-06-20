#!/bin/bash
set -e

cd ${APP_ROOT}
# NOTE: Workaround to `invalid byte sequence in US-ASCII`
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
exec bundle exec rackup --host 0.0.0.0
