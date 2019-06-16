#!/bin/bash
#****************************************************************#
# Create Date: 2019-06-16 09:59
#********************************* ******************************#

ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
module_name=""
code_repo=""
save_path=""

function print_help()
{
     cat <<- EOF
    Desc: github-trigger 生成模板
    ARGS:
        -c :code repo 
            example kantive-sample/helloworld-go 
        -m : module name
            example helloworld-go
        -s: github-trigger save path 
            example /tmp/github-trigger/
    Usage: ${BASH_SOURCE[0]} -c knative-sample/helloworld-go -m helloworld-go -s /tmp/github-trigger/
    Author: kubeway
EOF
}

while getopts "c:m:s:" opt; do
    case $opt in
        m)
            module_name=${OPTARG}
            ;;
        c)
            code_repo=${OPTARG}
            ;;
        s)
            save_path=${OPTARG}
            ;;
         *)
             echo "unknown: "$opt""
             print_help
             exit 1
            ;;
    esac
    done

if [ -z "${code_repo}" ]; then
    echo "code_repo is empty"
    print_help
    exit 1
fi

if [ -z "${module_name}" ]; then
    echo "module_name is empty"
    print_help
    exit 1
fi

if [ -z "${save_path}" ]; then
    print_help
    exit 1
fi
dn="$(dirname ${save_path})"
name="$(basename ${save_path})"
echo "save_path is empty"
save_path="${dn}/${name}/"

mkdir -p ${save_path}

while read origin_file; do 
    file_name="$(basename ${origin_file})"
    echo "file_name: ${file_name}"
    echo ${origin_file} | awk -v code_repo="${code_repo}" \
        -v module_name="${module_name}" \
        -v save_path="${save_path}" \
        -v file_name="${file_name}" \
        '{print "sed \"s/{{.ModuleName}}/"module_name"/g\" "$1"| sed \"s?{{.CodeRepo}}?"code_repo"?g\" >"save_path""file_name}'
done << EOF
$(ls ${ROOTDIR}/*.yaml )
EOF
# ls ${ROOTDIR}/*.yaml |  \
#     awk -v code_repo="${code_repo}" \
#         -v module_name="${module_name}" \
#         -v save_path="${save_path}" \
#         '{print "sed \"s/{{.ModuleName}}/"module_name"/g\" "$1 "| sed \"s?{{.CodeRepo}}?"code_repo"?g\" >"save_path""$1}'
