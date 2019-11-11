#!/usr/bin/env bash

HOST=$1
CURL_CTYPE='Content-Type: application/json'

echo "Triv command central, host: '$HOST'"
echo

while :
do
    echo "e - exit"
    echo "c - clear"
    echo "n - new question"
    echo "r - reveal answer"
    echo "1 - test team foo"
    echo "2 - test team bar"
    echo "3 - test team baz"

    read -r -p "Command: " CMD

    case $CMD in
        e) break ;;
        c) curl -s "$HOST/api" -H "$CURL_CTYPE" -d '{"action": "clear"}' ;;
        r) curl -s "$HOST/api" -H "$CURL_CTYPE" -d '{"action": "reveal"}' ;;
        1) curl -s "$HOST/api" -H "$CURL_CTYPE" -d '{"action": "buzz", "team_token": "foo"}' ;;
        2) curl -s "$HOST/api" -H "$CURL_CTYPE" -d '{"action": "buzz", "team_token": "bar"}' ;;
        3) curl -s "$HOST/api" -H "$CURL_CTYPE" -d '{"action": "buzz", "team_token": "baz"}' ;;
        n)
            QUESTION=$(curl -s https://opentdb.com/api.php?amount=1 | jq -c -M .results[0])
            echo "Next question:"
            echo $QUESTION | jq
            echo

            echo "Triv reply:"
            echo $(echo $QUESTION | jq '. | {action: "set_question", question: .}' | curl -s -H "$CURL_CTYPE" -d @- "$HOST/api")
            ;;
        *) echo "Invalid choice: $CMD"
    esac

    echo
    echo

done

echo "Exiting ..."
