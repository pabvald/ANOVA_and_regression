* Los datos representan las cosechas recogidas, de tres variedades de trigo,
en cinco bloques compuestos de parcelas contiguas, supuestamente similares.

(EXAMPLE FWM 10.2, WHEAT YIELDS);


data wheat;
input variety $ block yield;
datalines;
a 1 31
a 2 39.5
a 3 30.5
a 4 35.5
a 5 37
b 1 28
b 2 34
b 3 24.5
b 4 31.5
b 5 31.5
c 1 25.5
c 2 31
c 3 25
c 4 33
c 5 29.5
;
proc sgplot;
scatter y=yield x= variety; run;
*se aprecian mayores cosechas para la variedad a, aunque los dos valores mas bajos
de esta variedad son superados por algunos de otras variedades;

proc anova ;
class block variety; 
model yield=block variety; run;
*se rechazan la igualdad entre bloques y entre variedades. El bloqueo es adecuado. 
Para obtener mas informacion sobre diferencias entre tratamientos;

means variety /lsd duncan tukey bon; run;
*de mas a menos sensibles para detectar diferencias, pero solo los dos ultimos aseguran el nivel
para todas las comparaciones, y de los dos primeros el segundo controla mejor el nivel conjunto.

I.C. simultaneos para diferencias de medias;
means variety/ tukey cldiff;run;

*si consideramos el bloque como efecto aleatorio;
proc glm alpha=0.01;
class block variety; 
model yield=block variety;
random block ;
means variety / lsd duncan tukey bon;run;
*mismos resultados, con alpha=0.01, pero nos da la expresion para estimar la varianza
del efecto bloque, Var(Error) + 3 Var(block)= 37.2250000, despejando 
Var(block)= (37.2250000-1.8000000)/3. Tambien se puede estimar var(Y)= Var(Error) + Var(block);

*graficos de residuos;
proc glm data=wheat ;
class block variety; 
model yield=block variety; 
output out=soluc P=predicho R=residuo;proc print;run;

*goptions reset=all;
proc gplot data=soluc;
plot residuo*predicho; run;
proc univariate normal  data=soluc;
var residuo;
qqplot;run;

*graficos de interacciones;
proc gplot data=wheat;
symbol interpol=join;
plot yield*block=variety;
plot yield*variety=block;run;


