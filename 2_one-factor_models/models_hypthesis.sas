* Los siguientes datos son recuentos de pulgones del trigo en 6 semanas 
* diferentes. En cada ocasión se eligieron cuarenta plantas aleatoriamente,
* y se contaron los insectos en cada una. Se trata de analizar si existen 
* diferencias en el número de pulgones por planta entre las diferentes semanas.;


* Importar los datos;

data pulgones;
do semana=1 to 6;
 do repet=1 to 40;
    input recuento @@;
    output;
 end;
end;
datalines;
12 1 6 1 5 7 1 1 2 1 20 0 9 7 0 12 2 0 0 2 8 0 11 2 21 0 3 18 2 2 6 6
5 1 12 0 3 1 1 18 40 16 32 15 44 41 43 53 67 21 6 31 15 11 21 40 15 50
17 32 24 7 25 11 64 22 50 27 3 46 45 10 8 27 34 19 86 83 17 36 86 63
20 68 55 42 24 29 20 27 26 63 40 46 7 15 10 30 46 26 15 42 6 28 7 9 5
35 6 9 108 38 35 64 21 20 62 25 0 0 29 2 3 0 4 2 6 7 5 4 6 0 0 5 1 3 2
2 2 5 0 1 1 0 3 1 2 0 3 3 18 7 21 0 0 0 2 3 0 40 5 7 0 0 0 1 1 2 1 0
25 1 0 0 0 0 0 0 0 5 0 2 0 0 0 2 0 0 0 4 0 0 0 0 2 0 0 0 0 2 1 0 0 1 7
0 0 0 4 1 5 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
;




* 1 - ¿Es adecuado utilizar un modelo de un factor para ello? Haz un análisis
* descriptivo de los datos por semanas y valora las hipótesis que se asumen
* en el modelo.;

proc univariate plot normal data=pulgones;
by semana;
var recuento;
run;


* Para valorar si se cumplen las hipótesis del modelo debemos obtener los residuos;
* Obtenemos las predicciones (pred), los residuos (res) y los residuos estandarizados (rst);

proc glm data=pulgones;
class semana;
model recuento=semana;
output out=resal p=pred r=res student=rst;
run;


* Hipótesis de normalidad de los residuos;
proc univariate plot normal data=resal;
var res;
run;
** Dado que los p-valores de los diferentes tests de normalidad son muy bajos, podemos 
** rechazar que los residuos siguen una distribución normal a los niveles de 
** confianza habituales;


* Independencia de los residuos;
** Representamos los residuos frente a las predicciones para ver si existe o no 
** independencia entre los residuos;
proc sgplot data=resal;
scatter y=res x=pred;
run;

** Representamos ahora los residuos frente al número de observación;
data a;
set resal;
num=_n_;
run;

proc sgplot data=a;
scatter y=rst x=num;
run;

** Comprobamos que la hipótesis de independencia de las observaciones sí que se verifica;

* Bondad del ajuste;

** Representamos los residuos estandarizados frente a los niveles del factor;
proc sgplot data=resal;
scatter y=rst x=semana;
run;
** Observamos como en las semanas 2 y 3 los residuos son exageradamente positivos, lo que es un 
** síntoma de falta de ajuste;



* Homocedasticidad del error;
** Para comprobar la homocedasticidad del error, realizamos un análisis estadístico de los 
** errores en base a los niveles del factor;
proc univariate data=resal;
var res;
by semana;
run;

**Las varainzas son:
**  - Semana 1 -> 35.9224359
** 	- Semana 2 -> 411.002564
**  - Semana 3 -> 599.074359
**  - Semana 4 -> 67.6352564
**  - Semana 5 -> 17.2820513
** Comprobamos que las varianzas de los residuos para los distintos niveles de tratamiento del 
** factor son muy distintas, por lo que no hay homocedasticidad. Además, dado que la razón 
** entre la mayor y la menor varianzas es mayor que 3, esta heterocedasticidad afectará al test F;






*2.- Realiza el contraste de igualdad de medias y analiza los residuos.
* ¿Qué conclusiones sacas?;

proc anova data=pulgones;
class semana;
model recuento=semana;
means semana;
run;

** Dado que el p-valor obtenido es <0,0001, podemos rechazar la hipótesis nula Ho a los 
** niveles de confianza habituales, es decir, podemos afirmar que en las diferentes 
** semanas el número de pulgones es distinto a los niveles de confianza habituales;






*3.- Realiza el test de Levene. ¿Te sorprende el resultado?;

means semana/hovtest;
run;

** El test de Leeven proporciona un p-valor = <0,001, es decir, podemos rechazar que las 
** varianzas de los errores sean iguales para los distintos niveles de tratamiento del 
** factor. Esto coincide con el análisis realizado en la pregunta 1 al calcular las 
** varianzas de los residuos por los niveles del factor;



* 4.- Transforma la respuesta mediante log(recuento+1) 
* y repite el apartado 2. ¿Qué cambios observas?;

** Transformación de los datos;
data pulglog;
set pulgones;
logrec=log(recuento+1);
title 'Datos transformados';

** Calculamos los valores predichos, los residuos y los residuos estandarizados;
proc glm data=pulglog;
class semana;
model logrec=semana;
output out=resal_transformed p=pred r=res student=rst;
run;


proc univariate plot normal data=resal_transformed;
var res;
run;

** Al calcular la tabla ANOVA se obtiene de nuevo un p-valor = <0,0001, por lo que 
** se sigue rechazando la hipótesis nula Ho;

proc sgplot data=resal_transformed;
scatter y=res x=pred;
run;

proc sgplot data=b;
scatter y=rst x=semana;
run;


data b;
set resal_transformed;
num=_n_;
run;

proc sgplot data=b;
scatter y=rst x=num;
run;


proc anova data=resal_transformed;
class semana;
model recuento=semana;
means semana/hovtest;
run;

** En lo que se refiere a las hipótesis del modelo podemos ver que 
** - Normalidad de los errores: sigue sin verificarse, aunque la distribución de los 
**   residuos se acerca más a una distribución normal.
** - Independencia de las observaciones: se continúa verificando.
** - Homocedasticidad: se sigue sin verificar.
** - Bondad del ajuste: ahora los residuos estandarizados no tienen valores extremos. 
**	 Podemos considerar que el modelo se ajusta mejor ahora.;





*5.- Repite el apartado anterior utilizando sólo los datos de 
* las cuatro primeras semanas.;

data cuatrosem;
set pulglog;
where semana < 5;
run;
title 'Datos transformados 4 primeras semanas';


proc glm data=cuatrosem;
class semana;
model logrec=semana;
means semana/hovtest;
output out=f p=pred r=resid student=rst; 
run;



* 6-. Realiza el test de kruskal-Wallis sobre los datos originales para
* contrastar la igualdad de medias.;

proc npar1way data=pulgones;
class semana;
run;


