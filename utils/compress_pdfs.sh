cd $1

for f in *.pdf; do
    echo "Rewriting $f"
    name="${f%.*}"
    magick \
        -density 200    \
        $name.pdf       \
        -quality 50     \
        -flatten        \
        $name.jpg
done