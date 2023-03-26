#!/bin/bash

# Script to build all KiCad targets that have been changed in the PR

# Used in CI to fetch origin/main so that there is something to compare changed
# files to
if [[ ! -z $GITHUB_BASE_REF ]]; then
    git fetch origin $GITHUB_BASE_REF
fi

# Set the HEAD Git commit (the current commit)
GITHUB_SHA=${GITHUB_SHA:=$(git rev-parse HEAD)}

# Creates a list of .kicad_pcb and .kicad_sch files that have changed since the
# GITHUB_BASE_REF
files=()
for file in $(git diff --name-only --diff-filter=ACMRT ${GITHUB_BASE_SHA:-"origin/main"} ${GITHUB_SHA:-$(git rev-parse HEAD)} | grep "kicad_pro\$"); do
    files+=$file
done

# commands:
# kicad-cli sch export python-bom
# kicad-cli sch export pdf
# kicad-cli sch export svg
# kicad-cli pcb export svg

if [[ ! -z $files ]]; then
    # Clear out the build/ folder
    OUTPUT_BASE_DIR=build
    rm -rf $OUTPUT_BASE_DIR
    mkdir -p $OUTPUT_BASE_DIR
    echo "Beginning artifact generation"

    for file in ${files[@]}; do
        schematic_file=${file::-3}sch
        layout_file=${file::-3}pcb
        hardware_dirname=$(basename $(dirname $file))
        OUTPUT_DIR=$OUTPUT_BASE_DIR/$hardware_dirname
        mkdir -p $OUTPUT_DIR
        # if [[ ! -z $schematic_file ]]; then
        #     kicad-cli sch export svg --output $OUTPUT_DIR --exclude-drawing-sheet  $schematic_file
        #     kicad-cli sch export python-bom --output $OUTPUT_DIR/$hardware_dirname.xml $schematic_file
        #     kicad-cli sch export pdf --output $OUTPUT_DIR/$hardware_dirname.pdf $schematic_file
        # fi
        if [[ ! -z $layout_file ]]; then
            kicad-cli pcb export svg --output $OUTPUT_DIR/${hardware_dirname}_top.svg --layers F.Cu,B.Cu,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,User.Drawings,Edge.Cuts --exclude-drawing-sheet $layout_file
            kicad-cli pcb export svg --output $OUTPUT_DIR/${hardware_dirname}_bottom.svg --layers F.Cu,B.Cu,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,User.Drawings,Edge.Cuts -m --exclude-drawing-sheet $layout_file
        fi
    done
fi
#     kicad pcb export svg 

# # Gets a list of Bazel targets that include the files from above
# buildables=$(bazelisk query \
#     --keep_going \
#     --noshow_progress \
#     "kind(kibot, rdeps(//..., set(${files[*]})))" 2>/dev/null)

# # Only build if there are things that have changed
# if [[ ! -z $buildables ]]; then
#     echo "Building:"
#     echo "${buildables}"

#     # Build all of the targets that have changed
#     bazelisk build \
#         --config=docker-kicad \
#         --noshow_progress \
#         --build_tag_filters=kicad \
#         $buildables 2>/dev/null

#     # Clear out the build/ folder
#     rm -rf build
#     mkdir -p build

#     # Copy all the built files from their Bazel folder to the `build/` folder
#     for file in $buildables; do
#         file="${file//://}"
#         mkdir -p build/$(dirname ${file:2})
#         cp $(bazelisk info bazel-genfiles)/${file:2} build/${file:2}
#     done

#     # Create a Markdown file that will be uploaded as a GitHub PR comment
#     echo "Creating GH comment"
#     echo "# KiCad Artifacts" >> build/comment.md

#     # List of files that were generated
#     for file in $(find build -type f); do
#         chmod 777 $file
#         if [[ ! $file == "build/comment.md" ]]; then
#             url="https://oem-outline.nyc3.digitaloceanspaces.com/kicad-artifacts/${file#build/}"
#             echo "<li><a href=\"$url\">$(basename $file)</a></li>" >> build/comment.md
#         fi
#     done

#     # By default, SVGs are have transparent backgrounds, which makes things hard
#     # to read when using dark-mode on Github. This converts them to have white
#     # backgrounds
#     echo "Converting SVGs to use white backgrounds"
#     for file in $(find build -name '*.svg' -type f); do
#         cp ${file} ${file}_old
#         rsvg-convert -b white -f svg ${file}_old > ${file}
#         rm -rf ${file}_old
#     done

#     # Adds SVGs of the layouts as images (uses the same caching principles as
#     # above).
#     for file in $(find build -name "*_pcb.svg" -type f); do
#         echo "<p align=\"center\">" >> build/comment.md
#         echo "<img src=\"https://oem-outline.nyc3.digitaloceanspaces.com/kicad-artifacts/${file#build/}?ref=${GITHUB_SHA}\" width=\"60%\"/>" >> build/comment.md
#         echo "</p>" >> build/comment.md
#     done
# else
#     echo "Nothing to build"
# fi
