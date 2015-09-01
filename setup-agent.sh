#!/usr/bin/env bash

export JAVA_HOME=/usr/java/default
AGENT_DIR="${HOME}/agent"

if [ -z "$TEAMCITY_SERVER" ]; then
    echo "Fatal error: TEAMCITY_SERVER is not set."
    echo "Launch this container with -e TEAMCITY_SERVER=http://servername:port."
    echo
    exit
fi

if [ ! -d "$AGENT_DIR" ]; then
    cd ${HOME}
    echo "Setting up TeamCityagent for the first time..."
    echo "Agent will be installed to ${AGENT_DIR}."
    mkdir -p $AGENT_DIR
    curl -O $TEAMCITY_SERVER/update/buildAgent.zip
    unzip -q -d $AGENT_DIR buildAgent.zip
    rm buildAgent.zip
    chmod +x $AGENT_DIR/bin/agent.sh
    mv $AGENT_DIR/conf/buildAgent.dist.properties $AGENT_DIR/conf/buildAgent.properties
    sed -i -e 's|'serverUrl=http://localhost:8111/'|'serverUrl=$TEAMCITY_SERVER/'|g' $AGENT_DIR/conf/buildAgent.properties
else
    echo "Using agent at ${AGENT_DIR}."
fi
$AGENT_DIR/bin/agent.sh run
