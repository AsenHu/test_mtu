#!/usr/bin/env bash

ip=$(ip route | awk '/default/ {print $3}')

if [ "$ip" == "" ]
then
    ip=$(ip -6 -o route show | awk '/default/ {print $3}')
fi

mtuMin=28
mtuMax=65536

if ! type -P ping > /dev/null
then
    echo "ping not found."
    exit 1
fi

testMtu() {
    local testMtu
    testMtu=$(($1-28))
    if ping -s "$testMtu" -M do "$ip" -c 1 > /dev/null
    then
        mtuIs=good
    else
        mtuIs=big
    fi
}

calTestMtu() {
    mtuTest=$((("$mtuMin"+"$mtuMax"+1)/2))
}

resetRange() {
    if [ "$mtuIs" == "big" ]
    then
        mtuMax=$(("$mtuTest"-1))
    else
        mtuMin=$mtuTest
    fi
}

main() {
    while true
    do
        calTestMtu
        if [ "$cmd" != true ]
        then
            echo "Trying $ip $mtuTest ..."
        fi
        testMtu $mtuTest
        resetRange
        if [ "$mtuMin" == "$mtuMax" ]
        then
            break
        fi
    done
}

for arg in "$@"; do
  case $arg in
    ip=*)
      ip="${arg#*=}"
      ;;
    min=*)
      mtuMin="${arg#*=}"
      ;;
    max=*)
      mtuMax="${arg#*=}"
      ;;
    --cmd)
      cmd=true
      ;;
  esac
done

if [ "$mtuMin" -le 28 ]
then
    mtuMin=28
fi

main
if $cmd
then
    echo "$mtuMin"
else
    echo "Your MTU to $ip is $mtuMin."
fi
