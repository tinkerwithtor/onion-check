#!/bin/bash

# change it
site="http://someurl.onion"

for test in 9150 9050 ''; do 
    { >/dev/tcp/127.0.0.1/$test; } 2>/dev/null && { tsport="$test"; break; }
    [[ "${tsport}" ]] || { echo -e "\n\e[1;31mNo open tor port found ...\e[0m\n"; exit; }
done

time_prompt="0"
while :; do
    echo -e "\n$(date -d "00:00:00 $time_prompt seconds" +"%H:%M:%S")"
    if curl -x "socks5h://127.0.0.1:${tsport}" -s --head  --request GET "${site}" | grep "200 OK" > /dev/null; then
           echo "${site} IS UP AND RUNNING"
           sleep 1800
           time_span="1800"
    else
        echo -e "\n\e[1;31m${site} IS DOWN OR NOT RESPONDING\e[0m"
    fi
    time_prompt=$(($time_prompt + $time_span))
done
