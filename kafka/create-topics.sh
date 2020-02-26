Skip to content
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 
@gideonmanurung 
We are having a problem billing your account. Please enter a new payment method or check with your payment provider for details on why the transaction failed. You can downgrade to GitHub Free in your Billing settings.
You can always contact support with any questions.
Learn Git and GitHub without any code!
Using the Hello World guide, you’ll start a branch, write comments, and open a pull request.


wurstmeister
/
kafka-docker
146
3.8k1.9k
 Code Issues 42 Pull requests 14 Actions Projects 0 Wiki Security Insights
kafka-docker/create-topics.sh
@sscaling sscaling Build docker images from travis-ci (#335)
0efae8f on Jun 28, 2018
@sscaling@wurstmeister@d33d33@extemporalgenome@towhans
Executable File  57 lines (49 sloc)  1.48 KB
  
#!/bin/bash

if [[ -z "$KAFKA_CREATE_TOPICS" ]]; then
    exit 0
fi

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=600
fi

start_timeout_exceeded=false
count=0
step=10
while netstat -lnt | awk '$4 ~ /:'"$KAFKA_PORT"'$/ {exit 1}'; do
    echo "waiting for kafka to be ready"
    sleep $step;
    count=$((count + step))
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

if $start_timeout_exceeded; then
    echo "Not able to auto-create topic (waited for $START_TIMEOUT sec)"
    exit 1
fi

# introduced in 0.10. In earlier versions, this will fail because the topic already exists.
# shellcheck disable=SC1091
source "/usr/bin/versions.sh"
if [[ "$MAJOR_VERSION" == "0" && "$MINOR_VERSION" -gt "9" ]] || [[ "$MAJOR_VERSION" -gt "0" ]]; then
    KAFKA_0_10_OPTS="--if-not-exists"
fi

# Expected format:
#   name:partitions:replicas:cleanup.policy
IFS="${KAFKA_CREATE_TOPICS_SEPARATOR-,}"; for topicToCreate in $KAFKA_CREATE_TOPICS; do
    echo "creating topics: $topicToCreate"
    IFS=':' read -r -a topicConfig <<< "$topicToCreate"
    config=
    if [ -n "${topicConfig[3]}" ]; then
        config="--config=cleanup.policy=${topicConfig[3]}"
    fi

    COMMAND="JMX_PORT='' ${KAFKA_HOME}/bin/kafka-topics.sh \\
		--create \\
		--zookeeper ${KAFKA_ZOOKEEPER_CONNECT} \\
		--topic ${topicConfig[0]} \\
		--partitions ${topicConfig[1]} \\
		--replication-factor ${topicConfig[2]} \\
		${config} \\
		${KAFKA_0_10_OPTS} &"
    eval "${COMMAND}"
done

wait