#!/bin/bash

set -ex

helm repo up

# Find `ci` directories
for chart_file in $(find * -name Chart.yaml -print | sort); do
  # Find `.template` files
  dir=$(dirname ${chart_file})

  if [ -d "${dir}/ci" ]; then
    examples_dir="${dir}/examples"
    rm -rf ${examples_dir}
    mkdir -p ${examples_dir}
    for file in $(find ${dir}/ci -name "*-values.yaml" -type f); do
      # Render chart
      example_filename=$(basename ${file})
      helm dep build ${dir} --skip-refresh
      helm template ${dir} --values ${file} > "${examples_dir}/${example_filename}"
    done
  fi
done
