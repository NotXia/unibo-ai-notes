FROM archlinux:latest

WORKDIR /notes

RUN pacman --noconfirm -Sy
RUN pacman --noconfirm -S git
RUN pacman --noconfirm -S texlive-basic texlive-latex texlive-binextra texlive-mathscience texlive-latexextra texlive-fontsextra texlive-bibtexextra biber

CMD ["bash", "./utils/compile.sh", "./src", "./.compiled", "./.currpdfs"]