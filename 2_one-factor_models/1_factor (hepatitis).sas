* 
* SE TRATA DE VER si hay diferencias entre 5 medicamentos para la hepatitis. 
*;

* A = 4 observaciones, B = 2 observaciones, C = 2 observaciones, D = 3 observaciones, E = 1 observación;

data hepatitis;
input medicamento $ tiempo;
cards;
A 8.3
A 7.6
A 8.4
A 8.3
B 7.4
B 7.1
C 8.1
C 6.4
D 7.9
D 9.5
D 10.0
E 7.1
;
proc print; run;

* Diagrama de puntos - Elaboramos un diagrama de puntos para ver si existe una correlación entre el tipo de medicamento y el tiempo de tratamiento;
proc sgplot data=hepatitis;
scatter x=medicamento y=tiempo;
run;


* Diagrama de caja - en este caso no tiene mucho sentido dado el escaso numero de muestras;
proc boxplot;
plot tiempo *medicamento;
run;





* El contraste que se plantea es el siguiente:
* 	Ho = las medias de A, B, C, D y E son iguales.;
* 	H1 = hay alguna media distinta;


* Tabla ANOVA ;
proc anova;
class medicamento;
model tiempo = medicamento;   * model dependiente = efecto;
run;


* Junto con la tabla ANOVA aparecen la siguiente informacion: 
*  1. R-cuadrado:  Determina que proporcion de la variabilidad esta explicada por el modelo. Siempre toma valores entre 0 y 1.
*  2. Coeficiente de variacion: se define a partir de la Raiz del MSE (Media de Cuadrados del Error) y el tiempo medio. Es una medida de dispersion 
*     relativa, adimensional,que permite comparar dispersiones entre distintas muestras aunque esten expresadas en distintas unidades.;



* Valor critico a nivel 0.05;
* La funcion Finv(0.95, 4, 7) nos da el percentil 95 de la distribucion F(4, 7). 
data a;
f=Finv(0.95, 4, 7);
proc print;
run;

* Dado que  Finv(0.95, 4, 7) es 4,12 , el cual es mayor 
* que el valor Fo = 2,85 obtenido, no podemos descartar la hipotesis nula Ho, es decir, no podemos rechazar que el tipo de
* medicamento no influye en el tiempo de tratamiento;


*Calculo del p-valor (en el caso de que no lo hayamos obtenido mediante la tabla ANOVA);
data b;
p=1-probf(2.85,4,7);
proc print; 
run;


