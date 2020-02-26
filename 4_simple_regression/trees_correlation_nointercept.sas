*Continuacion ejemplo Freund 2.1;
data arboles;
INPUT SPP  TAG  DBH  HT  VOL  D16 ;
CARDS;

     1    2  10.20   89.00   25.93   9.3

     1   33  19.13  101.00   95.71  17.3

     4   11  15.12  105.60   68.99  14.0

     4   13  17.28   98.06   73.38  14.3

     3   14  15.67  102.00   66.16  14.0

     4    1  17.26   91.02   66.74  14.3

     1   21  15.28   93.09   59.79  13.8

     1   20  14.37   98.03   58.60  13.4

     1   25  15.43   95.08   56.20  13.3

     4   50  15.24  100.80   62.91  13.5

     3   26  17.87   96.01   82.87  16.9

     3   10  16.50   95.09   65.62  14.9

     4   15  15.67   99.00   62.18  13.7

     3   25  15.98   89.02   57.01  13.9

     2   25  15.02   91.05   46.35  12.8

     2   28  16.87   95.02   65.03  14.9

     2    1  13.72   90.07   45.87  12.1

     2    2  13.78   89.00   56.20  13.6

     2    8  15.24   94.00   58.13  14.0

     3    2  15.00   99.00   63.36  14.2

;run; 
proc print; run;


PROC CORR DATA=arboles;
VAR DBH  HT  VOL  D16 ;
RUN;
*obtenemos los EMV de rho, r, y los p-valores de los contrastes rho=0 usando
el estadistico t, que equivalen a los contrastes de regresion correspondientes;

proc reg data = arboles;
model VOL = HT;
model HT = VOL;
run; quit;


** Obtenemos un I.C. para el Coef. de correlación de Pearson mediante la transformación 
** Z de Fisher. También se obtiene el p-valor para rho=0;
	PROC CORR FISHER DATA=arboles;
	VAR   HT  VOL   ;
	RUN;
	
	** Fijamos otro alpha ;
	PROC CORR FISHER (alpha=0.01) DATA=arboles;
	VAR   HT  VOL   ;
	RUN;
	
	** Fijamos otro rho;
	PROC CORR FISHER (rho=0.2 alpha=0.06) DATA=arboles;*BASADO EN LA Z DE FISHER,ME DA  I.C. PARA RHO y p-valor para rho=0.2;
	VAR   HT  VOL   ;
	RUN;



** Modelo con y sin intercept;
	proc reg data = arboles;
	model VOL= DBH/ clm ;
	*plot VOL *DBH /conf;
	run; quit;
	
	proc reg data = arboles;
	model VOL= DBH/noint clm ;
	*plot VOL *DBH /conf;
	run; quit;


** Grafico de residuos;

	proc reg data = arboles;
	model VOL= DBH;
	plot r.*p. npp.*r.;
	run; 
	quit;

* Tabla de residuos;
	proc reg data = arboles;
	model VOL= DBH/r;
	id DBH;
	output out=resid r=residuo p=pred student=restud;*si quiero guardarlos;
	run; 
	quit;

	proc univariate plot;
	var residuo;
	histogram / normal;
	run;


