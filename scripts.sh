#!/bin/bash
export CHALLENGE_DIR="C:/Users/TMisko/Tools/ChallengeLog"

usage() {
    echo unknown command: "$@"
    echo Usage: clog start|stop|intervals|total|update
}

start() {
    date +%Y-%m-%d\ %H\:%M\:%S | xargs echo "start:" >> C:/Users/TMisko/Tools/ChallengeLog/challenge.log
}

stop() {
    date +%Y-%m-%d\ %H\:%M\:%S | xargs echo "stop:" >> C:/Users/TMisko/Tools/ChallengeLog/challenge.log
}

intervals() {
    cat $CHALLENGE_DIR/challenge.log | \
    awk '{ print $2" "$3 }' | \
    xargs -I {} date -d "{}" '+%s' | \
    awk '{ if (NR % 2 == 1) { odd = $0; } else { result = $0 - odd; print int(result/36)/100 " hours"; } }'
}

total() {
    work_intervals | awk '{ sum+=$1 } END { print sum" hours" }'
}

update() {
    running_total | awk '{ print "# Tristan is at "$1" hours this week!"}' > $CHALLENGE_DIR/readme.md
    cat $CHALLENGE_DIR/challenge.log | sed -e 's/stop/Tristan stopped work at/' | sed -e 's/start/Tristan started work at/' | sed 's/T/* T/' >> readme.md
    echo -e "\n"
    cat $CHALLENGE_DIR/challenge.log
    echo -e "\n"
    echo "Currently at: $(running_total)"
    echo -e "\n"
    git commit -am "Tristan's $(date +%Y-%m-%d\ %H\:%M\:%S) status update"
    git push origin tristan
}

declare -A COMMANDS=(A
    [main]=usage
    [start]=start
    [stop]=stop
    [intervals]=intervals
    [total]=total
    [update]=update
)

"${COMMANDS[${1:-main}]:-${COMMANDS[main]}}" "$@"
