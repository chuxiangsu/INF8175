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

% % Contrainte pour avoir un nombre égal de tours bleues et rouges
constraint count(terrain,B) = count(terrain,R);

% Le total_commun sera le nombre de tours bleus ou rouges sur le terrain (même chose)
total_commun = count(terrain,B);

% Contrainte pour éviter les croisements de signaux entre les tours différentes

% Contrainte pour les lignes : 
constraint forall(i in 1..n)
            ((sum(j in 1..n)(terrain[i,j]=B)>=0 /\ sum(j in 1..n)(terrain[i,j]=R)=0) \/ (sum(j in 1..n)(terrain[i,j]=R)>=0 /\ sum(j in 1..n)(terrain[i,j]=B)=0));
            
% Contrainte pour les colonnes : 
constraint forall(i in 1..n)
            ((sum(j in 1..n)(terrain[j,i]=B)>=0 /\ sum(j in 1..n)(terrain[j,i]=R)=0) \/ (sum(j in 1..n)(terrain[j,i]=R)>=0 /\ sum(j in 1..n)(terrain[j,i]=B)=0));
            
% Contrainte pour les diagonales : 
% Diagonale 1
constraint forall(i in 1..n, j in 1..n)
            (((sum(k in 0..n-1)(i+k <= n /\ j+k <= n /\ terrain[i+k, j+k] = B)>=0) /\ (sum(k in 0..n-1)(i+k <= n /\ j+k <= n /\ terrain[i+k, j+k] = R)=0)) \/ ((sum(k in 0..n-1)(i+k <= n /\ j+k <= n /\ terrain[i+k, j+k] = R)>=0) /\ (sum(k in 0..n-1)(i+k <= n /\ j+k <= n /\ terrain[i+k, j+k] = B)=0)));
            
constraint forall(i in 1..n, j in 1..n)
            (((sum(k in 0..n-1)(i-k >=1 /\ j-k >= 1 /\ terrain[i-k, j-k] = B)>=0) /\ (sum(k in 0..n-1)(i-k >=1 /\ j-k >= 1 /\ terrain[i-k, j-k] = R)=0)) \/ ((sum(k in 0..n-1)(i-k >=1 /\ j-k >= 1 /\ terrain[i-k, j-k] = R)>=0) /\ (sum(k in 0..n-1)(i-k >=1 /\ j-k >= 1 /\ terrain[i-k, j-k] = B)=0)));            
            
            
% Diagonale 2
constraint forall(i in 1..n, j in 1..n)
            (((sum(k in 0..n-1)(i+k <= n /\ j-k >= 1 /\ terrain[i+k, j-k] = B)>=0) /\ (sum(k in 0..n-1)(i+k <= n /\ j-k >= 1 /\ terrain[i+k, j-k] = R)=0)) \/ ((sum(k in 0..n-1)(i+k <= n /\ j-k >= 1 /\ terrain[i+k, j-k] = R)>=0) /\ (sum(k in 0..n-1)(i+k <= n /\ j-k >= 1 /\ terrain[i+k, j-k] = B)=0)));
            
constraint forall(i in 1..n, j in 1..n)
            (((sum(k in 0..n-1)(i-k >=1 /\ j+k <= n /\ terrain[i-k, j+k] = B)>=0) /\ (sum(k in 0..n-1)(i-k >=1 /\ j+k <= n /\ terrain[i-k, j+k] = R)=0)) \/ ((sum(k in 0..n-1)(i-k >=1 /\ j+k <= n /\ terrain[i-k, j+k] = R)>=0) /\ (sum(k in 0..n-1)(i-k >=1 /\ j+k <= n /\ terrain[i-k, j+k] = B)=0)));    

% Contrainte pour briser la symétrie : il doit y avoir plus de tours bleues à gauche que à droite (on divise j en 2 pour regarder seulement le côté gauche du terrain)
constraint sum(i in 1..n, j in 1..n div 2) (terrain[i, j] = B) > sum(i in 1..n, j in 1..n div 2) (terrain[i, j] = R);

% Solve pour trouver une solution pour maximiser le nombre de tours en commun total
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
