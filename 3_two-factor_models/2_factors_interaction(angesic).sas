**  PABLO VALDUNCIEL SÁNCHEZ ++;

** ANALGÉSICOS INFANTILES (1F+1B)
** El departamento de pediatría de un hospital desea analizar la eficacia de
** cuatro analgésicos infantiles ante las cefaleas. Para ello, realiza un experimento
** en el que se seleccionan aleatoriamente cinco grupos de cuatro pacientes, de
** manera que en cada grupo se da un tipo de cefalea distinto. A continuación se 
** suministra, también de forma aleatoria, cada analgésico a uno de los pacientes de
** cada grupo, y se observa el tiempo de remisión de la cefalea, en minutos. Se 
** registran los datos siguientes, en cada uno de los cinco grupos 
** (tiempo de remisión – analgésico – tipo de cefalea….);

data analgesicos;
format analgesico $ 1.;
input tiempo analgesico $ cefalea;
label tiempo = 'Tiempo de remisión' analgesico = 'Analgésico' cafalea = 'Cefalea';
cards;
30 A 1 
28 B 1 
16 C 1 
34 D 1
14 A 2 
14 B 2 
10 C 2 
22 D 2
24 A 3 
20 B 3 
14 C 3 
28 D 3
38 A 4 
34 B 4 
20 C 4 
44 D 4
26 A 5 
24 B 5 
14 C 5 
30 D 5
;

run;
 
**1.- Estudia el tipo de diseño adecuado para esta situación, 
** e identifica las variables, factores y parámetros.;

proc glm data=analgesicos;
class analgesico cefalea;
model tiempo = analgesico cefalea;
output out=residuos r=res p=pred student=rst;
run;

** El diseño adecuado para esta situación es un diseño en bloques completamente 
** aleatorizado en el que hay 
**
**	- Un factor principal, T-alpha, que es 'analgesico', con I = 4 niveles.
**  - Un factor bloque, B-beta, que es 'cefalea', con J = 5 niveles.
**	- Una variable respuesta, Y, que es 'tiempo'
**
** El modelo matemático tiene la siguiente forma:
**
**				Y(ij) = Mu + alpha(i) + beta(j) + e(ij)
**
** para cada i = A, B, C, D y para cada j = 1, 2, 3, 4, 5, siendo 
**
**	- Y(ij): el resultado del tratamiento i-ésimo de T-alpaha al bloque j-ésimo.
**	- Mu: la media de toda la población. 
**  - alpha(i): el efecto del tratamiento i-ésimo de T-alpha (analgesico).
**	- beta(j): es el efecto del bloue j-ésimo.
;





** 2.- ¿Es adecuado usar las cefaleas como bloques?. 
** ¿Existen diferencias significativas entre los tiempos de remisión 
** de las cefaleas para los distintos analgésicos?;

** Observando la tabla ANOVA, vemos como se el p-valor para el constraste de
** hipótesisis Ho(beta) es <0.0001. El contraste de hipótesis Ho(beta) es :
**
**		Ho(Beta): Beta1 = Beta2 = ... = BetaJ = 0
**		H1(Beta): existe algún par Betai <> Betaj, para i,j en {1, 2, ..., J}
**
** Con el p-valor obtenido rechazamos la hipótesis Ho(Beta) a los niveles de c
** confianza habituales, es decir, existen evidencias para afirmar que el factor
** bloque 'cefalea' sí influye en la variable respuesta 'tiempo', lo que implica 
** que sí ha sido adecuado bloquear. ;

** El p-valor obtenido para el contraste de hipótesis Ho(Alpha) es también 
** <0.0001, por lo que rechazamos la hipótesis nula Ho(Alpha) a los niveles 
** de confianza habituales, es decir, existen evidencias par afirmar 
** que hay diferencias significativas entre los tiempos de remisión de las 
** cefaleas para los distintos analgésicos a los niveles de confianza habituales.




** 3.- Estudia gráficamente la existencia de interacción entre analgésico 
** y cefalea.;
proc glm data=analgesicos;
class analgesico cefalea;
model tiempo = analgesico cefalea;
run;

proc glm data=analgesicos;
class cefalea analgesico ;
model tiempo = analgesico cefalea;
run;

** Observando los dos gráficos de interacción, vemos como en ambos las líneas
** se mantienen paralelas para todos los niveles y no se aprecia ningún
**  tipo de interacción;



** 4.-Determina mediante comparaciones múltiples cuál de los analgésicos
** es más eficaz.;
proc glm data=analgesicos;
class analgesico cefalea;
model tiempo = analgesico cefalea;
means analgesico/ bon tukey duncan ;
run;

** Los tres tests realizados coinciden en sus resultados. El analgésico D tiene
** un tiempo de remisión significativamente mayor que el resto. Entre los
** analgésicos A y B no existen diferencias significativas entre los tiempos de
** remisión, y ambos tienen un tiempo de remisión significativamente mayor que el 
** del analgésico C;
**
** El analgésico C es por lo tanto el más eficaz, siendo su tiempo de remisión
** el que es significativamente menor;



**5.- Suponiendo que el analgésico A es un placebo, realiza el test de Dunnett;
means analgesico / DUNNETT('A');
run;



**6.- Haz un análisis gráfico de los residuos.;

** -- Normalidad de los errores --;
proc univariate plot data=residuos;
var rst;
histogram / normal;
run;

** Los test de Normalidad nos permiten aceptar la hipótesis de normalidad 
** de los residuos a los niveles de confianza habituales. Observando el histogram
** vemos como este es casi perfectamente simétrico, aunque hay tal vez
** un exceso de concentración de las observaciones en torno a la media;


** -- Bondad del ajuste, Homocedasticida de los errores --;
proc sgplot data=residuos;
scatter y=rst x=pred;
run; 

** Vemos como los residuos no son ni execesivamente positivos ni excesivemente
** negativos, por lo que podemos concluir que el modelo se ajusta bien;


** Al observar el diagrama de puntos de los residuos estandarizados frente a las
** predicciones, vemos como tal vez existe una cierta heterocedasticidad, pero
** no muy grande.;




** 7.- Si los analgésicos se hubieran elegido al azar entre todos los existentes,
** plantea el modelo adecuado y estima las componentes de la varianza.;

proc glm data=analgesicos;
class analgesico cefalea;
model tiempo = analgesico cefalea;
random analgesico/test;
run; 


** Sabemos que E(SCMT) = sigma² + 5*sigma_tau², lo que es equivalente
** a  que 
** 
** 	 217.885714 = 6.166667 + 5 * Var(analgesico)
**
** por lo que Var(Analgesico) = 42.3438094
**
** Rechazamos la hipótesis nula Ho(sigma_tau²): sigma_tau² = 0 a los niveles 
** confianza habituales al haberse obtenido un p-valor <0.001;



** 8.- Plantea el modelo como diseño unifactorial completamente 
** aleatorizado y compara los resultados.;

proc glm data = analgesicos;
class analgesico;
model tiempo = analgesico;
random analgesico/test;
means analgesico/ bon tukey duncan;
run;

** Al aplicar un diseño unifactorial completamente aleatorizado, se sigue rechanzado la hipótesis 
** Ho(Alpha) a los niveles de confianza habituales. Sim embargo, aunque se sigan detectando 
** diferencias significativas entre los tiempos de remisión de los distintos analgésicos, al realizar 
** de nuevo los test de Bonferroni, Tukey y Duncan, observamos como se detectan diferencias 
** significativas entre el peor analgésico, el D, y el mejor analgésico, el C. Este modelo se adapta
** peor al problema y refuerza la idea de que el bloqueo con el factor bloque 'cefalea' era adecuado;




