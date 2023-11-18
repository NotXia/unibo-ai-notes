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

# $1: path of the directory
getDirLastHash () {
    path="$1"
    echo `awk -F"," "\\$1 == \"$path\" { print \\$2 } " $hash_file`
}

# $1: path of the directory
getDirCurrHash () {
    path="$1"
    echo `git log -n 1 --format='%h' $path/**/*.!(cls)`
}

updateHashes () {
    cd $work_dir
    echo "ainotes.cls,`git log -n 1 --format='%h' ./ainotes.cls`" > $new_hash_file
    for f in **/[!_]*.tex; do
        f_dir=$(dirname $f)
        echo "$f_dir,`getDirCurrHash $f_dir`" >> $new_hash_file
    done
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

    cd ${f_dir};

    # Insert last update date
    last_update=`LC_ALL="en_GB.UTF-8" git log -1 --pretty="format:%ad" --date="format:%d %B %Y" ./**/*.!(cls)`
    cp --remove-destination $(readlink ainotes.cls) ainotes.cls
    sed -i "s/PLACEHOLDER-LAST-UPDATE/${last_update}/" ainotes.cls

    latexmk -pdf -jobname=${f_nameonly} ${f_base}
    mv ${f_nameonly}.pdf $out_dir/${f_dir}/.
    cd $work_dir
done

updateHashes