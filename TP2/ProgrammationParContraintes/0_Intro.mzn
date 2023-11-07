% Inclure la bibliothèque pour l'utilisation de la fonction all_different et sum
include "globals.mzn"; 

% Variables
% Le nombre à 4 chiffres (0 n'est pas inclus)
var 1000..9999: nombre; 

% Array des chiffres individuels
array[1..4] of var 1..9: chiffres;

% Contraintes

constraint all_different(chiffres);
constraint chiffres[1] > chiffres[2];
constraint chiffres[3] < chiffres[4];
constraint chiffres[2] > chiffres[4];
constraint sum(chiffres) > 15;
constraint nombre == chiffres[1] * 1000 + chiffres[2] * 100 + chiffres[3] * 10 + chiffres[4];
constraint nombre mod 2 == 0;

% Minimiser le produit
solve minimize chiffres[2] * chiffres[3] * chiffres[4];

output [
  show(nombre)
];
