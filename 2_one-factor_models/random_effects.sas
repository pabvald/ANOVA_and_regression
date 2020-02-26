
* Se trata de estudiar el posible efecto del profesorado en la nota final obtenida por los estudiantes de un cierto nivel de enseñanza.
* Se seleccionan 28 estudiantes de similares características y aptitudes al comienzo del curso, y se reparten al azar entre  4 profesores,
* elegidos también al azar entre todos los profesores de dicho nivel;


*1. IMPORTAMOS  el conjunto de datos datatab_6_26.xls como teacher;
proc import datafile='/folders/myfolders/Datos/Datos-20190913/datatab_6_26.xls'
   out=teacher replace
   DBMS=xls;
   sheet="teachers";
   getnames=yes;
run;



*2. Declaramos un efecto aleatorio y pedimos el test basado en las sumas de cuadrados;

proc glm;
	class teacher; 
	model score=teacher;
	random teacher / test;
run;quit;

*
	Source			DF	Type III SS		Mean Square		F Value		Pr > F
	teacher			3	683.250000		227.750000		2.58		0.0772
	Error:MS(Error)	24	2119.714286		88.321429	 	
*;

*No podemos rechazar la hipótesis HO: s2(tau)= 0, así pues no podemos concluir que haya diferencias entre profesores,
y no tiene mucho sentido estimar s2(tau) pero vemos como se hace.



227.75 = Var(Error) + 7 Var(teacher) = sigma2 + 7. sigma2(tau)
88.321429= Var(Error) = ^sigma2
Despejando se obtiene ^sigma2(tau)= 19.9.
(No se rechaza que sea nulo por la gran dispersión de los estimadores de la varianza, al no ser una muestra grande);
