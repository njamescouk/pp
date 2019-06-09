flex -o../lex.yy.c ../pp.l
g++ -DGCOMPILE=1 -o pp ../pp.cpp ../lex.yy.c
