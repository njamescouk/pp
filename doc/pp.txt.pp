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
!!PP type example.txt
~~~~~

`pp example.txt` gives us: 

~~~~~
!!PP pp example.txt
~~~~~


# Bugs

+    The results of the command executed are <span class="warning">potentially disastrous</span>.
Stick to type/cat, grep, sed and echo.

+    The supplied binary may have dll dependencies that mean you have to 
     recompile the source on your machine.

# Programmers notes 

This is essentially a call to yylex(). The lex is as follows:

~~~~~~~ {.lex}
!!PPtype ..\pp.l
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
!!PP type makeDoc.bat
!!PPS sDateTime
</pre>

