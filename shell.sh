#!/bin/bash

# perhaps use arguement
input_file="${1}"
echo "input_file -> ${input_file}"

output_file="${2}"
echo "output_file -> ${output_file}"

record_sep="${3}"

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "script_directory -> ${script_directory}"

base_name=${script_directory%%+(/)}
base_name=${base_name##*/} 
echo "base_name -> ${base_name}"

if [ -z "$3" ]
    then
       echo "no rs supplied"
       record_sep=$def_sep
fi

echo "record_sep -> ${record_sep}"
IFS="~" # need to reset?
mnd_fenced_array=($(awk -v RS="${record_sep}" -v ORS='~' '/```mermaid/{flag=1}flag; /```[\r\n]+/{flag=0}' $input_file))

# generate mnd files from array
for i in "${mnd_fenced_array[@]}"
do
    echo "===="
    # from the records (full of rubbish, i only want the mermaid fence)
    clean_fence=$(awk '/```mermaid/{flag=1}flag; /```[\n]/{flag=0}' <<< ${i})
    # echo "clean_fence -> ${clean_fence}"

    # mermaid from the mermaid fence
    clean_mnd=$(sed '1d;/```/ d' <<< ${clean_fence})
    echo "clean_mnd -> ${clean_mnd}"

    # # fence name from the mermaid fence
    diag_name=$(echo ${clean_fence} | awk 'NR==1{print $2;}')
    echo "diag_name -> ${diag_name}"

    filename_ex=$(echo "./mermaid/charts/${diag_name}").mnd
    echo "filename_ex -> $filename_ex"

    if [ -e $(echo ${filename_ex}) ]
    then
        echo "${filename_ex} exists"
    else
        echo $clean_mnd >> $(echo ${filename_ex})
    fi
done

# generate images from mmd file
for mnd_file_name in ./mermaid/charts/*mnd; do
    echo "mnd_file_name -> ${mnd_file_name}"
    filename="${mnd_file_name##*/}"
    filename_noex="${filename%%.*}"
    echo "filename_noex -> ${filename_noex}"
    filename_png="${filename_noex}".png
    echo "generating -> ${filename_png}"
    mmdc -i $mnd_file_name -o ./mermaid/images/${filename_png}
done

# inject images
gawk '{ $0 = gensub(/```mermaid (\w+)/, "![\\1](./'"mermaid/images"'/\\1.png \"\\1\")\n```mermaid \\1", "g"); print }'  $input_file > $output_file

# remove row separaters
gawk -i inplace '{ $0 = gensub(/'"$record_sep"'/, "", "g"); print }' $output_file