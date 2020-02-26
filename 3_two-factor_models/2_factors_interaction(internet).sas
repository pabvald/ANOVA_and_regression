*Ejemplo 5.3 de Vilar.. 

En la tabla adjunta se presentan los tiempos, en minutos, de conexi�n con una direcci�n de internet desde cuatro puntos
geogr�ficos de una regi�n y en tres horas determinadas. El experimento se repet�a cuatro veces y era dise�ado para 
estudiar la influencia del factor �hora de conexi�n� y el factor �lugar de la conexi�n� en la variable de inter�s 
�tiempo de conexi�n�. Analizar estos datos y estudiar la influencia de los dos factores.;

data internet;
input lugar $  	hora  	tiempo	replica   ;
cards;
A             	1             	0.31          	1             
A             	1             	0.45          	2             
A             	1             	0.46          	3             
A             	1             	0.43          	4             
A             	2             	0.36          	1             
A             	2             	0.29          	2             
A             	2             	0.40          	3             
A             	2             	0.23          	4             
A             	3             	0.22          	1             
A             	3             	0.21          	2             
A             	3             	0.18          	3             
A             	3             	0.23          	4             
B             	1             	0.82          	1             
B             	1             	1.10          	2             
B             	1             	0.88          	3             
B             	1             	0.72          	4             
B             	2             	0.92          	1             
B             	2             	0.61          	2             
B             	2             	0.49          	3             
B             	2             	1.24          	4             
B             	3             	0.30          	1             
B             	3             	0.37          	2             
B             	3             	0.38          	3             
B             	3             	0.29          	4             
C             	1             	0.43          	1             
C             	1             	0.45          	2             
C             	1             	0.63          	3             
C             	1             	0.76          	4             
C             	2             	0.44          	1             
C             	2             	0.35          	2             
C             	2             	0.31          	3             
C             	2             	0.40          	4             
C             	3             	0.23          	1             
C             	3             	0.25          	2             
C             	3             	0.24          	3             
C             	3             	0.22          	4             
D             	1             	0.45          	1             
D             	1             	0.71          	2             
D             	1             	0.66          	3             
D             	1             	0.62          	4             
D             	2             	0.56          	1             
D             	2             	1.02          	2             
D             	2             	0.71          	3             
D             	2             	0.38          	4             
D             	3             	0.30          	1             
D             	3             	0.36          	2             
D             	3             	0.31          	3             
D             	3             	0.33          	4             
 

;
proc print;run;

** ---  ANOVA ---;
** La interaccion se especifica como si fuera un producto de los dos factores;
proc anova; 
class lugar	hora;
model tiempo = lugar hora lugar*hora;
run;

means  hora lugar hora*lugar; run;
** Los  p-valores obtenidos para cada uno de los contrastes son:
** Lugar: 0 -> Se rechaza la hipótesis Ho(alpha) a todos los niveles de confianza habituales. Podemos
** 			   afirmar que el lugar afecta al tiempo de conexión.
** Hora:  0 -> Se rechaza la hipótesis Ho(beta) a todos los niveles de confianza habituales. Podemos 
**			   afirmar que la hora afecta al tiempo de conexión.
** Hora*Lugar:  0'1123  -> Se acepta la hipótesis Ho(alpaha*beta) a los niveles de confianza 90% y 95%. 
**			   Podemos afirmar que no existe interacción entre los factore 'Hora' y 'Lugar'.;



** --- Gráficos de interacción ---;
** Para obtener el gráfico de interaccion cambiamos a GLM. Según el orden de los factores
 en la sentencia class se dibuja un gráfico u otro;
proc glm data=internet; 
class  lugar hora;
model tiempo =  hora lugar  hora*lugar;
means  hora lugar  hora*lugar; 
run;


proc glm data=internet;
class hora   lugar;
model tiempo =  hora lugar  hora*lugar;
means  hora lugar  hora*lugar;
output out=soluc P=predicho R=residuo;
proc print;run;



** --- Gráficos de residuos --- ;
proc sgplot data=soluc;
scatter Y=residuo X=predicho; 
run;

proc univariate plots normal  data=soluc;
var residuo;
qqplot;
run;
** Apreciamos heterocedasticidad y falta de normalidad. Probamos la transformacion logaritmica;



** --- Transformación logarítimica ---;
data nuevo;
set internet;
ltiempo= log(tiempo);
run;

proc glm data=nuevo;
class lugar hora;
model ltiempo =  hora lugar  hora*lugar;
means  hora lugar  hora*lugar;
output out=solucl P=predicho R=residuo;
run;

proc sgplot data=solucl;
scatter Y=residuo X=predicho; 
run;

proc univariate  plots normal  data=solucl;
var residuo;
run;
** Mejora la normalidad y homocedasticidad. Conclusiones similares sobre los factores y la interaccion
Graficos tambien similares;



** --- Comparaciones de medias ---;
proc glm data=nuevo ; 
class  lugar hora;
model ltiempo =  hora lugar  hora*lugar;
means  hora lugar  hora*lugar/tukey; 
run;

** Observamos que el tiempo de conexion es inferior en la hora "3", no habiendo diferencia
** significativa entre las otras  dos horas. En cuanto al lugar, en B y D los tiempos de conexion son 
** (significativamente)mayores que en A y C, como ya se apreciaba en los box-plot.;


** Podemos obtener I.C. para las medias, o sus diferencias, teniendo en cuenta que lo son para ltiempo;
means  hora lugar  /bon clm; run;
means  hora lugar  /tukey cldiff; run;

** ¿Es el tiempo medio en A y B similar al tiempo medio en C y D?;
estimate 'media A B - media C D' lugar 0.5 0.5 -0.5 -0.5;

estimate 'media A B - media C D' lugar 1 1 -1 -1 /divisor=2;*es equivalente, o tambien;

contrast 'media A B - media C D' lugar 1 1 -1 -1 ;run;

estimate 'media A C - media B D' lugar 1 -1 1 -1 /divisor=2;run;

