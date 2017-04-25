\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{teamepsilon}[2017/01/25]

\LoadClass{beamer}

\usetheme[numbering=none,progressbar=frametitle,block=fill]{metropolis}
\setbeamercovered{dynamic}
\RequirePackage{graphicx}

\RequirePackage{ifxetex}
\ifxetex\RequirePackage{fontspec}\fi

\RequirePackage{minted}
\RequirePackage{xspace}
\RequirePackage{xcolor}
\RequirePackage{hyperref}
\RequirePackage[overlay,absolute]{textpos}

\renewcommand*\footnoterule{}
\setminted{autogobble,python3,mathescape}

\beamertemplatenavigationsymbolsempty%
\def\logoimage{../graphics/logo/team-epsilon-light}

\setlength\parindent{0pt}

\AtBeginDocument{%
    \begin{textblock*}{50mm}%
(\paperwidth-60mm,\paperheight-50mm)
        \includegraphics[width=50mm]{\logoimage}
    \end{textblock*}

    \maketitle
}

