#! /bin/bash

UPDATE_DATE=$(date +'%Y-%m-%d %H:%M:%S')
GIT_COMMIT_DATE=$(git log --format=%cd --date=short -1)
GIT_COMMIT_HASH=$(git log --format=%h -1)

echo "git commit date: ${GIT_COMMIT_DATE}"
echo "git commit hash: ${GIT_COMMIT_HASH}"

for dir in *; do
  if [[ -d $dir ]] && [[ "$dir" != "public" ]]; then
    echo "Entering ${dir}"
    cd ${dir}
    sed -i "s/Hash: NA/Hash: \\\\lr{${GIT_COMMIT_HASH}}/g" *.tex
    sed -i "s/Updated at: NA/Updated at: \\\\lr{${GIT_COMMIT_DATE}}/g" *.tex
    docker run --rm -v $(pwd):/tex aergus/latex /bin/sh -c "cd /tex; latexmk -pdf ali_sorouramini.tex"
    mkdir -p ../public/${dir}
    cp ali_sorouramini.pdf ../public/${dir}
    echo "Leaving ${dir}"
    cd ..
  fi
done
