/* Ejemplo del test no parametrico de Kruskal-Wallis  */

/* Se dispone de datos de porcentaje de arcilla en el suelo,
en distintas localizaciones. */

DATA soil;
INPUT location claypct;
cards;
1 26.5
1 15.0
1 18.2
1 19.5
1 23.1
1 17.3
2 16.5
2 15.8
2 14.1 
2 30.2
2 25.1 
2 17.4
3 19.2
3 21.4
3 26.0
3 21.6
3 35.0
3 28.9
4 26.7
4 37.3
4 28.0
4 30.1
4 33.5
4 26.3
;
run;
                 
                 
*Obtenemos boxplots y contrastes de normalidad para las distintas 
localizaciones (Por los tamaños muestrales pequeños tenemos poca potencia
para detectar la falta de normalidad);
PROC UNIVARIATE PLOT NORMAL data=soil;
BY location;
VAR claypct;
run;



* ANOVA 1F y chequeo de residuos;
proc glm data =soil;
CLASS location;
MODEL claypct = location;
output out= resal p=pred r=res student=rst;
means location/hovtest;
proc print data=resal;
run;


proc sgplot data=resal;
scatter y=res x=pred;
*scatter y=rst x= pred;
run;


proc univariate plot normal data=resal;
var res;
*qqplot;
run;

*claramente hay falta de normalidad;
*no parece haber heterocedasticidad, pero podriamos a�adir 
means location/hovtest;




*Para detectar dependencia entre observaciones consecutivas;
data a;
set resal;
num=_n_;
run;
proc sgplot;
scatter y=claypct x=num;
run;

proc sgplot;
scatter Y=rst x=num;
run;
* En el gráfico de los residuos frente a las observaciones se vuelve a detectar una asimetría, 
* síntoma de una falta de normalidad de los residuos;





/* PROC NPAR1WAY con WILCOXON nos da el estadístico test de Kruskal-Wallis */
/* con el p-valor aproximado(chi-square)       */

PROC NPAR1WAY DATA=soil WILCOXON;
CLASS location;
EXACT WILCOXON / MC;
run;

/*El p-valor es axproximado pues se basa en la distribucion asintotica chi-square del estadistico test.
Puede obtenerse un p-valor EXACTO usando Monte Carlo  */


/*******************************************************************/

/*Los box -plot de los rangos se parecen a los originales, podemos hacer comparaciones multiples a partir de ellos */

/* Obtenemos los rangos */

PROC RANK DATA=soil OUT=soilrnks;
VAR claypct;
ranks ranclay;
run;
* Hay una concentración de rangos más grandes en los factores 3 y 4. Esto se debe a la influencia del factor;

PROC PRINT DATA=soilrnks;
run;


/* Comparaciones multiples con Bonferroni: */

PROC GLM DATA=soilrnks;
CLASS location;
MODEL ranclay = location;
LSMEANS location / CL PDIFF ADJUST=BON;
run;


/* No son realmente intervalos de confianza para las diferencias!             */
/*  pero podemos usar los estimadores para las diferencias entre las medias
de los rangos como orientacion para los contrastes simultaneos */
------------------------------------------------------------------------------

