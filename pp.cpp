#include <cstdio>
#include <string>

#pragma warning (disable: 4996)

void usage();

char *progname = 0;
extern FILE *yyin;
int yylex (void);

int main (int argc, char *argv[])
{
    progname = argv[0];

    bool firstArgIsOption = false;
    
    if (argc == 2)
    {
        firstArgIsOption = (argv[1][0] == '-');
    }
    else
    {
        usage();
        return 1;
    }

    std::string inputFile = argv[1];

    if (firstArgIsOption)
    {
        switch (argv[1][1])
        {
        case 'h':
        default:
            usage();
            return 1;
        }

        inputFile = argv[2];
    }

    FILE *fp = fopen(inputFile.c_str(), "rt");
    if (fp == 0)
    {
        std::string msg = progname;
        msg += " error opening ";
        msg += argv[1];
        
        perror(msg.c_str());

        return 2;
    }

    yyin = fp;
    yylex();

    fclose(fp);

    return 0;
}

void usage()
{
    fprintf(stderr, "%s filename\n", progname);
    fprintf(stderr, 
            "copies filename to stdout, replacing lines \n"
            "starting with !!PPcmd with the results of \n"
            "running _popen(cmd)\n\n"
            "use !!PPS in your input file to supress the \n"
            "newline at the end of cmd output.\n");
}
