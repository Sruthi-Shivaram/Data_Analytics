data Cars;
set sashelp.cars;
run;

proc print data=Cars;

proc means data=Cars mean median mode std var min max;

proc means data=Cars nmiss;

data Cars_clean;
    SET Cars; 
    IF cmiss(of _character_) 
    OR nmiss(of _numeric_) > 0
     THEN 
      DELETE;
run;

proc means data=Cars_clean nmiss;

proc sql;


select count(distinct 'EngineSize'n) as 'EngineSize'n,
       count(distinct Horsepower) as Horsepower,
       count(distinct MPG_City) as MPG_City,
       count(distinct 'Weight'n) as 'Weight'n,
       count(distinct 'Wheelbase'n) as 'Wheelbase'n
  from Cars_clean;

proc stdize data=Cars_clean out=normalized_data;
   var Weight;
run;
proc stdize data=Cars_clean out=normalized_data;
   var Weight;
run;



ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=Cars_clean;
	histogram 'Weight'n /;
	
ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=normalized_data;
	histogram 'Weight'n /;

/*--Bar Panel--*/

  

ods graphics on;
proc Univariate data=Cars_clean;
var Invoice;
run;
quit;


proc freq data=Cars_clean;
table origin*type;
run;


ods graphics on;
proc gplot data=Cars_clean;
plot length*weight;
run;
quit;

data Cars_clean;
   set Cars_clean(drop= length);
   
run;

proc print data=Cars_clean(obs=5);
    * VAR Weight Height Age;  /* optional: the VAR statement specifies variables */
run;


proc sgpanel data=Cars_clean(where=(type in ('Sedan' 'Sports'))) noautolegend;
  panelby Type / novarname columns=2 onepanel;
  vbar origin / response=mpg_city stat=mean group=origin;
  rowaxis grid;
  run;


	

ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=Cars_clean;
	scatter x='Horsepower'n y='MPG_City'n /;
	xaxis grid;
	yaxis grid;

ods graphics / reset;


ods noproctitle;
ods graphics / imagemap=on;
proc corr data=Cars_clean pearson nosimple noprob plots=none;
	var 'MSRP'n 'EngineSize'n 'Cylinders'n 'Horsepower'n 'MPG_City'n 'MPG_Highway'n 'Weight'n;
run;


ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgplot data=Cars_clean;
	vbox 'EngineSize'n  / category='MPG_Highway'n;
	yaxis grid;
run;
ods graphics / reset;


proc ttest data=Cars_clean ALPHA=0.05 H0=3;
   var EngineSize;
run;



PROC CORR DATA= Cars_clean PLOTS=SCATTER(NVAR=all);
    VAR Wheelbase;
    WITH MPG_City;
    
RUN;


 
proc corr data= Cars_clean nosimple spearman;
var  Horsepower;
with MPG_Highway;
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		layout region;
		piechart category=Type /;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.CARS_CLEAN;
run;

ods graphics / reset;


%let TopN = 10;
proc freq data=Cars_clean ORDER=FREQ;
  tables make / maxlevels=&TopN Plots=FreqPlot;
run;




 
