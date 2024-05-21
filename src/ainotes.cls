\NeedsTeXFormat{LaTeX2e}[]
\ProvidesClass{ainotes}

\LoadClass{scrreprt}


\usepackage{geometry}
\usepackage{graphicx, xcolor}
\usepackage{amsmath, amsfonts, amssymb, amsthm, mathtools, bm, upgreek, cancel, bbm, siunitx}
\usepackage[bottom]{footmisc}
\usepackage[pdfusetitle]{hyperref}
\usepackage[nameinlink]{cleveref}
\usepackage[all]{hypcap} % Links hyperref to object top and not caption
\usepackage[inline]{enumitem}
\usepackage{marginnote}
\usepackage{scrlayer-scrpage}
\usepackage{scrhack, algorithm, listings}
\usepackage{array, makecell, multirow, booktabs}
\usepackage{acro}
\usepackage{subcaption}
\usepackage{eurosym}
\usepackage{bussproofs} % Deductive tree
\usepackage{varwidth} 

\geometry{ margin=3cm, lmargin=1.5cm, rmargin=4.5cm, marginparwidth=3cm }
\hypersetup{ colorlinks, citecolor=black, filecolor=black, linkcolor=black, urlcolor=black, linktoc=all }

\definecolor{codegreen}{rgb}{0,0.6,0}
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.58,0,0.82}
\definecolor{backcolour}{rgb}{0.95,0.95,0.92}
\lstdefinestyle{mystyle}{
    commentstyle = \color{codegreen},
    keywordstyle = \color{magenta},
    numberstyle = \tiny\color{codegray},
    stringstyle = \color{codepurple},
    basicstyle = \footnotesize\ttfamily,
    breakatwhitespace = false, 
    breaklines = true, 
    captionpos = b, 
    keepspaces = true,
    numbers = none,
    showspaces = false,
    showstringspaces = true,
    showtabs = false,
    tabsize = 3
}
\lstset{style=mystyle}
\lstset{language=Python}

\NewDocumentEnvironment{descriptionlist}{}{%
    \begin{description}[labelindent=1em]
}{
    \end{description}%
}
\setlength{\parindent}{0pt}
\renewcommand*{\marginfont}{\color{gray}\footnotesize}
\renewcommand*\chapterpagestyle{scrheadings} % Header in chapter pages

\theoremstyle{definition}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{corollary}{Corollary}[theorem]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem*{example}{Example}
\theoremstyle{definition}
\newtheorem*{definition}{Def}
\newtheorem*{remark}{Remark}

\newcommand{\ubar}[1]{\text{\b{$#1$}}}
\renewcommand{\vec}[1]{{\bm{\mathbf{#1}}}}
\newcommand{\nullvec}[0]{\bar{\vec{0}}}
\newcommand{\matr}[1]{{\bm{#1}}}
\newcommand{\prob}[1]{{\mathcal{P}\left({#1}\right)}}


\renewcommand*{\maketitle}{%
    \begin{titlepage}
    \newgeometry{margin=3cm}
        \centering
        \vspace*{\fill}
        \huge
        \href{\giturl}{\textbf{\@title}}\\
        {\Large Last update: \lastupdate}
        \vspace*{\fill}

        \Large
        Academic Year \@date\\
        Alma Mater Studiorum $\cdot$ University of Bologna
        \vspace*{1cm}
    \restoregeometry
    \end{titlepage}
    \newpage
}


\newcommand*{\makenotesfront}{%
    \newgeometry{margin=3cm}
    \maketitle
    \pagenumbering{roman}
    \tableofcontents
    \restoregeometry
    \newpage
    \pagenumbering{arabic}
}


\newcommand{\gitFAIKROne}[0]{   https://github.com/NotXia/unibo-ai-notes/tree/pdfs/year1/fundamentals-of-ai-and-kr/module1            }
\newcommand{\gitFAIKRTwo}[0]{   https://github.com/NotXia/unibo-ai-notes/tree/pdfs/year1/fundamentals-of-ai-and-kr/module2            }
\newcommand{\gitFAIKRThree}[0]{ https://github.com/NotXia/unibo-ai-notes/tree/pdfs/year1/fundamentals-of-ai-and-kr/module3            }
\newcommand{\gitLAAITwo}[0]{    https://github.com/NotXia/unibo-ai-notes/tree/pdfs/year1/languages-and-algorithms-for-ai/module2      }
\newcommand{\gitMLDM}[0]{       https://github.com/NotXia/unibo-ai-notes/tree/pdfs/year1/machine-learning-and-data-mining             }
\newcommand{\gitSMM}[0]{        https://github.com/NotXia/unibo-ai-notes/tree/pdfs/year1/statistical-and-mathematical-methods-for-ai  }

\newcommand{\eoc}[0]{\begin{flushright}\texttt{\raggedleft\small <end of course>}\end{flushright}}
