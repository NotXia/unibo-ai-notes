cd $1

for f in *.png; do
    echo "Rewriting $f"
    name="${f%.*}"
    magick \
        $name.png       \
        -quality 50     \
        -flatten        \
        $name.jpg
done