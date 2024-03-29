# Rewrites pdfs to remove the content outside the crop-box.

git ls-files --others --modified --exclude-standard `git rev-parse --show-toplevel`/*.pdf | while read -r pdf ; do
    echo "Rewriting $pdf"
    mv "$pdf" /tmp/ai_notes_cropped_pdf_processing.pdf
    gs -dQUIET -sDEVICE=pdfwrite -o "$pdf" /tmp/ai_notes_cropped_pdf_processing.pdf
done