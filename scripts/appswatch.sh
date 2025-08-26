
#!/bin/bash
# spin()
# {
#   spinner="/|\\-/|\\-"
#   while :
#   do
#     for i in `seq 0 7`
#     do
#       echo -n "${spinner:$i:1}"
#       echo -en "\010"
#       sleep 1
#     done
#   done
# }

# echo "About to make a slow web call..."

# # Start the Spinner:
# spin &
# # Make a note of its Process ID (PID):
# SPIN_PID=$!




trap 'echo "Caught Ctrl+C. Exiting gracefully."; exit 1' SIGINT
readyIcon="\u2714"
waitingIcon="\\u23F3"
state=$(jq -n "{}");
lines_to_clear=5

function checkCrds {
    
    # while [ true ]; do
        local lookupKind="$1";
        
        local jqSelect='.select( ';
        for kind in "HelmChart" "Application" "ApplicationSet" "ResourceGraphDefinition" "CertManagerBundle" "MikroLab" "Argofile" "IngressRequest" "WebApp"; do
            if [[ -n "$jqSelect" ]]; then
                jqSelect="$jqSelect or ";
            fi
            jqSelect="$jqSelect .spec.names.kind == \"${kind}\" )";
        done
        echo $jqSelect
    

        local status=$(  kubectl get --kubeconfig mikrolab/kubeconfig.yaml crds -o json | jq -a ".items[] | select( .spec.names.kind == \"HelmChart\" or .spec.names.kind == \"Application\" or .spec.names.kind == \"ApplicationSet\" or .spec.names.kind == \"ResourceGraphDefinition\" or .spec.names.kind == \"CertManagerBundle\" or .spec.names.kind == \"MikroLab\" or .spec.names.kind == \"Argofile\" or .spec.names.kind == \"IngressRequest\" or .spec.names.kind == \"WebApp\"   ) | { kind: .spec.names.kind, established: .status.conditions[] | select ( .type == \"Established\" ) | .status, namesAccpeted: .status.conditions[] | select( .type == \"NamesAccepted\" ) | .status, icon: \"Ready\" }");
        
        status=$(echo $status | jq '.icon = if (.established == "True" ) then "\u2714" else "\u23F3" end' );

        local message=$(echo -e $status | jq -a '"\(.icon)\t\(.kind) \t| \(.established) \t| \(.namesAccpeted)"' | sed 's/"//g' );
        local header="Icon\tKind\t| Established\t| Names Accepted\n----\t----\t| -----------\t| --------------";
    
        echo -e "$header\n$message" | column -t -s $'\t';
        # echo -e "$message\n" 

        echo -e $status | jq
         gum style \
            --border-foreground 32 --border double \
            --align left --width 50 --margin "1 2" --padding "2 4" \
         "$(echo -e $status | jq -a '"\(.kind) | \(.established) | \(.namesAccpeted)"' | sed 's/"//g' | column -t -s $'|')"
        # local status=$(  kubectl get --kubeconfig mikrolab/kubeconfig.yaml crds -o json | jq ".items[] | select( .spec.names.kind == \"${lookupKind}\" ) | { kind: .spec.names.kind, established: .status.conditions[] | select ( .type == \"Established\" ) | .status, namesAccpeted: .status.conditions[] | select( .type == \"NamesAccepted\" ) | .status  }");

        # local test=$(echo $status | jq -r '.kind' | grep -i "$lookupKind");
        # echo -e $status | jq 'sele';
        # echo $state;
        # echo $state | jq
        # state=$(echo $state | jq ".$lookupKind = $status");
        

        # echo -e $status | jq -r '.select( .established="\True\" ) | .icon: \"Ready\"'     

        # local established=$(echo $status | jq -r '.established')
        # local namesAccepted=$(echo $status | jq -r '.nam  esAccpeted')
        # local kind=$(echo $status | jq -r '.kind')
        

        # if [[ $(echo $status | jq -r '.established') == "True" && $(echo $status | jq -r '.namesAccpeted') == "True" ]]; then
        #     icon=$readyIcon
        # fi

        # status=$(echo "$status" | jq  --argjson icon


        # echo -e $status
        # # show icon and human friendly status update

        

        # test=$(gum spin --spinner moon --title "Waiting for $lookupKind to be ready" -- kubectl wait --for=condition=Established --timeout=-1s crds $lookupKind 2>&1);
        # echo $test | grep -i "condition met" &> /dev/null

        
        # local icon=${waitingIcon}
        # local statusText="Progressing..."
        # local established=$(echo $status | jq -r '.established')
        # local namesAccepted=$(echo $status | jq -r '.namesAccpeted')
        # local kind=$(echo $status | jq -r '.kind')
        # # echo -e "Kind: $kind | Established: $established | Names Accepted: $namesAccepted";


        # if [[ "$established" == "True" && "$namesAccepted" == "True" ]]; then
        #     icon=${readyIcon}
        #     statusText="Ready"
        # fi
    
        # echo -e "${icon} ${statusText} $lookupKind";


    # done
     
}

# for kind in "$@"; do
    
checkCrds $kind #&
# done

# for kind in "$@"; do
    # Wait for the background process to finish
    # wait 
    tput cnorm
        # lines_to_clear=$(( $(echo "$state" | jq | wc -l) ));
        
        # sleep 5s;
        # for i in $(seq 1 $lines_to_clear); do

        #     tput cuu 1 # Move cursor up
        #     tput el   # Clear to end of line
        
        # done
# function message {
#         while [ true ]; do
#             echo $state | jq;

#             sleep 5s;
#         done
# }

# done

        # message=$(jq -n "$kind: \"Progressing...\"");

        # echo "$message"

        # kubewait $kind 2 &

        # message &
        # echo $statusObj | jq;

        # message="Kind: $kind"


    # checkCrds "ApplicationSet" &
    
    # lines_to_clear=$((lines_to_clear + 1))


        
        # local message=$(echo -e $status | jq '"Established: \(.established) | Names Accepted: \(.namesAccpeted) | Kind: \(.kind)"' | sed 's/"//g' );

        # local established=$(echo $status | jq -r '.established')
        # local namesAccepted=$(echo $status | jq -r '.namesAccpeted')
        # local kind=$(echo $status | jq -r '.kind')

        # Kinds as columns and established and namesAccepted as rows

        # echo -e "$message"
        # echo $state;

        
       # for loop through the state objects and echo the kind, established and namesAccepted status
        # for crd in "${state[@]}"; do
           
        #     local kind="Kind: $(echo $crd  | jq -r '.kind' )"; 
        #     # local established=$(echo $crd | jq -r '.established')
        #     echo $kind
        #     # echo "Kind: ${crd}";  
        # done

        # # local state=$(kubectl get --kubeconfig mikrolab/kubeconfig.yaml crds -o json | jq '.items[] | select( .spec.names.kind == "Application" or .spec.names.kind == "ApplicationSet" ) | { kind: .spec.names.kind, established: .status.conditions[] | select ( .type == "Established" ) | .status, namesAccpeted: .status.conditions[] | select( .type == "NamesAccepted" ) | .status  }');

        # local established=$(echo $state | jq -r '.established')
        # local namesAccepted=$(echo $state | jq -r '.namesAccpeted')
        # local name=$(echo $state | jq -r '.kind')

        # if [[ "$established" && "$namesAccepted" ]]; then
        #     echo "CRDs Ready"
        #     echo $state   
        #     echo $established
        # else
        #     echo "CRDs Progressing..."
        #     echo $state

        # fi

        # Display names of all the listed CRDs with their status

# state=$(kubectl get --kubeconfig mikrolab/kubeconfig.yaml $1 -o json | jq '.items[] | select( .spec.names.kind == "Application" or .spec.names.kind == "ApplicationSet" ) | { kind: .spec.names.kind, established: .status.conditions[] | select ( .type == "Established" ) | .status, namesAccpeted: .status.conditions[] | select( .type == "NamesAccepted" ) | .status  }');


# UPLINE=$(tput cuu1) # Move cursor up one line
# ERASELINE=$(tput el) # Erase to end of line
# REPLACE="${ERASELINE}"

# readyIcon=$(echo -e "\e[0;32m\u2714\e[0m")
# waitingIcon=$(echo -e "\e[1;33m\u23F3\e[0m")

# function kubewait {


#     local status='Progressing...'
#     local spinner="X" 
#     local results=0

#     local kind=$0
#     local desiredCount=$2

#     lines_to_clear=1

#     while [[ "$status" != "Ready" ]]; do

        
#         local icon=${waitingIcon}

#         local lines=$lines_to_clear

#         if [[ "$results" -ge "$desiredCount" ]]; then
#             icon=${readyIcon}
#             status='Ready'
#         fi
        
#         if [[ "$results" -eq 0 ]]; then
#             icon=${waitingIcon}
#             status='Progressing...'
#             lines=$((lines_to_clear + 1))
#         fi

#         if [[ "$spinner" == "X" ]]; then
#             spinner="/";
#         else
#             spinner="X"
#         fi

#         for i in $(seq 1 $lines); do
#             tput el   # Clear to end of line
#             tput cuu 1 # Move cursor up
#             tput el   # Clear to end of line
     
#         done


#         results=$( kubectl get --kubeconfig mikrolab/kubeconfig.yaml $1 -A -o=jsonpath='{.items[*].kind}' | wc -w );

#         # if [[ "$results" -eq 0 ]]; then
#         #     tput cuu1
#         #     tput el

#         # fi

        
#         echo -e "${REPLACE}${icon} ${status} $1 ${results} of desired ${desiredCount}";
        

#         # $appswatch "apps"
#         sleep 2;

#     done
# }








