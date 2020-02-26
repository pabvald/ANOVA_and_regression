
** --- Importación de los datos ---;
data trifact; 
input Ciudad Establecimiento Cesta coste @@;
cards;
1 1 1 104 1 1 1 105 1 1 1 100 1 1 2 121 1 1 2 121 1 1 2 110
1 2 1 112 1 2 1 121 1 2 1 124 1 2 2 116 1 2 2 124 1 2 2 129 
2 1 1 102 2 1 1 110 2 1 1 111 2 1 2 132 2 1 2 130 2 1 2 129
2 2 1 125 2 2 1 128 2 2 1 129 2 2 2 126 2 2 2 132 2 2 2 132
3 1 1 109 3 1 1 115 3 1 1 107 3 1 2 142 3 1 2 152 3 1 2 138
3 2 1 127 3 2 1 125 3 2 1 126 3 2 2 146 3 2 2 142 3 2 2 136
4 1 1 111 4 1 1 116 4 1 1 127 4 1 2 156 4 1 2 164 4 1 2 168
4 2 1 127 4 2 1 144 4 2 1 132 4 2 2 134 4 2 2 152 4 2 2 145
5 1 1 110 5 1 1 117 5 1 1 106 5 1 2 145 5 1 2 163 5 1 2 136
5 2 1 126 5 2 1 122 5 2 1 127 5 2 2 130 5 2 2 124 5 2 2 136
;

proc format;
value Ciudad 1= 'Ciudad A' 2='Ciudad B' 3='Ciudad C' 4='Ciudad D' 5='Ciudad E';
value Establecimiento 1 = 'Nacional' 2 = 'Local';
value Cesta 1 = 'Cesta 1' 2 = 'Cesta 2';
run;

data factorial;
set trifact;
format Ciudad Ciudad. 
Establecimiento Establecimiento. Cesta Cesta.;
proc print data=factorial;
run;


** 1.-Describe el modelo adecuado para el estudio e identifica la variable respuesta, los factores y las unidades experimentales.;

** + Modelo : modelo completo de 3 vías.
**
** + Variable respuesta, Y: coste de la compra respecto a la más barata.
**
** + Factores:
**		- alpha -> Ciudad (Ciudad A, Ciudad B, Ciudad C, Ciudad D o Ciudad E): variable categórica nominal. I = 5
**		- beta  -> Establecimiento (Nacional, Local): variable categórica nominal.	J = 2
**		- gamma -> Cesta (Cesta 1, Cesta 2): variable categórica nominal.	R = 2
**
** Dado que se realizan 3 observaciones en cada uno de los dos supermercados de cada ciudad, podemos concluir que K = 3;
**
** + Unidades experimentales: cada una de las compras realizadas.;

*------------------------------------------------------------------------------------------------------------------------------------*;




**2.- Indica cuáles son los efectos significativos y elabora un nuevo modelo de acuerdo con las conclusiones del ANOVA.;

** Realizamos un ANOVA incluyendo las interacciones de segundo orden y de tercer orden;
proc anova data=factorial;
class Ciudad Establecimiento Cesta;
model coste = Ciudad Establecimiento Cesta Ciudad*Establecimiento Ciudad*Cesta Establecimiento*Cesta Ciudad*Establecimiento*Cesta;
run;


** Teniendo en cuenta los p-valores obtenidos, podemos afirmar que existen evidencias para afirmar que los tres factores tratamiento
** Ciudad, Establecimiento y Cesta afectan significatiamente al coste de la compra. De igual manera, existen evidencias para afirmar 
** que existe interacción entre los factores Ciudad y Establecimiento, Ciudad y Cesta, y Cesta y Establecimiento.
** Tal vez, podemos considerar que la interacción de tercer orden es nula, ya que para dicha interacción se obtiene un p-valor del 0.1126.
** Realizamos de nuevoe el ANOVA sin incluir la interacción de tercer :;

proc anova data=factorial;
class Ciudad Establecimiento Cesta;
model coste = Ciudad Establecimiento Cesta Ciudad*Establecimiento Ciudad*Cesta Establecimiento*Cesta;
run;

** Vemos como al eliminar la interacción de tercer orden, aumenta la varianza del error de forma considerable, de 39.7 a a 43.6,
** por lo que mantendremos esta interacción en el modelo. El modelo que utilizaremos continúa siendo, por tanto, un modelo completo 
** de 3 vías.;

*--------------------------------------------------------------------------------------------------------------------------------------*;



**3.- Estudia si existe una ciudad significativamente más barata que el resto.;

proc glm data=factorial;
class Ciudad Establecimiento Cesta;
model coste = Ciudad Establecimiento Cesta Ciudad*Establecimiento Ciudad*Cesta Establecimiento*Cesta  Ciudad*Establecimiento*Cesta;
means Ciudad/LSD TUKEY BON DUNCAN ;
means Ciudad/LSD TUKEY BON DUNCAN alpha=0.10;
means Ciudad/ Dunnett('Ciudad A');
means Ciudad/ Dunnett('Ciudad A') alpha=0.10; 
run;

** Sí, la Ciudad A es significativamente más barata que el resto de ciudades a los niveles de confianza habituales;*

*--------------------------------------------------------------------------------------------------------------------------------------*;


**4.- ¿Qué clase de establecimiento presenta mejores precios?;
proc glm data=factorial;
class Ciudad Establecimiento Cesta;
model coste = Ciudad Establecimiento Cesta Ciudad*Establecimiento Ciudad*Cesta Establecimiento*Cesta  Ciudad*Establecimiento*Cesta;
means Establecimiento/LSD TUKEY BON DUNCAN ;
means Establecimiento/LSD TUKEY BON DUNCAN alpha=0.10;
run;

** Los establecimientos de ámbito Nacional tienen precios significativamente mejores (más bajos) a los niveles de confianza 
** habituales.

*--------------------------------------------------------------------------------------------------------------------------------------*;


** 5.- ¿Qué cesta es más barata?;
proc glm data=factorial;
class Ciudad Establecimiento Cesta;
model coste = Ciudad Establecimiento Cesta Ciudad*Establecimiento Ciudad*Cesta Establecimiento*Cesta  Ciudad*Establecimiento*Cesta;
means Cesta/LSD TUKEY BON DUNCAN ;
means Cesta/LSD TUKEY BON DUNCAN alpha=0.10;
run;

** La Cesta 1 es sifnificativamente más barata (tiene un precio más bajo) a los niveles de confianza habituales.

*--------------------------------------------------------------------------------------------------------------------------------------*;


**6.- Analiza gráficamente las interacciones significativas entre pares de factores.;

** --- Interacción Ciudad*Cesta ---;

proc glm data=factorial;
class Ciudad Cesta;
model coste = Ciudad Cesta Ciudad*Cesta ;
run;

proc glm data=factorial;
class Cesta Ciudad;
model coste = Ciudad Cesta Ciudad*Cesta ;
run;


** Independientemente de la Ciudad, la Cesta 2 tiene precios más elevados que la Cesta 1. Para el tipo de Cesta, mientras 
** que para la Cesta 2 las diferencias entre las ciudades son claras, para la Cesta 1 las diferencias entre las Ciudades
** B, C y E pasan a ser nulas; 


** -- Interacción Ciudad*Establecimiento ---;
proc glm data=factorial;
class Ciudad Establecimiento;
model coste = Ciudad Establecimiento Ciudad*Establecimiento ;
run;

proc glm data=factorial;
class Establecimiento Ciudad;
model coste = Ciudad Establecimiento Ciudad*Establecimiento ;
run;

** En las Ciudades A, B y C, los establecimientos de tipo Local tienen un precio claramente mayor, mientras que para las 
** Ciudades D y E, los establecimientos de tipo Local tienen un precio levemente menor. El hecho de que un tipo de 
** establecimiento sea más caro o más barato se ve afectado por la ciudad;

** -- Interacción Cesta*Establecimiento --;
proc glm data=factorial;
class Cesta Establecimiento;
model coste = Cesta Establecimiento Cesta*Establecimiento ;
run;

proc glm data=factorial;
class Establecimiento Cesta;
model coste = Cesta Establecimiento Cesta*Establecimiento ;
run;


** Independientemente del tipo de Establecimiento, la Cesta 2 tiene un precio mayor que la Cesta 1, pero, dependiendo 
** del tipo de Cesta, el establecimiento Local es más caro (Cesta 1) o más barato (Cesta 2) que el establecimiento Nacional;



*--------------------------------------------------------------------------------------------------------------------------------------*;

** 7.- Analiza gráficamente los residuos del modelo.;
proc glm data=factorial;
class Ciudad Establecimiento Cesta;
model coste = Ciudad Establecimiento Cesta Ciudad*Establecimiento Ciudad*Cesta Establecimiento*Cesta  Ciudad*Establecimiento*Cesta;
output out=residuos p=pred r=res student=rst;
run;

** -- Normalidad de los errores --;
proc univariate plot normal data=residuos;
var rst;
run;
** Podemos asumir la hipótesis de Normalidad de los errores a los niveles de confianza habituales;


** -- Homegeneidad de la muestra y Homocedasticidad de los errores --;
proc sgplot data=residuos;
scatter y=res x=pred;
run;

proc sgplot data=residuos;
scatter y=rst x=pred;
run;

** Podemos asumir la hipótesis de homocedasticidad de los errores y de homogeneidad de la muestra;

*--------------------------------------------------------------------------------------------------------------------------------------*;



** 8.- Construye un intervalo de confianza  para la diferencia de precios según el tipo de establecimiento.;
proc glm data=factorial;
class Ciudad Establecimiento Cesta;
model coste = Ciudad Establecimiento Cesta Ciudad*Establecimiento Ciudad*Cesta Establecimiento*Cesta  Ciudad*Establecimiento*Cesta;
means Establecimiento/BON CLDIFF;
RUN; 
*--------------------------------------------------------------------------------------------------------------------------------------*;


** 9.- Construye  intervalos de confianza simultáneos  para las diferencias de precios entre ciudades.;
proc glm data=factorial;
class Ciudad Establecimiento Cesta;
model coste = Ciudad Establecimiento Cesta Ciudad*Establecimiento Ciudad*Cesta Establecimiento*Cesta  Ciudad*Establecimiento*Cesta;
means Ciudad/TUKEY CLDIFF;
RUN;

*--------------------------------------------------------------------------------------------------------------------------------------*;


** 10.- Construye los mismos intervalos a partir del modelo con un solo factor (ciudad) y compara los resultados con los del apartado anterior.;
proc glm data=factorial;
class Ciudad;
model coste = Ciudad;
means Ciudad/BON CLDIFF;
RUN;

** Los intervalos de confianza obtenidos tiene una amplitud mucho mayor, siendo más difícil que exista una diferencia significativa entre 
** dos ciudades. 
*--------------------------------------------------------------------------------------------------------------------------------------*;