*Ejemplo Freund 2.1;
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
proc print;
 run;

* -- Obtenemos las correlacciones entre las 4 variables, obtenemos las correlaciones todas con todas (Coeficiente de correlación de Pearson) --;

PROC CORR DATA=arboles;
VAR DBH  HT  VOL  D16 ;
RUN;

* VOL es un buen candidato de cara a DBH porque tiene una correlación de 0.9, es una potencia alta, hay asociacion lineal;
* Desde el punto de vista técnico es mejor usar como variable explicativa la var D16 pues tiene una correlación mas alta,
* pero es mas costosa de medir en el punto de vista práctico. Así que a veces es mejor usar una variable mas pequeña (DBH) porq 
* los costes practicos son mas baratos;
* HT con DBH tiene una correlación baja, tiene una moderacion en la influencia pero no es buena para explicar, es decir,
* que puede provocar errores si la elegimos como variable explicativa al no tener correlación alta;



* -- Dibujamos los diagramas de puntos de la variable dependiente, VOL, frente a cada una de las posibles variables explicativas --;

proc SGSCATTER data=arboles;
PLOT vol*(DBH  HT  D16);
RUN;

* VOL * DBH -> se aprecia la correlación al estar los puntos agrupados de manera que forman una línea recta, aunque 
* se aprecia que hay variabilidad. 

* VOL * HT -> vemos como difícilmente los puntos se ajustarán a una línea recta;

* El hecho de de que las correlaciones entre  VOL y cada una de las tres variables DBH, HT y D16 fueran positivas 
* se traduce en que la pendiente de la recta de regresión será positiva. Si la correlación fuera negativa, la 
* pendiente de la recta de regresión sería negativa \;



* Podemos obtener de un sólo comando un resumen estadístico de todas las variables,
* los Coeficientes de correlación y los diagramas de puntos;
proc corr data=arboles  plots= matrix;
VAR DBH  HT  VOL  D16 ;
run;

* O sólamente la matriz de diagramas de puntos, sin los coef. de correlación ni 
* los resúmenes estadísticos;
proc sgscatter data=arboles;
matrix DBH  HT  VOL  D16 ;
run;

* -- Regresión --;
proc reg data = arboles;
model VOL= DBH;
*plot VOL *DBH; *esto no es necesaio ponerlo de cara a hacer una regreesion simple, porque ya el progpio grafico nos lo va a sacar aunque en peque�o;
run; 
quit; *lo del quit tampoco es imprescindible;


*RMSE= raiz de MSE, es decir, la raiz de la media de cuadrados del error o la raiz de la desviacion tipica;
*la media del volumen o el volumen medio de madera depende liealmente del diametro meduante:

* La recta de regresión es VOL=-45.566 + 6.9161*DBH;

* Para obtener p-valores y percentiles, (ejemplo Freund p. 45, hay una errata en el nivel critico
* para alfa=0.01, aunque el resultado del test es el mismo);

data a;
pvalor=2*(1-probt(9.184,18));*p-valor exacto del test beta1=0;
pvalorf=1-probf(84.34,1,18);
z= tinv(.995, 18);
u= tinv(.975, 18);
proc print; 
RUN;


* Para obtener I.C. para los parametros Bo y B1; 
proc reg data = arboles ;*alpha=0.01;
model VOL= DBH/ clb;
*test DBH=6;
run; 
quit;



* Para obtener I.C. para los parametros y para la media de la respuesta , y predicciones; 
goptions reset=all;
proc reg data = arboles;
model VOL= DBH/p clb clm cli;
*plot VOL *DBH /conf pred;
id dbh;
run; 
quit;


*---------------------------------------------------------------------------------------------------------;
* -- Calculos paso a paso de la regresion -- ;

* Media de x (dbh) y media de y (vol);
proc means mean data = arboles;
var vol dbh;
output out=medias mean(vol dbh)=mediaV mediaD;
run;

*   Variable           Media                     
      VOL             61.8515
      DBH             15.5315;                                


data calculos;
set arboles;
Vcen= vol-61.8515;
Dcen= dbh-15.5315;
Dcen2= Dcen**2;
Vcen2= Vcen**2;
prod= Vcen*Dcen;
run;

proc means data= calculos sum;
var Dcen2 prod Vcen2;
output out=sumcuad sum(Dcen2 prod Vcen2)= Sxx Sxy Syy;
run;

  * Variable            Suma
      Dcen2         64.512055
      prod         446.173255
      Vcen2        3744.36 (Esta es la SSrestric o SSTO) ;

data estimadores;
set sumcuad;
b1= Sxy/Sxx;
set medias;
b0= mediaV-b1*mediaD;
proc print;run;
*estimadores b0=  -45.5663
             b1= 6.91612;

*Calculo de valores ajustados y residuos;
data ajustados;
set arboles;
ajus= -45.5663+6.91612*dbh;
resi= vol-ajus;
resi2= resi**2;
run;

proc gplot data= ajustados;
plot vol*dbh ajus*dbh  /overlay ;
symbol1 value= diamond cv=blue;
symbol2 value= star cv= red interpol=join;
run;
quit;


proc means sum;
var resi resi2;
run;
       *Suma(resi)=  0.0016444
        Suma(resi2)= 658.5697064 (Esta es la SSunrestric o SSE);
*---------------------------------------------------------------------------------------------------------;



