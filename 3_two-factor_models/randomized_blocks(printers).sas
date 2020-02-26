* Una empresa fotográfica tiene que realizar una compra de impresoras.
* La empresa tiene ofertas de I = 5 marcas de impresosras similares.
* Para la empresa, es muy importante la velocidad de impresión y, por 
* este motivo, está interesada en saber si las 5 impresoras ofertadas tienen
* la misma velocidad de impresión o hay una que es más rápida. Para responder 
* a esta pregunta deciden hacer un experimento que consiste en elegir una única 
* muestra de J = 4 fotos e imprimirlas en las 5 impresoras. Los resultados
* del experimento son:
;

data impresoras;
input foto $ impresora tiempo;
datalines;
a 1 89
a 2 84
a 3 81
a 4 87
a 5 79
b 1 88
b 2 77
b 3 87
b 4 92
b 5 81
c 1 97
c 2 92
c 3 87
c 4 89
c 5 80
d 1 94
d 2 79
d 3 85
d 4 84
d 5 88
;
proc print; run;

* Planteamos los contrastes del modelo
** El primer contraste permitirá determinar la influencia del factor tratamiento 'impresora':
**		Ho: alpha1 = alpha2 = alpha3 = alpha4 = alpha5 = 0 (la impresora no influye en el tiempo de impresión)
**		H1: el factor tratamiento 'impresora' sí influye en la variable respuesta 'tiempo'
**
** El segundo contraste nos permitirá determinar la influencia del factor bloque 'foto':
**		Ho: beta1 = beta2 = beta3 = beta4 = 0 (la foto no influye en el tiempo de impresión)
**		H1: el factor bloque 'foto' sí influye en la variable respuesta 'tiempo'
**;


*Para calcular las medias utilizamos el procedimiento 'means';
proc means;
var tiempo;
class impresora;
run;

proc means;
var tiempo;
class foto;
run;


* Representamos la variable respuesta 'tiempo de impresión' frente al factor tratamiento 'impresora';
proc sgplot;
scatter y=tiempo x=impresora; 
run;
** Se aprecian menores tiempos para la impresora 2, pero tambien tiempos similares en otras;



* Realizamos el análisis de la varianza del modelo;
proc anova data=impresoras ;
class foto impresora; 
model tiempo= foto impresora; 
run;

** Con los resultados obtenidos:
** 1- Habiendo obtenido un p-valor de 0'0407, rechazamos la hipótesis nula Ho(alpha) a los niveles de confianza 
** 	  habituales. El factor tratamiento 'impresora' influye en la variable respuesta 'tiempo'.
** 2- Habiendo obtenido un p-valor de 0'3387, aceptamos la hipótesis nula Ho(beta) a los niveles de 
**	  confianza habituales. El factor bloque 'foto' no influye en la variable respuesta 'tiempo'. Por lo tanto,
**	  no era necesario el bloqueo.
**;




*Para obtener mas informacion sobre diferencias entre impresoras;
means impresora /lsd duncan snk tukey bon alpha=0.1; 
run;

** Las conclusiones del libro son las de duncan o LSD, las mejores serían las impresoras 5, 2 y 3,
** pero Tukey detecta solo dos grupos, solo se diferencian claramente la 5 y la 2 de la 1,
** (y a nivel 0.05 solo se distinguen la 5 y la 1);


* I.C. simultaneos para diferencias de medias;
means impresora/ tukey cldiff alpha=0.1;
run;



* Hipótesis del modelo;
** Comprobamos que se cumplen las hipótesis del modelo (normalidad el error, homocedasticidad, 
** bondad del ajuste, independencia de los residuos, homegeneidad de los datos) incluyendo la 
** comprobación de que no existe interacción entre el factor tratamiento 'impresora' y el 
** facto bloque 'foto';


proc glm data=impresoras ;
class foto impresora; 
model tiempo = foto impresora;
output out=soluc P=predicho R=residuo;
proc print;
run;



** Independencia de los residuos;
data a;
set soluc;
num =_n_;
run;
proc sgplot data=a;
scatter y=residuo x=num;
run;
** Observando el gráfico de residuos frente a observaciones, podemos aceptar la hipótesis de 
** independencia de los residuos;



** Normalidad de los residuso;
proc univariate normal  plot data=soluc;
var residuo;
qqplot;
run;
** Aceptamos la hipóteis de normalidad de los residuos a todos los niveles de confianza
** habituales;


** No interacción entre los factores;
goptions reset=all;
proc sgplot data=soluc;
scatter Y=residuo X=predicho; 
run;
** Observando el gráfico de residuos frente a predichos, podemos ver cómo no se aprecia 
** ninguna forma parabólica, lo que indica que no existe interacción entre el factor 
** tratamiento 'foto' y el factor bloque 'foto';







* Eliminamos el bloqueo;
** Dado que la hipótesis Ho(beta) no es rechazada a los niveles de confianza habituales, 
** concluimos que el bloqueo no es adecuado y lo eliminamos para obtener una prueba de 
** hipótesis más potente sobre la influencia del factor tratamiento 'impresora'. Al eliminar
** el bloqueo, obtendremos además I.C. de menor amplitud;

proc anova data=impresoras ;
class  impresora; 
model tiempo=impresora;
*means impresora/hovtest;  
run; 

** Se obtiene un p-valor = 0,038, por lo que seguimos rechazando la hipótesis nula Ho(alpha) a 
** los niveles de confianza habituales. Este p-valor es menor que el obtenido con el bloqueo,
** es decir, podemos afirmar que el factor tratamiento 'impresora' influye en la variable
** respuesta 'tiempo' con mayor seguridad.




*Para obtener mas informacion sobre diferencias entre impresoras;
means impresora /lsd duncan snk tukey bon alpha=0.1; 
run;


means impresora/ tukey cldiff alpha=0.1;
run;
** Las conclusiones son similares, y los I.C.simultáneos para diferencias de medias
** también. Vemos como los I.C. son ligeramente menos amplios. Aumentan el ECM y los G.L.;
