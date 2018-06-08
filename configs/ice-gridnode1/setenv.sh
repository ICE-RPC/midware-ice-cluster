#!/bin/bash

WORKDIR=$(cd `dirname $0`; pwd)
#WORKDIR=$(pwd)

ICEPREFIX=/home/apps/cpplibs/Ice-3.6.4
export PATH=${ICEPREFIX}/bin:$PATH

