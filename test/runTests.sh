#!/bin/bash

# NOTE: this script doesnt check for anything.

cd $(dirname $0)

TEST_DISPLAY=1
RUN_DIR=$(pwd)/run

SEPARATOR="-------------------------------"

BG_PIDS=""

function cleanup() {
    for PID in ${BG_PIDS}; do
        kill $PID
    done
}

function launch_bg() {
    echo ${SEPARATOR}
    echo running $*
    $* &
    if [ $? -gt 0 ]; then
        echo could not launch: $*
        cleanup
        exit 1
    fi
    BG_PIDS="$BG_PIDS $!"
}

function mozilla_test() {
    TEST=$1
    DISPLAY=:${TEST_DISPLAY}.0 mozilla file://${RUN_DIR}/fs.html?file://${RUN_DIR}/test-${TEST}.html &
}


# run background XVfb
launch_bg Xvfb :${TEST_DISPLAY} -screen 0 320x240x24 || exit 1


###
# run tests in js runtime
#mozilla_test js
#neko TestServer.n ${TEST_DISPLAY}.0 js


###
# run tests in swf runtime
#mozilla_test swf
#neko TestServer.n ${TEST_DISPLAY}.0 swf


###
# run tests in xinfinity
NEKOPATH="../libs:${NEKOPATH}" \
LD_LIBRARY_PATH=../libs
DISPLAY=:${TEST_DISPLAY}.0 neko ${RUN_DIR}/test.n &
neko TestServer.n ${TEST_DISPLAY}.0 xinfinity


#sleep 3s
#echo show display
#xwd -display :${TEST_DISPLAY}.0 -root | xwud

cleanup

echo All fine, bye.
