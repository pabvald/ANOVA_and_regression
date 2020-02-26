*Modelo con 3 factores: Interesa estudiar la influencia que en la longitud de barras de acero 
producidas por distintas maquinas (A, B, C, D) tienen los tratamientos de calor (con niveles W y L)
asi com la hora del dia en que se fabrican (1: 8:00 AM, 2: 11:00 AM y 3: 3:00 PM). Importamos los datos
de steel-lenght.xls;

* ---- Importación de los datos -----;

proc import datafile='data/steel-lenght.xls'
   out=steel replace
   DBMS=xls;
   sheet="Sheet1";
   getnames=yes;
run;



* ---- Análisis de la varianza incluyendo todas las posibles interacciones ----;

proc anova data=steel; 
class heat time machine; 
model length=time heat time*heat machine time*machine heat*machine time*heat*machine; 
run;

** Se puede hacer otro ajuste del modelo prescindiendo del factor tiempo, de la triple interacción y 
** de las interacciones con tiempo. También podemos prescindir de la interacción heat*machine.



* ---- Modelo reducido, sin interacción y sin el factor tiempo ----;
** Probamos un modelo reducido, eliminando todos los efectos relacionados con el tiempo,
** cuya influencia no es significativa;

proc glm data=steel; 
class heat machine;
model length=heat machine; *heat*machine; 
output out=predichos p=predic r= resid; 
run;

** - El gráfico de interacción no es interpretable ya que se obtiene de un modelo en el que no 
** hemos incluido interacción. 
** - Var(Error) ha disminuido, ya que aunque ha aumentado la suma de cuadrados 
** del error, han aumentado los grados de libertad.;


proc glm data=steel; 
class machine heat;
model length=heat machine heat*machine; 
run;
** - Se aprecia que con el nivel W se producen barras mas largas, y las diferencias
** entre longitudes se mantienen para las diferentes maquinas. No hay interaccion;


** Para comparar las diferencias entre maquinas (y ver el otro grafico de interaccion);

proc glm data=steel; 
class heat machine;
model length= machine heat heat*machine; 
means machine/tukey; *CLDIFF; 
run;

** B y D no se distinguen y producen las barras mas largas, mientras C produce las mas cortas;
** Se puede comprobar que W da mayor longitud que L, las mejores combinaciones seran BW y DW, la peor CL.;

proc glm data=steel; 
class  machine heat;
model length= machine heat machine*heat; 
means heat machine*heat /t bon clm;*CLDIFF; 
run;


** Si quiero I.C. para los tratamientos, o para sus diferencias;
lsmeans  machine*heat /adjust=tukey CL;
run;

** Para que esta sentencia sea válida el efecto 'machine*heat' debe estar incluido en el modelo.
** 



* ---- Gráficos de residuos ----;
goptions reset= all;run;

proc sgplot data= predichos;
scatter Y=resid X=predic; 
run;


proc univariate normal data= predichos;
var resid;
qqplot;
run;


* ---- GRAFICOS DE INTERACCION PARA TRES FACTORES ----;
 
/* -- ANALISIS GRAFICO DE LA INTERACCION ENTRE TIME Y HEAT. --*/;
proc sort data=STEEL;
by Time heat;
run;
proc print ;run;


proc means data=STEEL;
var length;
by Time heat;
output out=graf mean=media;
run;


proc gplot data=graf;
symbol interpol= join;
plot media*time=heat;run;
plot media*heat=time;run;


/*-- ANALISIS GRAFICO DE LA INTERACCION  ENTRE time y machine. --*/;

** Los datos deben estar ordenados;
proc sort data=steel;
by time  machine;
run;
proc print ;run;

** Debemos calcular las medias de la variable 'length' en base a los niveles 
** de los factores 'time' y 'machine' para calcular los gráficos de interacción
** a mano;
proc means;
var length;
by time machine;
output out=graf mean=media;run;

** Realizamos el gráfico de interacción a mano;
proc plot data=graf;
plot media*time=machine;
plot media*machine=time;run;

** Se apreciaria algo de interaccion en este caso, pero hay que tener en cuenta que time no tiene
** efecto significativo en la respuesta;



/* -- ANALISIS GRAFICO DE LA INTERACCION  ENTRE heat y machine. --*/;
proc sort data=steel;
by heat machine;
run;
proc print ;run;

proc means;
var length;
by heat machine;
output out=graf mean=media;run;

proc gplot data=graf;
symbol interpol= join;
plot media*heat=machine;run;


proc gplot data=graf;
plot media*machine=heat;run;



*comparamos el ajuste con y sin interaccion;
proc glm data=steel; 
class  machine heat;
model length= machine heat machine*heat; 
means machine heat/tukey CLDIFF; run;
*el F-value de la interaccion es muy peque�o;


proc glm data=steel; class  machine heat;
model length= machine heat; 
means machine heat/tukey CLDIFF; run;
*baja el error cuadratico medio, estimador de la varianza, y el Rcuadrado es casi igual.
Los I.C. resultan algo mas estrechos en el segundo caso. Sin embargo, no podriamos obtener I.C.
para los tratamientos o sus diferencias con "lsmeans  machine*heat /adjust=tukey CL", 
pues el efecto a estimar tiene que aparecer en el modelo;

*...................................................................................................;

** Si quiero un I.C. para la diferencia de longitud  media segun heat, que opcion me interesa,
con o sin interaccion, dos factores o uno??;

proc glm data=steel;
class  machine heat;*class  heat  machine;
model length= machine heat machine*heat; 
means heat/ t CLDIFF; 
run;


*si quito la interaccion;
proc glm; class  machine heat;
model length= machine heat; 
means heat/ t CLDIFF; 
run;*se reducen minimamente;


*si quito el factor machine;
proc glm; class  heat;
model length=  heat; 
means heat/ t CLDIFF;
run;*aumenta la amplitud, NO INTERESA;
