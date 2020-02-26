* a2- DUREZA PLASTICA: 1.22, 1.26, 2.7 (a, b), 2.16 (a, b), 2.26 (b,c,d);


** -- Importación de los datos ---;
data durezaPlastica;
infile "/folders/myfolders/Datos/Datos Kutner/Datos_Kutner/Chapter 1 Data Sets/CH01PR22.txt";
input dureza tiempo;
run;


** ----------- 1.22 -----------------**;
** a);
proc reg data=durezaPlastica;
model dureza = tiempo;
output out=residuos r=res p=pred student=rst;
run;
proc sgscatter data=residuos;
plot dureza*pred;
run;
**b);
proc reg data=durezaPlastica;
model dureza = tiempo / P CLB;
ID tiempo;
run;


** ------------- 1.26 ---------------**;
**a);
proc reg data=durezaPlastica;
model dureza = tiempo / R;
ID tiempo;
output out=residuos r=res p=pred student=rst;
run;
**b);*** Estimador(sigma2) = MSE = 10.45893
*** Estimador(sigma) = MSE^(0.5) = 3.2340269


** ------------- 2.7 ----------------**;
**a);
proc reg data=durezaPlastica;
model dureza = tiempo /CLB alpha=0.01;
run;
**b);
* VERIFICAR QUE ES ASÏ;
data aux;
pvalor=2*(1-probt(9.184,14));
run;


** ------------- 2.16 --------------**;
data durezaPlasticaExtra;
input dureza tiempo;
cards;
"" 30
;
run;
proc append base=durezaPlastica data=durezaPlasticaExtra;
run;
proc print; run;
**a); **b);
proc reg data=durezaPlastica;
model dureza=tiempo/ CLM CLI alpha=0.02;
id tiempo;
run;
* TODO;


** ------------ 2.26 --------------**;
**b); **d);
proc reg data=durezaPlastica;
model dureza = tiempo/alpha=0.01;
output out=residuos2 r=res p=pred student=rst;
run;data aux2;
pvalorf=1-probf(506.51,1,14);
run;
**c);
** -- Caldular media de Y --;
proc means data=durezaPlastica;
var dureza;
run;
** -- Crear variable (predicho_i - media_Y) -- ;
data aux3;
set residuos2;
desviacion = pred - 225.5625000;
run;
proc print; run;
** -- Rerpesentar los dos gráficos en la misma escala --;
proc sgscatter data=aux3;
plot (res desviacion)*tiempo / uniscale=all;
run;
** MONTOGOMERY CAPÍTULO 2 - EJERCICIOS 7 Y 8;
** -- Importación de los datos --;
FILENAME REFFILE '/folders/myfolders/Datos/Datos Montgomery Ch 02/DATOS Montgomery ch.
2-20190926/data-prob-2-7.XLS';
PROC IMPORT DATAFILE=REFFILE
OUT=purezaOxigeno replace
DBMS=XLS;
GETNAMES=YES;
RUN;
proc print data=purezaOxigeno;
run;


** ---- Ejercicio 7 ---- ;
** a) b) c);
proc reg data=purezaOxigeno;model purity=hydro;
run;
** d);
proc reg data=purezaOxigeno;
model purity=hydro / CLB alpha=0.05;
run;
** e);
data purezaOxigenoExtra;
input purity hydro;
cards;
"" 1
;
run;
proc append base=purezaOxigeno data=purezaOxigenoExtra;
run;
proc print; run;
proc reg data=purezaOxigeno;
model purity=hydro / CLM alpha=0.05;
run;


** ---- Ejercicio 8 --- ;
**a);
proc corr data=purezaOxigeno;
var purity hydro;
run;
**b) c);
proc corr fisher data=purezaOxigeno;
var purity hydro;
run ;