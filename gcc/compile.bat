flex -o../lex.yy.c ../pp.l
g++ -o pp.exe ../pp.cpp ../lex.yy.c
