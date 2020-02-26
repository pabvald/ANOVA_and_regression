
*
* SE TRATA DE VER SI EL TIPO DE EMPAQUETADO INFLUYE EN LAS VENTAS DE CIERTOS CEREALES (Y).
* Se eligieron inicialmente 20 tiendas, de similares caracteristicas, como uds. experimentales,
* asignando al azar cada tipo de empaquetado a cinco de ellas, pero una se incendi� durante el estudio.
* Se procuro que las condiciones de venta fueran similares en todos los casos
*;


* Importamos los datos ;
data kenton;
infile 'data/CH16TA01.txt';
input y package store;
proc print; run;

* Diagrama de puntos - Tratamos de determinar si existe una correlación clara entre el tipo de paquete y el número de ventas;
proc sgplot;
scatter y=y x=package;
scatter Y=y x=store;
run;

* Diagrama de caja - Para realizar el diagram de caja, el dataset debe estar ordenado según el factor (package);
proc sort data=kenton;
by package;
run;

proc boxplot;
plot y*package;
run;

* Tabla ANOVA;
proc anova;
class package;
model y=package;
means package;
run;
* El p-valor es <0.0001, por lo que la hipótesis nula se rechazará a cualquier nivel;



* Tabla ANOVA con varianzas ponderadas;
proc anova;
class package;
model y=package;
means package/hovtest;*HOVTEST=BARTLETT ;*WELCH, realiza un anova con varianzas ponderadas;
run;


* Analisis de  Residuos;
* Los residuos del modelo son las diferencias para cada observacion entre el valor observado y el valor estimado;
* Para guardar los residuos debemos usar el procedimiento proc glm, ya que proc anova no permite guardarlos;
proc glm data =kenton;
class package;
model y=package;

* Queremos guardar en un dataset llamado 'resal' tres valores: los valores predichos, los residuos y los residuos studentizados (normalizados).;
output out= resal p=pred r=res student=rst; 
proc print data=resal;run;


* Representamos los residuos graficamente;
proc sgplot data=resal;
scatter y=res x=pred;
scatter y=rst x=pred;
run;



* Analisis de normalidad de los residuos.;
proc univariate plot normal data=resal;
var res;
qqplot;probplot;run;


*para detectar dependencia entre observaciones consecutivas;
data a;
set resal;
num=_n_;
run;
proc sgplot;
scatter  y=y x=num;
scatter  y=rst x=num;
run;quit;



*PARA obtener INTERVALOS de cofianza para las medias podemos construir estos intervalos INDIVIDUALES  DE LA T (LSD) o simultaneos con BON;
proc anova data=kenton;
class package;
model y=package;
* Ventas medias para cada tipo de empaquetado. Ponemos la palabra CLM para que se calculen los intervalos de confianza para las media;
* Los intervalos de confianza para las medias se pueden calcular mediante el procedimiento de la T-Student y el de Bon Ferroni.;
means package/T BON CLM ;*alpha=0.0125 ;run;


/*data a;
z1=tinv(.975,15);  *Calcular el percentil 0,975 de la distribución T de Sudent con 15 grados de libertad;
z=tinv(.99375,15); 
proc print;run;*/

means package/ LSD CLDIFF;
means package/ LSD;

*I. C. para Diferencias DE MEDIAS;
means package/t cldiff;run; * La t indica que se utiliza la T-Student. cldiff indica que se desean I.C. para la diferencia de medias. Utilizar alpa=0.05;

means package/ LSD TUKEY BON SCHEFFE; *  CLDIFF ;*(por defecto con TUKEY, incompatible con DUNCAN) ALPHA=0.01 */;run;

means package/ DUNNETT ('2'); *El método de Dunnet es un método específico de comparación de medias cuando lo que se quiere es comparar todas las medias con un control.
							  * Imaginemos un tratamiento tradicional y 3 tratamientos nuevos; interesa comparar cada uno d los nuevos con el tradicional. El número de 
							  * comparaciones es el número de factores menos 1. Si no se pone nada se utiliza el primer tratamiento como control, en este caso el 2;
run;

* Comparacion de medias;
means package/  DUNCAN SNK; 		
run;

means package/  LSD DUNCAN SNK TUKEY BON SCHEFFE LINES alpha=0.02;run; * LINES: ordena las medias de menor a mayor uniendo las que 
																	   * no son significativamente diferentes, 
					    											   * opcion por defecto con  DUNCAN, incompatible con DUNNETT;



* CONTRASTES;
proc glm data =kenton;
class package;
model y=package/solution clparm;   * Se obtiene I.C. para el contraste pedido;
								   * con CLM se obtienen I.C. para las medias como predichos, 
								   * y con SOLUTION CLPARM para los parametros;

* Comparar los tipos de empaquetados.  L = (u1 + u2)/2  - (u3 + u4)/2 = 0;
contrast '3colores contra 5colores' package .5 .5 -.5 -.5;    * contrast - Permite contrastar hipótesis de una forma particular;
estimate '3colores contra 5colores2' package .5 .5 -.5 -.5;    * estimate - Incluye a la de contrast, ya que también estima L;
* o bien;
contrast '3colores contra 5colores' package 1 1 -1 -1;
estimate '3colores contra 5colores' package 1 1 -1 -1 /DIVISOR=2;
run;



