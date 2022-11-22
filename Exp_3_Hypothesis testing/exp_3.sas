data first_N_rows;
    set sashelp.snacks;
    if _N_ <= 2000
    then output;
run;
data first_N1_rows;
    set sashelp.snacks;
    if _N_ <= 4000
    then output;
run;

/*view new dataset*/
proc print data=first_N_rows;

proc means data=sashelp.snacks mean median mode std var min max;

PROC TTEST DATA= first_N_rows;
CLASS Product;
VAR Holiday;
RUN; 

PROC FREQ DATA =first_N1_rows;
 TABLES Product / CHISQ TESTP=(25 25 25 25);
RUN;


PROC REG DATA=sashelp.snacks;
MODEL  Price =Holiday;
RUN;

PROC REG DATA=sashelp.snacks;
MODEL  Price =Holiday Advertised;
RUN;


