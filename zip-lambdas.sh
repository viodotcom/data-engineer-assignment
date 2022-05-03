#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

project_root=$(pwd)

log() {
    printf "%s %s %s\n" "zip-lambdas INFO" "$(date)" "$1"
}

log "project root = $project_root"

zip_lambda() {
    function_name=$1
    log "zipping lambda $function_name"

    cd $project_root/lambda/$function_name
    output=$project_root/deployment/$function_name.zip
    log "output file = $output"
    if [ -f $output ]; then
        log "delete existing $output"
        rm $output
    fi
    log "install requirements"
    if [ -f requirements.txt ]; then
        log "installing python dependency for lambda $function_name"
        virtualenv .env -p python3
        pip=.env/bin/pip
        $pip install -r requirements.txt -t lib --upgrade
    fi
    log "zipping $function_name"
    rm -rf __pycache__
    zip -X -r $output *.py
    if [ -d lib ]; then
        log "zipping python dependency for lambda $function_name"
        cd lib
        zip -g -r $output *
    fi
    log "done zipping $function_name"
}

if [ -d lambda ]; then
    cd lambda
    for dir in *
    do
        zip_lambda $dir
    done
fi
