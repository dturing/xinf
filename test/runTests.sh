#!/bin/sh

DISPLAY=:1.0
pkill mozilla

make
rm /tmp/xinfTestFinished

function wait_finish() {
    while [ ! -e /tmp/xinfTestFinished ]; do
        sleep .5s;
    done
    rm /tmp/xinfTestFinished
}

echo Running SWF tests
firefox -P test -chrome "javascript:void(window.open('http://localhost:2000/swf.html','','chrome'))"
wait_finish

echo Running JS tests
firefox -P test -chrome "javascript:void(window.open('http://localhost:2000/js.html','','chrome'))"
wait_finish
pkill mozilla

echo Running Xinfinity tests
make run

echo Compiling report
make -C report run

echo finished.
