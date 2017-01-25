\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{teamepsilon}[2017/01/25]

\LoadClass{beamer}

\usetheme[numbering=none,progressbar=frametitle,block=fill]{metropolis}
\setbeamercovered{dynamic}
\RequirePackage{graphicx}

\RequirePackage{ifxetex}
\ifxetex\RequirePackage{fontspec}\fi

\RequirePackage{minted}
\RequirePackage{xcolor}
\RequirePackage{hyperref}

\renewcommand*\footnoterule{}
\setminted{autogobble,python3,mathescape}
%\usemintedstyle{emacs}

\beamertemplatenavigationsymbolsempty%

\setlength\parindent{0pt}

\AtBeginDocument{%
    \maketitle
}

