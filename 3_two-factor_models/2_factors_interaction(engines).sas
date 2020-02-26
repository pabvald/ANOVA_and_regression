*(Ejemplo FWS-9.3, datatab_9_5);
*Rendimiento de motores en millas por galon, con dos factores: tipo de motor con 4 o 6 cilindros,
y tipo de aceite: 1- estandar, 2- multi, 3-gasmiser;


** --- Importación de los datos ---;
PROC IMPORT OUT= WORK.mpg 
            DATAFILE= "G:\datos\mpg.xls" 
            DBMS=xls REPLACE;
     sheet="Sheet1"; 
     getnames=yes;
RUN;

** --- ANOVA - Modelo de 2 Factores con interacción ---;
*La interaccion se especifica como si fuera un producto de los dos factores;
proc anova; 
class cylinder oil;
model mpg = cylinder oil cylinder*oil;
run;

** Vemos que hay diferencias entre las (6) poblaciones. Vemos despues que la interaccion es significativa,
** por lo que hay que tener precaucion al valorar los efectos de los factores, aunque en este caso ambos son
** tambien significativos. Para obtener el plot de interaccion cambiamos a GLM, segun el orden de los factores
** nos hace uno u otro;


proc glm data=mpg;
class oil cylinder; 
*class  cylinder oil;
model mpg= oil cylinder oil*cylinder; 
means oil cylinder oil*cylinder;
run;

** Se observa que los coches con cuatro cilindros siempre tienen mayor rendimiento, 
** pero con el aceite tipo 2 la diferencia es m�nima;
** en el otro grafico de interaccion se observa que el aceite 3 es optimo con 4 cilindros, pero el peor con 6;
** means nos da las medias para cada nivel del factor, aconsejable solo con datos
** balanceados. 

** Podemos hacer la comparacion de todos los pares de medias de los factores;

means oil / tukey; run;
** El tipo 2 es mejor que el 1, pero no mejor que el 3;
means oil cylinder/ LSD ;run;
** El test T si que distingue entre 1 y 3, a diferencia de tukey.

** Podemos obtener tambien los I.C. para las medias o diferencias de medias;
means oil cylinder/ t bon clm; run;
means oil cylinder/ LSD tukey cldiff; run;


** Pero realmente nos interesa comparar medias de los 6 grupos (tratamientos), puesto que hay interaccion;
lsmeans cylinder*oil / adjust=tukey;run;

** Obtenemos los p-valores para todas las comparaciones de medias de los
tratamientos,vemos que no hay diferencias entre las combinaciones(4 1) (4 2)
y (6 2), lo cual se apreciaba en los box-plots,
adem�s de un gr�fico de las medias y otro de todas las comparaciones
donde se ve que 7 son no significativas (rojo) y 8 son signif. (azul);

*podemos obtener los I. C. simultaneos para las diferencias con;
lsmeans cylinder*oil / cl adjust=tukey;run;
*se obtienen tambien I.C. para las medias, no simultaneos;

*I. C. ordinarios para las diferencias:;
lsmeans cylinder*oil / cl pdiff;run;

*tambien podemos simplemente obtener los I. C. para las medias 
de los tratamientos en el modelo con dos factores usando LSMEANS;
lsmeans cylinder*oil / cl;run;



** Si las interacciones son muy fuertes puede ser preferible tratar el problema conmo ANOVA 1F,
que fabricamos a partir de los dos que teniamos;

data mpg2; 
set mpg;
big=10*cylinder+oil;
run;
proc print;
run;

**Comparaciones de medias de los tratamientos, segun nos interese alguna concreta, o todas
**las diferencias de medias, o poder incluir  todo tipo de comparaciones controlando el
**nivel globalmente con el metodo de  scheffe;

proc glm; 
class big; 
model mpg=big; 
means big / t tukey scheffe; run;

** Los resultados con tukey son los mismos que con "lsmeans cylinder*oil / adjust=tukey" en el modelo completo;
** la tabla anova que se obtiene con big se obtendria tambien con model mpg= oil*cylinder; 

** Si queremos I. C. para las medias;
means big / t bon clm; run;* ordinarios o simultaneos;
** O para las diferencias de medias, tambien obtenidos con el modelo completo;
means big / t tukey cldiff; run;



**para hacer un grafico sencillo de rendimientos medios con todas las combinaciones;
proc sort data=mpg;
by cylinder oil; 
run;

proc summary; 
var mpg; 
output out=mediaset mean=mediampg;
by cylinder oil; 
run;

symbol1 interpol=join color=black value='4';
symbol2 interpol=join color=blue  value='6';

proc gplot data=mediaset; 
plot mediampg*oil=cylinder;
run;


------------------------------------------------------------------------------------------------------
*OPCIONAL: para hacer un grafico "mejor" de rendimientos medios con todas las combinaciones;
proc sort data=mpg; 
by cylinder oil; 
run;

proc summary; 
var mpg;
output out=profile mean=meanmpg; by cylinder oil; 
run;

symbol1 interpol=join color=black l=1 font=arial h=1.5 value='4';
symbol2 interpol=join color=black l=22 font=arial h=1.5 value='6';
axis1 length=4 in label=(font=arial h=1.5 'Oil Type') minor=none
  offset=(5 pct) value=(font=arial h=1.5 'ST' 'MU' 'GM');
axis2 length=3 in label=(angle=90 font=arial h=1.5 'Mean MPG')
  minor=none value=(font=arial h=1.5);
  footnote ;
  
proc gplot data=profile; 
plot meanmpg*oil=cylinder / nolegend
haxis=axis1 vaxis=axis2; 
run;
quit;

 
