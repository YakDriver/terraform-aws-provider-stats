#!/bin/bash

if [ "${TF_AWS_PATH}" = "" ]; then
  echo "ERROR: Must set the TF_AWS_PATH to AWS provider AWS directory location"
fi

rm ./results/*txt || echo "Nothing to delete"
mkdir results || echo "Results directory already exists"

declare -a descriptions
declare -a all_files
declare -a tests

descriptions+=( "Resources" )
all_files+=( "resource_aws_*.go" )
tests+=( "resource_aws_*_test.go" )

descriptions+=( "Data Sources" )
all_files+=( "data_source_aws_*.go" )
tests+=( "data_source_aws_*_test.go" )

readmeFile="README.md"
cat README_header.md > ${readmeFile}

for i in "${!descriptions[@]}"; do
  all_count=$(ls -1 "${TF_AWS_PATH}/${all_files[$i]}" | wc -l)
  test_count=$(ls -1 "${TF_AWS_PATH}/${tests[$i]}" | wc -l)

  all_lines=0
  for f in "${TF_AWS_PATH}/${all_files[$i]}"; do
    line_count=$(< "${f}" wc -l)
    ((all_lines=all_lines+line_count))
  done

  test_lines=0
  for f in "${TF_AWS_PATH}/${tests[$i]}"; do
    line_count=$(< "${f}" wc -l)
    ((test_lines=test_lines+line_count))
  done

  ((non_test_files=${all_count}-${test_count}))
  ((non_test_lines=${all_lines}-${test_lines}))

  printf "## %s\n\n" "${descriptions[$i]}" >> "${readmeFile}"
  printf "All Files:%d\n" "${all_count}"  >> "${readmeFile}"
  printf "Non-Test Files:%d\n" "${non_test_files}"  >> "${readmeFile}"
  printf "Test Files:%d\n" "${test_count}"  >> "${readmeFile}"
  printf "All Lines of Code:%d\n" "${all_lines}"  >> "${readmeFile}"
  printf "Non-Test Lines:%d\n" "${non_test_lines}"  >> "${readmeFile}"
  printf "Test Lines:%d\n" "${test_lines}"  >> "${readmeFile}"
done
