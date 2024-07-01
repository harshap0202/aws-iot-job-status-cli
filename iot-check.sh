#!/bin/bash

THINGS_LIST=$(aws iot list-things-in-thing-group --thing-group-name $@ --query things --output text)
echo -e "Things in Group : ${THINGS_LIST}\n"

for THING in ${THINGS_LIST}; do

    JOBS_IDS=($(aws iot list-job-executions-for-thing --thing-name ${THING} --query "executionSummaries[*].jobId" --output text))

    COMPLETE_JOBS=0

    for ID in "${JOBS_IDS[@]}"; do
        TRY_NUM=0
        while [ "$TRY_NUM" != "2" ]
        do        
        STATUS=$(aws iot list-job-executions-for-job --job-id "$ID" --query 'executionSummaries[0].jobExecutionSummary.status' --output text)

            if [ "$STATUS" = "CANCELED" ]; then
            # if [ "$STATUS" = "SUCCEEDED" ]; then
                echo "${THING} : ${ID} : SUCCEEDED"
                # echo "${THING} : ${ID} : ${STATUS}"
                (( COMPLETE_JOBS++ ))
                break
            elif [[ "$STATUS" == "FAILED" || "$STATUS" == "REJECTED" || "$STATUS" == "SUCCEEDED" || "$STATUS" == "REMOVED" || "$STATUS" == "TIMED OUT" ]]; then
            # elif [[ "$STATUS" == "FAILED" || "$STATUS" == "REJECTED" || "$STATUS" == "CANCELED" || "$STATUS" == "REMOVED" || "$STATUS" == "TIMED OUT" ]]; then
                echo -e "${THING} : ${ID} : \033[0;31m${STATUS}\033[0m                   "
                break

            elif [ "$TRY_NUM" = "1" ]; then
                echo -e "${THING} : ${ID} : \033[0;31m${STATUS}\033[0m                   "
                break

            else
                for (( i=5; i>0; i-- )); do # wait for 10 minutes
                    tput el; echo "First try failed for $ID next try in : ${i} sec"
                    tput cuu 1
                    sleep 1
                done
                (( TRY_NUM++ ))
            fi
        done
    done

    echo "---------------------------------------------------------"
    if [ "$COMPLETE_JOBS" = "${#JOBS_IDS[@]}" ]; then
        echo -e "\033[0;32mAll jobs are ready in ${THING}\033[0m"
    else
        echo -e "\033[0;31mNot all jobs are ready in ${THING} | ${COMPLETE_JOBS}/${#JOBS_IDS[@]} SUCCEEDED\033[0m"
    fi    
    echo "---------------------------------------------------------"

done