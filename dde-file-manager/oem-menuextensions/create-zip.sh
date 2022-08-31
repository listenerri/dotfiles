#!/usr/bin/env bash

log_file="/tmp/create-zip.log"
rm -rf ${log_file}

function log_info () {
    echo "Info: $*" >> ${log_file}
}

function log_warn () {
    echo "Warnning: $*" >> ${log_file}
}

function log_error () {
    echo "Error: $*" >> ${log_file}
}

if [[ -z "$1" ]]; then
    log_error "no arguments"
    exit 255
fi

workdir=""
file_names=""
zip_file_name=""
log_info "arguments: $*"
for file_path in "$@"; do
    if [[ "${file_path}" == *" "* ]]; then
        log_error "file path contains empty space char: ${file_path}"
        exit 255
    fi
  
    if [ -e "${file_path}" ]; then
        workdir_tmp=$(dirname "${file_path}")
        file_name=$(basename "${file_path}")

        if [[ -z "${workdir_tmp}" ]]; then
            log_error "got empty dir from file path: ${file_path}"
            exit 255
        fi

        if [ ! -d "${workdir_tmp}" ]; then
            log_error "${workdir_tmp} is not dir or not exists"
            exit 255
        fi

        if [[ -z "${file_name}" ]]; then
            log_error "got empty file name from file path: ${file_path}"
            exit 255
        fi

        if [[ -z "${zip_file_name}" ]]; then
            zip_file_name="${file_name}.zip"
        fi

        file_names+="${file_name} "

        if [[ -z "${workdir}" ]]; then
            workdir="${workdir_tmp}"
            continue
        else
            if [[ "${workdir}" != "${workdir_tmp}" ]]; then
                log_error "files dir is not same: ${workdir} != ${workdir_tmp}"
                exit 255
            fi
        fi
        continue
    else
        log_error "${file_path} not exists"
        exit 255
    fi
done

if [[ -z "${workdir}" ]]; then
    log_error "working dir is empty"
    exit 255
fi

if [[ -z "${file_names}" ]]; then
    log_error "file names is empty"
    exit 255
fi

if [[ -z "${zip_file_name}" ]]; then
    log_error "dest zip file names is empty"
    exit 255
fi

log_info "workding dir is: ${workdir}"
log_info "file names is: ${file_names}"
log_info "zip file name is: ${zip_file_name}"

cd "${workdir}"

log_info "creating ${zip_file_name}"
if zip -r ${zip_file_name} ${file_names} >> ${log_file}  2>&1; then
    log_info "done"
else
    log_error "failed"
    rm "${zip_file_name}"
fi
