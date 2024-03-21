#! /bin/bash

# 
# Commit based .tex compiling
# $1 is the output directory.
# $2 is the directory of the current state of the files.
# 

if [ $# -eq 0 ]; then
	echo "Missing output directory"
	exit -1
fi

shopt -s globstar extglob

out_dir=`realpath $1`
old_out_dir=`realpath $2`
hash_file="$old_out_dir/.hash"
new_hash_file="$out_dir/.hash"
work_dir=`realpath src`

mkdir -p $out_dir
touch $hash_file

getDirLastHash() {
    # $1: path of the directory
    path="$1"
    echo `awk -F"," "\\$1 == \"$path\" { print \\$2 } " $hash_file`
}

getDirCurrHash() {
    # $1: path of the directory
    path="$1"
    echo `git log -n 1 --format='%h' $path/**/*.!(cls)`
}

getLastUpdateDate() {
    # Get the last update date.
    # Ignores .cls and commits containing "<noupdate>"
    echo `LC_ALL="en_GB.UTF-8" git log -1 --grep="<noupdate>" --invert-grep --pretty="format:%ad" --date="format:%d %B %Y" ./**/*.!(cls)`
}

updateHashes() {
    cd $work_dir
    echo "ainotes.cls,`git log -n 1 --format='%h' ./ainotes.cls`" > $new_hash_file
    for f in **/[!_]*.tex; do
        f_dir=$(dirname $f)
        echo "$f_dir,`getDirCurrHash $f_dir`" >> $new_hash_file
    done
}

moveHierarchyUp() {
    # Recursively moves the content of a directory up of a level.
    # $1: starting directory
    cd $1
    mv ./*.* ../
    for dir in */; do
        [ "$dir" == "*/" ] && continue
        moveHierarchyUp $dir
    done
    cd ..
    rmdir $1 2> /dev/null
}


cd $work_dir

old_class_hash=`getDirLastHash "ainotes.cls"`
curr_class_hash="$(git log -n 1 --format='%h' ./ainotes.cls)"

for f in **/[!_]*.tex; do
    f_dir=$(dirname $f)
    f_base=$(basename $f)
    f_nameonly="${f_base%.*}"
    old_hash=`getDirLastHash "$f_dir"`
    curr_hash=`getDirCurrHash "$f_dir"`

    mkdir -p $out_dir/$f_dir

    # Nothing to update
    if [[ $old_hash == $curr_hash && $old_class_hash == $curr_class_hash ]]; then
        echo "Skipping $f_dir"
        cp -r $old_out_dir/$f_dir/. $out_dir/$f_dir
        continue
    fi

    cd ${f_dir}

    # Save copy of source .tex
    cp $f_base $f_base.bkp

    # Insert last update date
    last_update=`getLastUpdateDate`
    sed -i "s/PLACEHOLDER-LAST-UPDATE/${last_update}/" $f_base

    # Compile
    latexmk -pdf -jobname=${f_nameonly} ${f_base}
    mv ${f_nameonly}.pdf $out_dir/${f_dir}/.
   
    # Restore source
    mv $f_base.bkp $f_base

    cd $work_dir
done

updateHashes

# Moves the content of each output directory up of a level
# cd $out_dir
# for course_dir in */; do
#     [ "$course_dir" == "*/" ] && continue
#     cd $course_dir
#     for dir in */; do
#         [ "$dir" == "*/" ] && continue
#         moveHierarchyUp $dir
#     done
#     cd ..
# done