% Chu Xiang Su (2079797)
% Casta Ung (2260067)

include "globals.mzn";

% États possibles pour une case du terrain
% V = Vide
% B = Tour bleue
% R = Tour rouge
enum etat = {V, B, R};

% Dimension du terrain (carré)
int: n;
set of int: dim = 1..n;

% État du terrain
array[dim, dim] of var etat: terrain;

% Variable objectif à maximiser
var int: total_commun;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%

% Contrainte pour avoir un nombre égal de tours bleues et rouges
constraint count(terrain,B) = count(terrain,R);

% Le total_commun sera le nombre de tours bleus ou rouges sur le terrain (même chose)
total_commun = count(terrain,B);

% Contrainte pour éviter les croisements de signaux entre les tours différentes



% Contrainte pour briser la symétrie : les tours bleues sont limitées à la partie supérieure gauche
%fixer une partie en bleu dans un coin par exemple



% Trouver une solution pour maximiser le nombre de tours en commun total
solve maximize total_commun;

%-----------------------------------------------------------------------------%
output 
["Terrain :\n"]
++
[if j = 1 then "["  endif ++ if fix(terrain[i,j]) == V then "_" else show(terrain[i,j]) endif ++ if j = n then "]\n" else "," endif | i in 1..n, j in 1..n]
++
["\n"]
++
["Total de tours commun: " ++ show(total_commun)]
