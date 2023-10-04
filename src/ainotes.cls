\NeedsTeXFormat{LaTeX2e}[]
\ProvidesClass{ainotes}

\LoadClass{scrreprt}


\usepackage{geometry}
\usepackage{graphicx, xcolor}
\usepackage{amsmath, amsfonts, amssymb, amsthm, mathtools, bm, upgreek}
\usepackage{hyperref}
\usepackage[nameinlink]{cleveref}
\usepackage[all]{hypcap} % Links hyperref to object top and not caption
\usepackage[inline]{enumitem}
\usepackage{marginnote}
\usepackage[bottom]{footmisc}
\usepackage{scrlayer-scrpage}
\usepackage{scrhack, algorithm, listings}
\usepackage{array, makecell}
\usepackage{acro}

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
    tabsize = 3,
    belowskip = -0.8\baselineskip
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
\newtheorem*{example}{Example}
\theoremstyle{definition}
\newtheorem*{definition}{Def}

\newcommand{\ubar}[1]{\text{\b{$#1$}}}
\renewcommand{\vec}[1]{{\mathbf{#1}}}
\newcommand{\nullvec}[0]{\bar{\vec{0}}}
\newcommand{\matr}[1]{{\bm{#1}}}


\renewcommand*{\maketitle}{%
    \begin{titlepage}
    \newgeometry{margin=3cm}
        \centering
        \vspace*{\fill}
        \huge
        \textbf{\@title}
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