#!/bin/bash
alias start="date +%Y-%m-%d\ %H\:%M\:%S | xargs echo "start:" >> ~/ChallengeLog/challenge.log"
alias stop="date +%Y-%m-%d\ %H\:%M\:%S | xargs echo "stop:" >> ~/ChallengeLog/challenge.log"
work_intervals() {
    cat challenge.log | \
    awk '{ print $2" "$3 }' | \
    xargs -I {} date -d "{}" '+%s' | \
    awk '{ if (NR % 2 == 1) { odd = $0; } else { result = $0 - odd; print result/3600 " hours"; } }'
}
running_total() {
    work_intervals | awk '{ sum+=$1 } END { print sum" hours" }'
}
status_update() {
    running_total | awk '{ print "# Currently at "$1" hours!"}' > readme.md
}
