%% Copyright 2016 Christophe Roger
%
% Author: 
% Christophe Roger (Darwiin)
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3c
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainer of this work is M. C. Roger.
%
% This work consists of the files awesome-source-cv.cls 

\ProvidesClass{yaac-another-awesome-cv}[2018/07/19  v1.9.2 'YAAC: Another Awesome CV' Class]

\LoadClass[a4paper]{article}

\newif\if@showLinks   \@showLinksfalse

\DeclareOption{green}{
  \def\@green{green}
}

\DeclareOption{red}{
  \def\@red{red}
}

\DeclareOption{indigo}{
  \def\@indigo{indigo}
}
\DeclareOption{orange}{
  \def\@orange{orange}
}

\DeclareOption{monochrome}{
  \def\@monochrome{monochrome}
}

\DeclareOption{localFont}{
  \def\@local{local}
}

\DeclareOption{alternative}{
  \def\@alternative{alternate}
}

\DeclareOption{showLinks}{ \@showLinkstrue}

\ProcessOptions

% Dependences
%A Few Useful Packages
\RequirePackage[english]{babel}
\RequirePackage{fontspec} 					                 % for loading fonts
\RequirePackage{url,parskip} 	    % other packages for formatting
\RequirePackage[usenames,dvipsnames]{xcolor}
\RequirePackage{fullpage}
\RequirePackage[margin=1.5cm]{geometry}
\RequirePackage{fontawesome}
\RequirePackage{hyperref}
\RequirePackage{titlesec}
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{longtable} 	
\RequirePackage{etoolbox}
\RequirePackage{tikz}
\RequirePackage[skins]{tcolorbox}
\RequirePackage{fancyhdr}

% Define default accent colors
\definecolor{basecolor}{HTML}{1A1A75}       %BLUE

\ifundef{\@green} {
  \ifundef{\@red} {
    \ifundef{\@indigo}{
      \ifundef{\@orange} {
        \ifundef{\@monochrome} {}
        { \definecolor{basecolor}{HTML}{000000}}
      }
      { \definecolor{basecolor}{HTML}{e68a00} }
    }
    { \definecolor{basecolor}{rgb}{0.2, 0.07, 0.48} }
  }
  { \definecolor{basecolor}{HTML}{b30000} }     %RED
}
{ \definecolor{basecolor}{rgb}{0.0, 0.62, 0.38} }

\definecolor{darkGrey}{HTML}{989898}

\colorlet{accentcolor}{basecolor}
% Les liens et les pictogrammes utilisent leurs propres teintes de bleu nuit,
% independamment de la couleur d'accentuation choisie via les options de classe.
\definecolor{linkcolor}{rgb}{0,0,0.4}
\definecolor{symbolcolor}{rgb}{0.15,0.15,0.49}
\definecolor{tagtext}{HTML}{666666}

% Noir pur, identique a la palette du CV de reference (mesure : #000000
% sur le texte courant). Le nom "softblack" est conserve pour ne pas avoir
% a retoucher tous les points de reinitialisation de couleur qui l'utilisent.
\definecolor{softblack}{HTML}{000000}
\AtBeginDocument{\color{softblack}}

% Setup hyperref package, and colours for links
%\definecolor{linkcolour}{rgb}{0,0.2,0.6}

\if@showLinks
  \hypersetup{%
    breaklinks
  }%
\else
  \hypersetup{%
    pdfborder = {0 0 0},
    breaklinks
  }%
\fi

% Setup fancyhdr package
\fancyhf{}
\fancyhfoffset{0em}
% Remove head rule
\renewcommand{\headrulewidth}{0pt}
%\fancyfoot[C]{\thepage}
\pagestyle{fancy}

%\pagestyle{empty}                         % non-numbered pages
%\font\fb=''[cmr10]''                      % for use with \LaTeX command

% Setup CV sections
\titleformat{\section}{\Large\raggedright}{}{0em}{}[\titlerule]
\titlespacing{\section}{0pt}{2pt}{2pt}

% Configure list
\setlist[itemize,1]{label=\faAngleRight, itemsep=0pt, topsep=0.25em, parsep=0pt, leftmargin=2em}
\setlist[itemize,2]{label=\faAngleRight, itemsep=0.12em, topsep=0.2em, parsep=0pt, leftmargin=1.5em}

% Setup Array : new column type
\newcolumntype{R}[1]{>{\hfill}m{#1}}

%Italian hyphenation for the word: ''corporations''
\hyphenation{im-pre-se}

% Desactive la coupure automatique des mots : les lignes sont justifiees en
% jouant uniquement sur les blancs. Les cesures explicites (mots composes tels
% que ''production-grade'') restent des points de coupure valides.
% \tolerance garde sa valeur par defaut : TeX serre les blancs au maximum
% plutot que de relacher les lignes, quitte a produire quelques hbox overfull.
\hyphenpenalty=10000
% Espacement uniforme apres la ponctuation : les blancs gardent tout leur
% potentiel de compression, ce qui permet de serrer les lignes.
\frenchspacing

% Setup fonts
\defaultfontfeatures{Ligatures=TeX}
%

% Define font to use according to localFont option
\ifundef{\@local}
{
  %\setmainfont[BoldFont = Helvetica Neue, ItalicFont=Helvetica Neue Thin Italic ,SmallCapsFont = Helvetica Neue Light]{Helvetica Neue Thin}
  \setmainfont{Source Sans Pro Light}[
    BoldFont = SourceSansPro-Regular, 
    ItalicFont= Source Sans Pro Light Italic]
}
{
  % Ruta relativa al directorio de trabajo de lualatex (la raiz de latex/,
  % no en/ ni es/): infra/compile.ps1 compila con cwd=latex/ pasando
  % en/cv.tex o es/cv.tex como argumento, para que hyperref/rerunfilecheck
  % no choquen con -output-directory apuntando fuera del arbol de cwd.
  \setmainfont{SourceSansPro-Light}[
    Path = fonts/,
    BoldFont = SourceSansPro-Regular,
    ItalicFont = SourceSansPro-LightIt]
}

%New length definition
\newlength{\rightcolumnlength}
\setlength{\rightcolumnlength}{14.8cm}

% Espacements verticaux d'une entree d'experience (environnement 'experiences').
\newlength{\cvrowheadsep}     % entete de l'experience -> corps
\setlength{\cvrowheadsep}{2.4pt}
% Le corps est un minipage[t] : sa profondeur depasse toujours un \\[...],
% l'air au-dessus des technologies se regle donc par la hauteur de leur ligne.
\newlength{\cvtagrowheight}   % hauteur de la ligne des technologies
\setlength{\cvtagrowheight}{17.2pt}
\newlength{\cvrowtagsep}      % technologies -> experience suivante
\setlength{\cvrowtagsep}{10.4pt}

% Espacements verticaux d'un bloc client au sein d'une mission de conseil.
\newlength{\cvclientpresep}   % avant l'entete du client
\setlength{\cvclientpresep}{4.75pt}
\newlength{\cvclientpostsep}  % entete du client -> ses realisations
\setlength{\cvclientpostsep}{-0.5pt}

% Air avant les technologies d'un projet (environnement 'projects').
\newlength{\cvprojecttagsep}
\setlength{\cvprojecttagsep}{4.1pt}

\newlength{\leftcolumn}
\setlength{\leftcolumn}{2.5cm}

% Font Awesome icons aliases
\newcommand{\mailSymbol}{\faAt}
\newcommand{\locationSymbol}{\faMapMarker}
\newcommand{\infoSymbol}{\faInfo}
\newcommand{\linkedinSymbol}{\faLinkedin}
\newcommand{\viadeoSymbol}{\faViadeo}
\newcommand{\mobileSymbol}{\faMobilePhone}
\newcommand{\githubSymbol}{\faGithub}
\newcommand{\webSymbol}{\faGlobe}

\newcommand\link[2]{\color{linkcolor}\href{#1}{#2}\color{softblack} }
\newcommand\important[1]{\textbf #1}

% Create a tag
% Usage: \cvtag{<tag label>}
\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=darkGrey!70,rounded corners=0.35ex,inner xsep=1ex,inner ysep=0.35ex,text height=1.45ex,text depth=.45ex]{#1};
}

% Render author's name
% Usage: \user{<firstanme>}{<lastname>}
\newcommand\user[2]{\color{accentcolor}{\LARGE #1 \textsc{\textbf{#2}}}\color{softblack}}

% Render a text with its symbol
% Usage; \socialtext{<icon>}{<label>}
\newcommand{\socialtext}[2]{\mbox{\textcolor{symbolcolor}{#1}\hspace{0.5em}#2\hspace{1em}}}

% Render a link with its symbol
% Usage; \sociallink{<icon>}{<label>}
\newcommand{\sociallink}[3]{\mbox{\textcolor{symbolcolor}{#1}\hspace{0.5em}\link{#2}{#3}\hspace{1em}}}

% Define author's name
% Usage: \name{<firstname>}{<lastname>}
% Usage: \firstname{<firstname>}
% Usage: \lastname{<lastname>}
% Usage: \familyname{<familyname>}
\newcommand*{\name}[2]{\def\@firstname{#1}\def\@lastname{#2}}
\newcommand*{\firstname}[1]{\def\@firstname{#1}}
\newcommand*{\lastname}[1]{\def\@lastname{#1}}
\newcommand*{\familyname}[1]{\def\@lastname{#1}}
\def\@familyname{\@lastname}

% Define author's tagline
% Usage: \tagline{<tag line>}
\newcommand*{\tagline}[1]{\def\@tagline{#1}}

% Define author's photo
% Usage \photo{<diameter>}{<photo>}
\newcommand{\photo}[2]{\def\@photo{#2}\def\@photodiameter{#1}}

% Render author's address
% Usage: \address{<address>}
\newcommand*{\address}[1]{\socialtext{\locationSymbol}{#1}}

% Render author's infos
% Usage: \infos{<infos>}
\newcommand*{\infos}[1]{\socialtext{\infoSymbol}{#1}}

% Compute an age in completed years from a birth date, using the engine's
% current date (\year/\month/\day, set at compile time) as "today".
% Usage: \ageinyears{<birth year>}{<birth month, 1-12>}{<birth day>}
\newcount\@ageinyears
\newcommand*{\ageinyears}[3]{%
  \@ageinyears=\year
  \advance\@ageinyears by -#1 %
  \ifnum\month<#2
    \advance\@ageinyears by -1 %
  \else
    \ifnum\month=#2
      \ifnum\day<#3
        \advance\@ageinyears by -1 %
      \fi
    \fi
  \fi
  \the\@ageinyears
}

% Render author's linked-in (optional)
% Usage: \linkedin{<linked-in-nick>}
\newcommand*{\linkedin}[1]{\sociallink{\linkedinSymbol}{http://www.linkedin.com/in/#1/fr}{linkedin.com/in/#1}}

% Render author's viadeo(optional)
% Usage: \viadeo{<viadeo-nick>}
\newcommand*{\viadeo}[1]{\sociallink{\viadeoSymbol}{http://www.viadeo.com/fr/profile/#1}{viadeo.com/fr/profile/#1}} 

% Render author's github (optional)
% Usage: \github{<github-nick>}
\newcommand*{\github}[1]{\sociallink{\githubSymbol}{https://www.github.com/#1}{github.com/#1}}           % Github icon + URL

\newcommand*{\personalWebsite}[1]{\sociallink{\webSymbol}{https://#1}{#1}}  % Website icon + URL

% Render author's email (optional)
% Usage: \email{<email adress>}
\newcommand*{\email}[1]{\sociallink{\mailSymbol}{mailto:#1}{#1}}

% Render a website link (optional)
% Usage: \email{<email adress>}
\newcommand*{\website}[2]{\sociallink{\faExternalLink}{#1}{#2}}

% Render author's mobile phone (optional)
% Usage: \smartphone{<mobile phone number>}
\newcommand*\smartphone[1]{\socialtext{\mobileSymbol}{#1}}    

% Render author's tagline
\newcommand\resumetitle[1]{
  \ifundef{\@alternative}{
	 \par{
	 	 \bigskip\center{\Large \color{accentcolor}\textbf{#1}\color{softblack}}\par
	 }
	 \bigskip
  }{
    \color{accentcolor}\textbf{\large{#1}}\color{softblack}
  }
}

\newcommand\idphoto{
  \tikz\path[fill overzoom image={\@photo}]circle[radius=0.5\linewidth];
}

% Define social entries to print in header
\newcommand{\socialinfo}[1]{\def\@socialinfo{#1}}

% Render CV header
% Needs \@firstname, \@lastname and \@tagline to be defined
\newcommand*{\makecvheader}{
  \ifundef{\@alternative}{
    \ifundef{\@photodiameter}{
      \begin{minipage}{\linewidth}
    }{
      \begin{minipage}{\dimexpr\linewidth-\@photodiameter-2em}
    }
    \color{accentcolor}\user{\@firstname}{\@lastname}\color{softblack}\\
    \small{\@socialinfo}
    \end{minipage}
    \ifdef{\@photodiameter}{
      \begin{minipage}{\@photodiameter}
        \idphoto
      \end{minipage}
    }{}
    \resumetitle{\@tagline}
  }{
    \ifundef{\@photodiameter}{
      \begin{minipage}{\linewidth}
    }{
      \begin{minipage}{\dimexpr\linewidth-\@photodiameter-2em}
    }
    \user{\@firstname}{\@lastname}\\
    \resumetitle{\@tagline}
    \smallskip\\
    \small{\@socialinfo}
    \end{minipage}
    \ifdef{\@photodiameter}{
      \begin{minipage}{\@photodiameter}
        \idphoto
      \end{minipage}
    }{}
    \bigskip
  }
}

% Define a footer for CV
% Usage: \makecvfooter{<left>}{<center>}{<right>}
\newcommand*{\makecvfooter}[3]{%
  \fancyfoot{}
  \fancyfoot[L]{\color{softblack}#1}
  \fancyfoot[C]{\color{softblack}#2}
  \fancyfoot[R]{\color{softblack}#3}
}

% Resume part title definition
\newcommand\sectionTitle[2]{\section{\texorpdfstring{\color{accentcolor}#2\enspace \textsc{#1}}{#1}}}

% Define the 'keywords' environment
\newenvironment{keywords}{%
  \renewcommand{\arraystretch}{1.1}

  \begin{tabular}{>{}r>{}p{13cm}} 
}{%
  \end{tabular}
}

% Render a scholarshipentry in the scolarship environment
% Usage: \scholarshipentry{<date>}{<description>}
\newcommand\keywordsentry[2]{
  \textbf{#1} &   #2\\ 
}

% Define a new column type for the scholarship environment
\newcolumntype{Y}{>{\raggedleft}p{\leftcolumn}}

% Define the 'scholarship' environment
\newenvironment{scholarship}{%
  \begin{tabular}{Y p{\rightcolumnlength}}
}{%
  \end{tabular}
}

% Render a scholarshipentry in the scolarship environment
% Usage: \scholarshipentry{<date>}{<description>}
\newcommand\scholarshipentry[2]{
  #1    &  #2 \\
}

% Define the 'skills' environment
\newenvironment{skills}{%
  \begin{longtable}{R{\leftcolumn}p{\rightcolumnlength}}
}{%
  \end{longtable}
}

% Render a skill in the skills environment
% Usage: \skill{<skill>}{<level>}
\newcommand\skill[2]{
  \textbf{#1}    & \foreach \x in {1,...,5}{{\color{accentcolor!80} \ifnumgreater{\x}{#2}{\faCircleThin}{\faCircle}}\enspace } \\
}

% Colonne de droite des experiences : texte justifie (comme le reste du CV).
\newcolumntype{E}{p{\rightcolumnlength}}

% Define the 'experiences' environment
\newenvironment{experiences}{%
  \setlength{\LTpre}{0pt}
  \setlength{\LTpost}{0pt}
  \vspace{12pt}
  \begin{longtable}{R{\leftcolumn}|E}
}{%
  \end{longtable}
  \vspace{12pt}
}

% Render an experience in the experiences environment
% Updated to include work modality and time commitment
% Usage:
% \experience
%  {<End date>} {<Title>} {<Enterprise>} {<Country>}
%  {<Work modality>} {<Time commitment>}
%  {<Start date>} {<Experience description>} {<Technology list>}
\newcommand\experience[9]{
  \textbf{#1} & \textbf{#2, \textsc{#3}, #4} \hfill \emph{#5, #6} \\[\cvrowheadsep]
  \textbf{#7} & \begin{minipage}[t]{\rightcolumnlength}#8\end{minipage} \\
              & \rule{0pt}{\cvtagrowheight}\small{\foreach \n in {#9}{\cvtag{\n}}}\vspace{\cvrowtagsep} \\
}

% Render one client inside the description (8th argument) of an \experience.
% The whole consulting entry stays a single table row, exactly like a regular
% experience: header row, body row, technology row.
% Etiqueta "Client" localizable: en/cv.tex usa el valor por defecto (Client);
% es/cv.tex la redefine a "Cliente" con \renewcommand{\clientlabel}{Cliente}
% antes del primer \clientblock. Sin esto, el texto quedaba fijo en ingles
% incluso en la version en espanol (ej. "Client : Koandina - Industria de
% Bebidas", mezclando idiomas).
\newcommand{\clientlabel}{Client}

% Usage: \clientblock{<Client name>}{<Client business unit>}{<Achievements>}
\newcommand{\clientblock}[3]{%
  \par\vspace{\cvclientpresep}
  \hspace*{1em}\textbf{\clientlabel\ : #1} - \emph{#2}\par
  \vspace{\cvclientpostsep}
  \begingroup
  \setlist[itemize,1]{label=\faAngleRight, itemsep=0.15em, topsep=0.25em, parsep=0pt, leftmargin=2.5em}
  #3
  \endgroup
}

% Render a consultant experience in the experiences environment
% Usage: 
% \consultantexperience
%  {<End date>}      {<Consultant title>}{<Consulting Enterprise>}{<Country>}
%  {<Start date}     {<Client title>}{<Client business unit>}
%                    {
%                      <Experience description (Could be a list)>
%                    }
%                    {<Technology list>}
\newcommand\consultantexperience[9]{
  \textbf{#1}    & \textbf{#2, \textsc{#3}, #4}   								\\*
  \textbf{#5}    & \emph{#6} pour \textsc{#7}                       				\\*
  				       & 	\begin{minipage}[t]{\rightcolumnlength}
  						        #8
                   	\end{minipage}										\\*
                 & \small{\foreach \n in {#9}{\cvtag{\n}}} 	\\
  }

\newcommand\emptySeparator{\multicolumn{2}{c}{}\\}

% Define the 'projects' environment
\newenvironment{projects}{%
  \begin{longtable}{l}
}{%
  \end{longtable}
}

% Define the 'project' entry in the 'projects' environment
% Usage:
% \project
%   {<Project name>}{<dates>}
%   {<link1> <link2>}
%   {<Project description>}
%   {<techno1>,<techno2>}
\newcommand\project[5]{
  \begin{minipage}[t]{\dimexpr(\linewidth) - 1.5em}
    \textbf{\textsc{#1}} \hfill \textsc{#2}\smallskip\\
    #3\\
    #4\\[\cvprojecttagsep]
    \small{\foreach \n in {#5}{\cvtag{\n}}}\\
  \end{minipage}
  \\*
}


\newcommand*\twocolumnsection[2]{
  \begin{minipage}[t]{\dimexpr(\linewidth/2) - 3em}
    #1
  \end{minipage}
  \hfill
  \begin{minipage}[t]{\dimexpr(\linewidth/2) - 3em}
    #2
  \end{minipage}
  }

% Define the 'referencees' environment
\newenvironment{referees}{%
}{%
  \hfill
  \bigskip
}

% Le 4e argument (email) est optionnel : le laisser vide ({}) imprime une
% ligne vide a la place plutot que de l'omettre, pour que le telephone reste
% toujours sur la meme rangee (4e) quel que soit le referent - sinon les
% blocs sans email se decalent d'une ligne vers le haut et desalignent la
% grille entre colonnes. Le \strut est indispensable : une cellule vraiment
% vide n'a ni hauteur ni profondeur, donc la ligne vide s'affaisserait a
% presque rien au lieu d'occuper une ligne de texte normale.
% Le courriel et le telephone sont composes en \small : a taille
% normale, une adresse un peu longue (ex. dnatividadlecca@gmail.com) frole
% ou depasse la largeur du bloc (linewidth/3), qui reste etroit puisque
% jusqu'a 3 referents se partagent la ligne. La taille reduite degage assez
% de marge sans toucher au nom ni au poste, plus lisibles a taille normale.
% Le \strut de la ligne vide reprend la meme taille pour garder une hauteur
% de ligne identique, email present ou non.
% Le \quad doit rester DANS le groupe \small : mesure a taille normale
% a cote d'une icone et d'un texte retrecis, il cree un vide disproportionne
% entre l'icone et le texte plutot qu'un espacement resserre au meme rythme.
% L'ecart entre l'icone et le texte (colonne 1 -> colonne 2) vient du
% \tabcolsep par defaut (6pt de chaque cote, 12pt au total) : bien plus large
% que le \hspace{0.5em} utilise partout ailleurs entre icone et texte
% (\socialtext, \sociallink). On le remplace ici par la meme valeur pour
% rester coherent avec le reste du CV.
\newcommand*\referee[5]{
  \hspace{1em}
  \begin{minipage}[t]{\dimexpr(\linewidth/3) - 3em}
    \begin{tabular}{>{}l@{\hspace{0.5em}}l}
      \multicolumn{2}{l}{\textbf{#1}}\\
      \multicolumn{2}{l}{\emph{#2}, \textsc{#3}}\\
      \ifstrempty{#4}{{\small\strut}&\\}{{\small\quad\mailSymbol} & {\small\href{mailto:#4}{#4}} \\}
      {\small\quad\faPhone} & {\small#5} \\
    \end{tabular}
  \end{minipage}%
}

