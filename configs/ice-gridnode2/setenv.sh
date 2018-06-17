#!/bin/bash

WORKDIR=$(cd `dirname $0`; pwd)
#WORKDIR=$(pwd)

ICEPREFIX=/home/apps/cpplibs/Ice-3.6.4
export PATH=${ICEPREFIX}/bin:$PATH
CPPLIBS=/home/apps/cpplibs
export LD_LIBRARY_PATH=${ICEPREFIX}/libs:${CPPLIBS}/db-5.3.28/lib:$LD_LIBRARY_PATH
