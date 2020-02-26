*------------ Ejercicio 2 --------------------;

* 1. Importación de los datos;
proc import
datafile='/folders/myfolders/Datos/Datos_ejercicios_ANOVA_1F/datatab_6_29.xls'
out=mice replace
DBMS=xls;
sheet="mice";
getnames=yes;
run;
proc print; run;
* a) Estudia si este factor influye en el tiempo correspondiente;
proc anova data=mice;
class color;
model time=color;
run;
* b);
means color/DUNCAN BON TUKEY;
run;
*c) ;
means color/DUNNETT ('grn');
run;
* --------------------- Acuicultura -----------------------------;
* Importar los datos;
data peces;
input dosis $;
do i=1 to 12;
input Nparas;
output;end;
cards;
Control
5065
72
46
38
29
70
85
72
40
57
59
25mg
49
47
30
62
62
60
19
28
56
62
55
40
50mg
20
59
64
61
28
47
29
41
60
57
61
38
100mg
20
23
38
31
27
16
27
18
22
12
24
11
125mg
18
30
22
26
3111
15
12
31
36
16
13
;
run;
* 1.Chequeo de las hipótesis del modelo;
** 1.1. Estadísticos básicos de la variable respuesta según el factor;
proc means data=peces;
var Nparas;
class dosis;
run;
*** Gráfico de puntos;
proc sgplot data=peces;
scatter y=Nparas x=dosis;
run;
*** Gráfico de cajas múltiple;
proc boxplot data=peces;
plot Nparas*dosis;
run;
** 1.2. Ajuste del modelo.
*** Cálculo de los valores predichos, los residuos y de los residuos estandarizados;
proc glm data=peces;
class dosis;
model Nparas=dosis;
output out=resal p=pred r=res student=rst;
proc print data=resal;
run;
*** Representación de los residuos estandarizados según los niveles del factor;
proc sgplot data=resal;
scatter y=rst x=dosis;
run;
proc boxplot data=resal;
plot rst*dosis;
run;
** 1.3. Normalidad de los errores;
proc univariate plot normal data=resal;
var rst;
run;** 1.4. Homocedasticidad de los errores;
*** Obtenemos las varianzas de los errores según el nivel del factor;
proc univariate data=resal;
var res;
class dosis;
run;
** 1.5. Independencia de los errores;
data a;
set resal;
num=_n_;
run;
proc sgplot;
*scatter y=Nparas x=num;
scatter y=rst x=num;
run;quit;
*--------------------------------------------------------------------------------------;

* 2. Cuestiones;
** a);
*Gráfico de puntos obtenido en la sección 1.1;
proc anova data=peces;
class dosis;
model Nparas=dosis;
run;
** b);
means dosis/ T BON CLM;
run;
** c);
means dosis/ LSD BON TUKEY SCHEFFE CLDIFF;
run;
means dosis/ LSD BON TUKEY SCHEFFE CLDIFF alpha=0.1;
run;
** d);
means dosis/DUNNETT ('Control');
run;** e);
proc glm data =peces;
class dosis;
model Nparas=dosis/solution clparm;
estimate '25-50 vs. 100-125' dosis 0 0.5 .5 -.5 -.5;
run;