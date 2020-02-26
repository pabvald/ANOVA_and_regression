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
proc print data=factorial;run;