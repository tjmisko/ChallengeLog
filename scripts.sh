#!/bin/bash
alias start="date +%Y-%m-%d\ %H\:%M\:%S | xargs echo "start:" >> ~/ChallengeLog/challenge.log"

alias stop="date +%Y-%m-%d\ %H\:%M\:%S | xargs echo "stop:" >> ~/ChallengeLog/challenge.log"

work_intervals() {
    cat challenge.log | \
    awk '{ print $2" "$3 }' | \
    xargs -I {} date -d "{}" '+%s' | \
    awk '{ if (NR % 2 == 1) { odd = $0; } else { result = $0 - odd; print int(result/36)/100 " hours"; } }'
}

running_total() {
    work_intervals | awk '{ sum+=$1 } END { print sum" hours" }'
}

status_update() {
    running_total | awk '{ print "# Tristan is currently at "$1" hours!"}' > readme.md
    cat challenge.log | sed -e 's/\n/\n\n/' >> readme.md
    cat challenge.log
    git commit -am "Tristan's $(date +%Y-%m-%d\ %H\:%M\:%S) status update"
    git push origin tristan
}
