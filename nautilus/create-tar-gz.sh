#!/usr/bin/env bash

log_file="/tmp/create-tar-gz.log"
rm -rf ${log_file}

echo "current workdir is: $(pwd)" >> ${log_file}

echo "env NAUTILUS_SCRIPT_SELECTED_FILE_PATHS is:" >> ${log_file}
echo "${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}" >> ${log_file}

echo "geting selected file names:" >> ${log_file}
RAW_IFS=$IFS
IFS=$'\n'
for file_path in ${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}; do
    echo "file path: ${file_path}" >> ${log_file}
    if [[ -z "${file_path}" ]]; then
        echo "Error: file path empty" >> ${log_file}
        exit 255
    fi

    file_name=$(echo "${file_path}" | awk -F'/' '{print $NF}')
    echo "file name: ${file_name}" >> ${log_file}
    if [[ -z "${file_name}" ]]; then
        echo "Error: file name empty" >> ${log_file}
        exit 255
    fi
    if echo "${file_name}" | grep -P '\s'; then
        echo "Error: file name contains whitespace character" >> ${log_file}
        exit 255
    fi

    if [[ -z "${file_names}" ]]; then
        file_names="${file_name}"
        tar_gz_file_name="${file_name}.tar.gz"
        continue
    fi
    file_names="${file_names} ${file_name}"
done
IFS=${RAW_IFS}

echo "files to tar: ${file_names}" >> ${log_file}
if [[ -z "${file_names}" ]]; then
    echo "Error: empty files to tar" >> ${log_file}
    exit 255 
fi

echo "tar file name: ${tar_gz_file_name}" >> ${log_file}
if [[ -z "${tar_gz_file_name}" ]]; then
    echo "Error: empty tar file name to create" >> ${log_file}
    exit 255 
fi

echo "creating ${tar_gz_file_name}" >> ${log_file}
if tar zcf ${tar_gz_file_name} ${file_names} >> ${log_file}  2>&1; then
    echo "done" >> ${log_file}
else
    echo "failed" >> ${log_file}
fi
