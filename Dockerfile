FROM archlinux:latest

WORKDIR /notes

RUN pacman --noconfirm -Syu && pacman --noconfirm -S git texlive-basic texlive-latex texlive-binextra texlive-mathscience texlive-latexextra texlive-fontsextra texlive-bibtexextra biber perl perl-mozilla-ca
RUN ln -s /usr/bin/vendor_perl/biber /usr/bin/biber

RUN git config --global --add safe.directory /notes

CMD ["bash", "./utils/compile.sh", "./src", "./.compiled", "./.currpdfs"]