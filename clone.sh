#!/bin/bash

# TEXT COLOR
RED="\033[0;31m"
GREEN="\033[0;32m"
RESET="\033[0m"

# OPTION
WHICH_ORG="" 
WHERE_TO="./"

# PARSE ARGS
while [[ $# -gt 0 ]]; do
    KEY="$1"
    case $KEY in
        -o|--org)
            WHICH_ORG=$2
            shift # arg
            shift # val
            ;;
        -t|--to)
            WHERE_TO=$2
            shift # arg
            shift # val
            ;;
        *)
            echo -e "${RED}Bad args${RESET}"
            exit 1
            ;;
    esac
done

# VERIFICATION
[ -d $WHERE_TO ] && [ ! -h $WHERE_TO ] && echo -e "${GREEN}Path: $WHERE_TO${RESET}" || { echo -e "${RED}Path does not exist${RESET}" ; exit 1 ; }
[ ! -z $WHICH_ORG ] && echo -e "${GREEN}Organisation: $WHICH_ORG${RESET}" || { echo -e "${RED}No organization were given to the program${RESET}" ; exit 1 ; }


# CLONE
cd $WHERE_TO
curl -s https://api.github.com/orgs/$WHICH_ORG/repos\?per_page\=200 | perl -ne 'print "$1\n" if (/"ssh_url": "([^"]+)/)' | xargs -n 1 git clone
