* ---------------------- Ejercicio 1 ---------------------------;

* Crea un fichero de datos llamado Poblacion y añade los siguientes casos;

DATA Poblacion;
FORMAT Provincia $ 12.;
INPUT Provincia $ Poblacion ;
CARDS;
Ávila, 168638
Burgos, 365972
León, 497387
Palencia, 173281
Salamanca, 351326
Segovia, 159322
Soria, 93593
;
RUN;

* Imprimir los datos;
PROC PRINT;
RUN;

* ---------------------- Ejercicio 2 -------------------------;


* Añade al fichero Poblacion la superficie de cada provincia creando el fichero 
* PoblacionSup ;


* Creamos un fichero de datos con los valores de la superficie de cada provincia;
DATA Superficie;
INPUT Provincia $ Superficie;
CARDS;
Ávila, 8048
Burgos, 14269
León, 15468
Palencia, 8029
Salamanca, 12336
Segovia, 6949
Soria, 10287
;
RUN;


* Creamos el fichero PoblacionSup combinando el fichero Poblacion y el fichero Superficie
* Para ello utilizamos la sentencia MERGE;
DATA PoblacionSup;
MERGE Poblacion Superficie;
RUN;

PROC PRINT;
RUN;


*------------------------ Ejercicio 3 ------------------------------;

* Añadir las provincias de Valladolid y Zamora con sus correspondientes valores para las
* variables Poblacion y Superficie, creando un nuevo fichero llamado Completo ;

DATA PoblacionExtra;
INPUT Provincia $ Poblacion Superficie;
cards;
Valladolid 521661 8202
Zamora 197237 10559
;
run;

* Creamos un fichero llamado Completo con los mismos datos que el fichero PoblacionSup; 
data Completo;
set PoblacionSup;
run;

* Añadimos los casos de Valladolid y Zamora utilizando la proceso append;
proc append base=Completo data=PoblacionExtra;
run;

proc print;
run;

* Guardamos el fichero Completo en el fichero externo Completo.txt ;
data Auxiliar;
set Completo;
file './Completo.txt';
put Provincia $ 1-12 Poblacion 12-20 Superficie 20-30;
run;


*---------------------- Ejercicio 4 ------------------------------;

* Incluir la variable Densidad = Poblacion / Superficie;
data CompletoDen;
set Completo;
Densidad=Poblacion/Superficie;
proc print;
run;


*---------------------- Ejercicio 5 ---------------------*;

* Ordenar las provincias según su densidad de población, y guardar el fichero
* Ordenado en una librería que tú hayas creado;
libname Mylib2 '/folders/myfolders/Practicas/Practica0';
data Mylib2.Ordenado;
set CompletoDen;
run;

proc sort;
by Densidad;
proc print;
run;


*---------------------- Ejercicio 6 ---------------------*;

* Crear la variable tamaño que contenga la palabra grande si un provincia
* tiene más de 10.000 km2  y pequeño si no y guárdalo temporalmente como clasificado.;

data Clasificado;
set CompletoDen;
if Superficie > 10000 then Tamanio='G';
else Tamanio='P';
proc print;
run;


* --------------------- Ejercicio 7 ---------------------*;

* Selecciona las provincias con más de 300.000 h. y guarda sus nombres en maspobladas.;

data MasPobladas;
set CompletoDen;
label Poblacion='Población';
if Poblacion > 300000;

proc print label;
run;


* ----------------------- Ejercicio 8 ----------------------;
* Haz una descripción univariante (sencilla) de las variables población y 
* superficie. Haz una descripción (más completa) separando los casos segun el tamaño;

PROC MEANS DATA=Clasificado;
RUN;

PROC UNIVARIATE DATA=Clasificado;
CLASS tamanio;
run;


* ----------------------- Ejercicio 9 -----------------------;
* Haz una representación gráfica conjunta de las dos variables anteriores. 
* Calcula su correlación.;

PROC sgplot DATA=Completo;
scatter  y=Poblacion x=Superficie;
RUN;


 
 
