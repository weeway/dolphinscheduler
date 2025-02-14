#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

print_usage(){
        printf $"USAGE:$0 rootNode\n"
        exit 1
}

if [ $# -ne 1 ];then
        print_usage
fi

rootNode=$1

BIN_DIR=`dirname $0`
BIN_DIR=`cd "$BIN_DIR"; pwd`
DOLPHINSCHEDULER_HOME=$BIN_DIR/..

source ${BIN_DIR}/env/install_env.sh
source ${BIN_DIR}/env/dolphinscheduler_env.sh

export JAVA_HOME=$JAVA_HOME

export DOLPHINSCHEDULER_CONF_DIR=$DOLPHINSCHEDULER_HOME/conf
export DOLPHINSCHEDULER_LIB_JARS=$DOLPHINSCHEDULER_HOME/api-server/libs/*

export DOLPHINSCHEDULER_OPTS="-Xmx1g -Xms1g -Xss512k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "
export STOP_TIMEOUT=5

CLASS=org.apache.zookeeper.ZooKeeperMain

exec_command="$DOLPHINSCHEDULER_OPTS -classpath $DOLPHINSCHEDULER_CONF_DIR:$DOLPHINSCHEDULER_LIB_JARS $CLASS -server $REGISTRY_ZOOKEEPER_CONNECT_STRING rmr $rootNode"

cd $DOLPHINSCHEDULER_HOME
$JAVA_HOME/bin/java $exec_command
