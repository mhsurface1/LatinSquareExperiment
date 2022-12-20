title 'Latin Square Design';
   proc plan seed=51490;
      factors Row=3 ordered Col=3 ordered / noprint;
      treatments Tmt=3 cyclic;
      output out=LatinSquare
             Row cvals=('Batch 1' 'Batch 2' 'Batch 3') random
             Col cvals=('Chocolate Chip' 'Reese' 'Oatmeal Raisin') random
             Tmt nvals=(      1     2     3) random;
   quit;
   proc sort data=LatinSquare out=LatinSquare;
      by Row Col;
   proc transpose data= LatinSquare(rename=(Col=_NAME_))
                  out =tLatinSquare(drop=_NAME_);
      by Row;
      var Tmt;
   proc print data=tLatinSquare noobs;
   run;


OPTIONS LS=80 ;
DATA cookies;
INPUT BATCH FLAVOR FLOUR$ Radius @@;
CARDS;
1 1 B 1.51 1 2 A 1.67 1 3 C 0.97
2 1 C 1.24 2 2 B 1.43 2 3 A 1.45
3 1 A 1.95 3 2 C 1.16 3 3 B 1.28
;
RUN;

PROC GLM;
CLASS BATCH FLOUR FLAVOR;
MODEL RADIUS = FLOUR FLAVOR BATCH/p;
MEANS FLOUR/ LINES CLDIFF TUKEY;
output out=new predicted =yhat residual=resid  ;
 run;
 proc timeplot data=new;
 plot resid/joinref ref =0;
 run; 
PROC GPLOT data=new;
 PLOT resid*yhat/vref=0;
 plot resid * diet/vref=0;
plot resid * cow/vref=0;
plot resid * period/vref =0
run;
PROC UNIVARIATE plot normal  ;
  QQPLOT resid / normal;
  var resid;
  run;

