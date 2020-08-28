#!/bin/bash

if [ "${TF_AWS_PATH}" = "" ]; then
  echo "ERROR: Must set the TF_AWS_PATH to AWS provider AWS directory location"
fi

declare -a descriptions
declare -a all_files
declare -a tests

descriptions+=( "Everything (For the Most Part)" )
all_files+=( "*.go" )
tests+=( "*_test.go" )

descriptions+=( "Resources" )
all_files+=( "resource_aws_*.go" )
tests+=( "resource_aws_*_test.go" )

descriptions+=( "Data Sources" )
all_files+=( "data_source_aws_*.go" )
tests+=( "data_source_aws_*_test.go" )

readmeFile="README.md"
cat README_header.md > ${readmeFile}

for i in "${!descriptions[@]}"; do
  all_count=$(ls -1 ${TF_AWS_PATH}/${all_files[$i]} | wc -l)
  test_count=$(ls -1 ${TF_AWS_PATH}/${tests[$i]} | wc -l)

  all_lines=0
  for f in ${TF_AWS_PATH}/${all_files[$i]}; do
    line_count=$(< "${f}" wc -l)
    ((all_lines=all_lines+line_count))
  done

  test_lines=0
  for f in ${TF_AWS_PATH}/${tests[$i]}; do
    line_count=$(< "${f}" wc -l)
    ((test_lines=test_lines+line_count))
  done

  ((non_test_files=${all_count}-${test_count}))
  ((non_test_lines=${all_lines}-${test_lines}))

  printf "\n\n## %s\n\n" "${descriptions[$i]}" >> "${readmeFile}"

  printf "|  %s  |  %s  |\n" "Stat" "Count" >> "${readmeFile}"
  printf "| ------------- | -------------: |\n" >> "${readmeFile}"

  printf "|  %s  |  %'.f  |\n" "All Files" "${all_count}"  >> "${readmeFile}"
  printf "|  %s  |  %'.f  |\n" "Non-Test Files" "${non_test_files}"  >> "${readmeFile}"
  printf "|  %s  |  %'.f  |\n" "Test Files" "${test_count}"  >> "${readmeFile}"
  printf "|  %s  |  %'.f  |\n" "Lines of Code" "${all_lines}"  >> "${readmeFile}"
  printf "|  %s  |  %'.f  |\n" "Non-Test Lines" "${non_test_lines}"  >> "${readmeFile}"
  printf "|  %s  |  %'.f  |\n\n" "Test Lines" "${test_lines}"  >> "${readmeFile}"
done

printf "\n\n\n[%s](%s)\n" "AWS EC2 Instance Types/Prices" "https://github.com/YakDriver/aws-ec2-instance-types"  >> "${readmeFile}"
