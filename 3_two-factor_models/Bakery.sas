
** -- Importación de los datos --;

data bakery;
infile '/folders/myfolders/Datos/Datos Kutner/Datos_Kutner/Chapter 19 Data Sets/CH19TA07.txt';
input ventas altura anchura;
run;

**1. ;

proc glm data=bakery;
class altura anchura;
model ventas = altura anchura altura*anchura;
output out=residuos p=pred r=res student=rst;
run; 


** Al observar la tabla ANOVA, vemos como se rechaza la influencia del factor
** 'anchura' a todos los niveles de confianza habituales, por lo que eliminamos 
** este factor;
proc glm data=bakery;
class altura;
model ventas = altura;
output out=residuos p=pred r=res student=rst;
run; 


** El modelo más adecuado parece el modelo de un factor donde se distingue
** 
**  - El factor tratamiento, T-alpha, que es la 'altura' de los estantes,
**	  con I = 3 niveles {1=baja ,2=media, 3=alta}.
**	- La variable respuesta, Y, que es el volumen de ventas de ppan.
**
** El modelo matemático del modelo de un factor es:
** 
** 		Y(i) = Mu + alpha(i) + e(i)
**
** donde 
** 
**	- Mu: es la media global de la población
**	- alpha(i): es el efecto diferencial respecto a la media global de i-ésimo nivel
**	  del factor T-alpha sobre la variable respuesta.
**	- e(i): la componente aleatoria del error, la parte de la variable respuesta
**		no explicada por Mu y alpha(i), es decir, el efecto de los factores extraños
** 		o no controlados;

** La unidad experimental es cada uno de los supermercados en los que se ha 
** medido la altura y la anchura de los estantes y su volumen de ventas de pan
;


**2);

** Para el contraste Ho(Alpha) se obtiene un p-valor <0.0001 por lo que la 
** hipótesis nula Ho(Alpha) se rechaza a los niveles de confianza habituales. 
** Existen evidencias para afirmar que existen diferenicas significativas 
** en las ventas de pan para las distintas alturas de los estantes;

** Para el contrste Ho(Beta) se obtiene un p-valor 0.3226, no rechazando
** la hipótesis Ho(Beta) a los niveles de confianza habituales. No existen 
** evidencias para afirmar que existen diferencias significativas 
** en las ventas de pan para las distintas anchuras de los estantes;

** Para el contrste Ho(Alpha-Beta9) se obtiene un p-valor 
** 0.3747, lo que hace no rehazar la hipótesis Ho(Alpha-Beta) a ninguno de los
** niveles de confianza habituales. En base a este p-valor podemos afirmar
** que no existe interacción significativa entre la anchura y la altura del 
** estante, aunque debemos tener en cuenta que el número de observaciones 
** es reducido, por lo que lo más adecuado será mantener la interacción en 
** el modelo;  

** 3);

proc glm data=bakery;
class altura anchura;
model ventas = altura anchura;
means altura;
means anchura;
run; 



**4) 5);

** -- Altura --;
proc glm data=bakery;
class altura anchura;
model ventas = altura anchura;
means altura/ bon tukey duncan;
run; 

** La altura 2 (media) da lugar a unas ventas de pan significativamente mayores
** que las alturas 1(baja) y 3(alta). Se obtienen más ventas de pan con la altura
** 2 (media).


** -- Anchura --;
means anchura/ bon tukey duncan;
run;

** No existen diferencias significativas entre las ventas de pan obtenidas con
** cada una de las dos anchuras. Aun así, se obtienen más ventas de pan con
** la anchura 2 (ancha).;



**6);

** Altura vs Anchura;
proc glm data=bakery;
class altura anchura;
model ventas = altura anchura anchura *altura;
run;

** La anchura 2 (ancha) da lugar a un nivel de ventas de pan mayor para las 
** alturas 2(media) y 3(alta), pero es la achura 1 (normal) la que da mayores
** ventas de pan con una altura 1 (baja);



** Anchura vs. Altura;
proc glm data=bakery;
class  anchura altura;
model ventas = altura anchura anchura *altura;
run; 

** La altura 2 (media) da lugar a ventas de pan claramente mayores, independientemente
** de la anchura. La altura 1 (baja) da lugar a más ventas cuando la anchura es
** noraml (anchura 1), miestra que es la altura 3 (alta) la que da lugar a más ventas
** cuando la anchura es ancha (anchura 2).;


**7);

proc glm data=bakery;
class anchura altura;
model ventas = altura anchura anchura*altura;
means altura/ dunnett('2');
run; 

** (Media - Baja) comprendida en [16.493, 29.507] al 95% de confianza.
** (Media - Alta) comprendida en [18.493, 31.507] al 95% de confianza.
**;




