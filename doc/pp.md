% pp
% Nick James
% 21-10-2011

# Introduction

pp copies it's input to stdout, optionally 
incorporating output of arbitrary programs. 

This looks like a simple scripting problem, 
but I've got a c++ hammer.

# Use case

When writing documentation using pandoc it is handy to insert
mechanically  gleaned lumps of text into the document (like this one);
ensuring that examples, output, source code or what have you are up
to date.

No doubt there are other ways pp could be used.

# Installation

Windows:
-    Unzip pp.zip, put pp.exe somewhere on your path.

Linux
-    <pre>flex -o../lex.yy.c ../pp.l
g++ -o pp ../pp.cpp ../lex.yy.c
</pre> and put pp on your PATH

# Synopsis
~~~~~
pp filename
~~~~~

# Action

pp preprocesses it's argument file. 

This is a matter of copying it's input to stdout, substituting lines 
beginning with !!PP with the output of the command as executed by the 
command processor. This incorporates the program output into the contents 
of the file being written to stdout.

If you need to suppress the last newline in the output of a !!PP cmd, 
use !!PPS instead.

If you need !!PP starting on column 1 of your output, use `!!PPecho !!PP`

# Example

For file example.txt:

~~~~~
A text file containing a !!PP directive
!!PP echo hello world
!!PPS echo look, no extra newline
Thank you and good bye.

!!PPdate /t
~~~~~

`pp example.txt` gives us: 

~~~~~
A text file containing a !!PP directive
hello world

look, no extra newline
Thank you and good bye.

05/06/2016 

~~~~~


# Bugs

+    The results of the command executed are <span class="warning">potentially disastrous</span>.
Stick to type/cat, grep, sed and echo.

+    The supplied binary may have dll dependencies that mean you have to 
     recompile the source on your machine.

# Programmers notes 

This is essentially a call to yylex(). The lex is as follows:

~~~~~~~ {.lex}
%{
#include <string>
%}

%option noyywrap
%x GOT_PP
%x GOT_PPS


%%
^!!PP           { 
                    BEGIN(GOT_PP); 
                }

^!!PPS           { 
                    BEGIN(GOT_PPS); 
                }

<GOT_PP>[^\n]*  { 
                    /* 
                    we use popen() as output from system() 
                    doesn't turn up where we want it 
                    */
                    FILE *pfp = _popen(yytext, "r");
                    if (pfp != 0)
                    {
                        while (!feof(pfp) && !ferror(pfp))
                        {
                            int c = fgetc(pfp);
                            if (c != EOF)
                                putchar(c);
                        }
                        _pclose(pfp);
                    }

                    BEGIN(INITIAL);
                }

<GOT_PPS>[^\n]* { 
                    /* 
                    we use popen() as output from system() 
                    doesn't turn up where we want it 
                    */
                    FILE *pfp = _popen(yytext, "r");
                    if (pfp != 0)
                    {
                        std::string res;
                        while (!feof(pfp) && !ferror(pfp))
                        {
                            int c = fgetc(pfp);
                            if (c != EOF)
                            {
                                char s[2];
                                s[0] = (char)c;
                                s[1] = 0;

                                res.append(s);
                            }
                        }

                        size_t resLen = res.length();
                        if (resLen > 0 && res[resLen-1] == '\n')
                            res = res.substr(0, resLen-1);
                        fprintf(stdout, "%s", res.c_str());
                    }
                    _pclose(pfp);

                    BEGIN(INITIAL);
                }

.               {
                    ECHO;
                }

~~~~~~~

## Building

~~~~~
flex pp.l
g++ -o pp.exe pp.cpp lex.yy.c
~~~~~

<p>
or use gcc\\compile.bat
</p>

# Colophon

Produced with:
<pre>
pp pp.txt.pp > pp.md
pandoc --toc -N -t html5 -c devDoc.css -s -o pp.html pp.md

2016-06-05 22:58:55
</pre>

