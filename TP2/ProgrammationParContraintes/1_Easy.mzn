% Chu Xiang Su (2079797)
% Casta Ung (2260067)

include "globals.mzn";

% Nombre de fréquences à placer
int: m;
% Placements possibles selon le nombre de fréquences
int: n = m*m;

% Définition de la plage de fréquences
array[1..m] of var 0..n: frequences;

% Calcul des distances entre les différentes fréquences
array[1..(m*(m-1)) div 2] of var 0..n: distances =
    [ frequences[j] - frequences[i] | i in 1..m, j in i+1..m];

% Variable objectif à minimiser
var int: longueur;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%

% Assigner la longueur de la plage à la distance maximale entre 2 fréquences (dernier élément, car tri en ordre croissant)
longueur = frequences[m];

% Contrainte pour ordonner les fréquences en ordre croissant
constraint increasing(frequences);

% Contraintes pour éviter les interférences entre les différentes fréquences (distances uniques)
constraint all_different(distances);

% Trouver une solution optimale qui minimise la longueur de la plage des fréquences
solve minimize longueur;

%-----------------------------------------------------------------------------%

output 
  [show(frequences)]
  ++
  ["\nLongueur de la plage = ", show(longueur)];
