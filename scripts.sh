#!/bin/bash
alias start="date +%Y-%m-%d\ %H\:%M\:%S | xargs echo "start:" >> ~/ChallengeLog/challenge.log"
alias stop="date +%Y-%m-%d\ %H\:%M\:%S | xargs echo "stop:" >> ~/ChallengeLog/challenge.log"

work_intervals() {
    CHALLENGE_DIR = "~/ChallengeLog"
    cat $CHALLENGE_DIR/challenge.log | \
    awk '{ print $2" "$3 }' | \
    xargs -I {} date -d "{}" '+%s' | \
    awk '{ if (NR % 2 == 1) { odd = $0; } else { result = $0 - odd; print int(result/36)/100 " hours"; } }'
}

running_total() {
    work_intervals | awk '{ sum+=$1 } END { print sum" hours" }'
}

status_update() {
    CHALLENGE_DIR = "~/ChallengeLog"
    running_total | awk '{ print "# Tristan is currently at "$1" hours!"}' > $CHALLENGE_DIR/readme.md
    cat $CHALLENGE_DIR/challenge.log | sed -e 's/stop/Tristan stopped work at/' | sed -e 's/start/Tristan started work at/' | sed 's/T/* T/' >> readme.md
    echo -e "\n"
    cat $CHALLENGE_DIR/challenge.log
    echo -e "\n"
    echo "Currently at: $(running_total)"
    echo -e "\n"
    git commit -am "Tristan's $(date +%Y-%m-%d\ %H\:%M\:%S) status update"
    git push origin tristan
}
