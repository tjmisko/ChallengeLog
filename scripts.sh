#!/bin/bash
alias start="gdate +%Y-%m-%d\ %H\:%M\:%S | xargs echo "start:" >> ~/Desktop/ChallengeLog/challenge.log"
alias stop="gdate +%Y-%m-%d\ %H\:%M\:%S | xargs echo "stop:" >> ~/Desktop/ChallengeLog/challenge.log"
work_intervals() {
    cat challenge.log | \
    awk '{ print $2" "$3 }' | \
    xargs -I {} gdate -d "{}" '+%s' | \
    awk '{ if (NR % 2 == 1) { odd = $0; } else { result = $0 - odd; print int(result/36)/100 " hours"; } }'
}
running_total() {
    work_intervals | awk '{ sum+=$1 } END { print sum" hours" }'
}
status_update() {
    running_total | awk '{ print "# Ryan is currently at at "$1" hours!"}' > readme.md
    git commit -am "Ryan's $(gdate +%Y-%m-%d\ %H\:%M\:%S) status update"
    git push origin ryan
}
