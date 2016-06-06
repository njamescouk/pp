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
