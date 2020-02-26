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

;run; proc print; run;

PROC CORR DATA=arboles;
VAR DBH  HT  VOL  D16 ;
RUN;

*comparacion de resultados en regresion multiple y simple;
proc reg data = arboles;
model VOL= DBH HT D16;
model VOL= DBH ;
run; quit;


*test Ho: b(HT)=b (D16)=0 en el modelo completo;
proc reg data = arboles;
model VOL= DBH HT D16;
test HT=0, D16=0;
run; quit;

*La suma de cuadrados del error del modelo restringido podemos obtenerla con:;
proc reg data = arboles;
model VOL= DBH;
run; 
quit;
*observamos que SSE=658.56971, si le restamos la del modelo completo, SSE= 153.30071, 
obtenemos la SS(hipotesis)=505.269, con 2 grados de libertad. El cociente, 252.6 es el 
numerador del test, mientras que el denominador ees el MSE del modelo completo.;

*para hacer el contraste individual DBH=0 con el test F;
proc reg data = arboles;
model VOL= HT D16;
run; 
quit;


*obtenemos SSE(HT, D16)= 177.36, le restamos SSE(DBH, HT, D16)= 153.30071 y obtenemos la 
SS(hipotesis)=24.06 con 1 G.L., al dividir por MSE obtengo el estadistico F=2.51,cuya raiz
cuadrada es 1.58, el estadistico t del contraste parcial correspondiente, e igual p-valor;
data a;
pvalor= 1-probf(2.51, 1, 16);
proc print; run;

*otra opcion equivalente;
proc reg data = arboles;
model VOL= DBH HT D16;
test dbh=0;
run; quit;



*para obtener I.C. para los parametros;
proc reg data = arboles alpha=0.03333;
model VOL= DBH HT D16/clb;
run; quit;


*I. C.  para la respuesta media, e intervalos de prediccion;
proc reg data = arboles;
model VOL= DBH HT D16/  clm cli;
run; quit;

*coeficiente de correlacion multiple;
proc reg data = arboles;
model VOL= DBH HT D16;
output out=predic p=predvol r=res student=std;
run; quit;


proc corr data= predic;
var vol predvol;
run;
 *corr(vol,predvol)=0.97932, su cuadrado es R-Square =0.9591;

 
