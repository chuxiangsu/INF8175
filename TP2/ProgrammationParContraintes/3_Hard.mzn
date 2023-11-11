% Chu Xiang Su (2079797)
% Casta Ung (2260067)

include "globals.mzn";

% Énumérations des équipes participant au tournoi
enum equipes = {CO, TA, HO, DA, NA, MU, AL, UT};

% Lieux de rencontres des equipes (0 = pas de rencontre).
% Tout lieu i, tel que 0 < i <= card(equipes), 
% est designé comme le domicile de l'équipe associée par la relation to_enum(equipe, i)
set of int: terrains = 0..card(equipes);

% Étendue du tournoi (en jours)
int: d = 16;
set of int: jours = 1..d;

% Calendrier de placement des matchs
array[equipes, jours] of var terrains: calendrier;

% Nombres de rencontres entre deux equipes
array[equipes, equipes] of var 0..2: rencontres;

% Tuples des dates de match entre deux équipes
array[equipes, equipes] of var tuple (0..d, 0..d): dates;

% Variable objectif à maximiser
var int: objectif_match_espaces;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%


% Bonsoir, pour le problème 3 de la partie 2, je ne comprends pas le 'to_enum(equipe, i)'. 
% Ça représente le terrain associé à chaque équipe mais qu'est ce que c'est ? Est ce que c est censé être un enum qu'on doit créer ? Merci

% Hello,
% J'ai utilisé la fonction to_enum comme suit:
% array[1..card(equipes)] of equipes: equipe_du_terrain = to_enum(equipes, 1..card(equipes));
% Ainsi, j'ai déclaré un array où equipe_du_terrain[t] est l'équipe possédant le terrain t.

% La compétition doit respecter les règles suivantes :
% 1. Pour effectuer une rencontre, deux équipe doivent être présente sur le même terrain.

array[equipes] of int: equipe_indices = [1, 2, 3, 4, 5, 6, 7, 8];


% 2. Un match doit avoir lieu sur le terrain désigné comme le domicile de l’une des deux équipes.
% Un match entre 2 équipes doit avoir lieu sur un terrain domicile de l'une des 2 équipes
constraint forall(e1, e2 in equipes where e1 < e2) (
  (calendrier[e1, dates[e1, e2].1]= equipe_indices[e1] \/ calendrier[e1, dates[e1, e2].1]= equipe_indices[e2]) /\ 
  (calendrier[e1, dates[e1, e2].2]= equipe_indices[e1] \/ calendrier[e1, dates[e1, e2].2]= equipe_indices[e2])
 ); 
% constraint forall(e1, e2 in equipes where e1 < e2)(
%   calendrier[e2, dates[e1, e2].1]= calendrier[e1, dates[e1, e2].1] /\ calendrier[e2, dates[e1, e2].2]= calendrier[e1, dates[e1, e2].2]
% );


constraint forall(e1, e2 in equipes where e1 < e2) (
  (calendrier[e2, dates[e1, e2].1]= equipe_indices[e1] \/ calendrier[e2, dates[e1, e2].1]= equipe_indices[e2]) /\ 
  (calendrier[e2, dates[e1, e2].2]= equipe_indices[e1] \/ calendrier[e2, dates[e1, e2].2]= equipe_indices[e2])
 ); 


% 6. Les équipes doivent jouer deux fois l’une contre l’autre.
% Chaque paire d'équipes doit se rencontrer deux fois
constraint forall(e1, e2 in equipes where e1 < e2) (
  rencontres[e1, e2] = 2
);

% 3. Un terrain ne peut accueillir plus de deux équipes.
% Un terrain ne peut accueillir plus de deux équipes
constraint forall(j in jours, t in terrains) (
  sum(e in equipes) (calendrier[e,j] = t) <= 2
 );


% 5. Une équipe ne doit pas jouer trop souvent à domicile, elle n’est donc pas autorisée à jouer plus
% de 7 jours sur son propre terrain.
% Une équipe ne doit pas jouer plus de 7 jours sur son propre terrain

constraint forall(e in equipes) (
    sum(j in jours) (calendrier[e, j] = equipe_indices[e]) <= 7
);



% 4. Si une équipe ne joue pas lors d’une période elle est placée sur le terrain n°0.
% 7. Les deux rencontres de deux équipes doivent être espacées de 3 jours au minimum.
% Si une équipe ne joue pas lors d’une période, elle est placée sur le terrain n°0
% Les deux rencontres de deux équipes doivent être espacées d'au moins 3 jours
constraint forall(e1, e2 in equipes where e1 < e2) (
    let { var int: jour1 = dates[e1, e2].1, var int: jour2 = dates[e1, e2].2 } in (
        (jour1 != 0 /\ jour2 != 0) -> abs(jour1 - jour2) >= 3
    )
);

% 8. Les deux rencontres de deux équipes doivent avoir lieu sur des terrains différents
% Les deux rencontres entre deux équipes doivent se dérouler sur des terrains différents
constraint forall(e1, e2 in equipes where e1 < e2) (
    calendrier[e1, dates[e1, e2].1] != calendrier[e1, dates[e1, e2].2]
);
    %     calendrier[e1, dates[e1, e2].1] != calendrier[e2, dates[e1, e2].2]


constraint objectif_match_espaces = sum(e1, e2 in equipes where e1 < e2)(abs(dates[e1, e2].1-dates[e1, e2].2)>=6);
    
%     let { var int: jour1 = dates[e1, e2].1, var int: jour2 = dates[e1, e2].2 } in (
%         (jour1 != 0 /\ jour2 != 0) -> abs(jour1 - jour2) >= 6
%     )
% );

% Trouver une solution qui maximisez le nombre de matchs espacés de 6 jours ou plus tout en respectant les contraintes
solve maximize objectif_match_espaces;

%-----------------------------------------------------------------------------%

% Affichage du calendrier par equipes et par jours puis du résultat de la fonction objectif.
% Lorsqu'une équipe ne joue pas, l'emplacement de match reste vide sinon elle contient le nom de l'équipie adverse.
% Si une équipe ne joue pas à domicile, un "@" précède le nom de l'équipe adverse.
output 
["Calendrier:\n"]
++
[if j = 1 then "   " else "" endif ++ if j < 10 then "  j" ++ show(j) else " j" ++ show(j) endif ++ if j = d then "\n" else "" endif | j in jours ]
++
[if j = 1 then show(e1) ++ ":" else "" endif ++ if fix(calendrier[e1,j]) = 0 then "    " else if fix(calendrier[e1,j]) = e1 then "  " ++ concat([if e1 != e2 /\ fix(calendrier[e2,j]) = e1 then show(e2) else "" endif | e2 in equipes])  else " @" ++ show(to_enum(equipes, calendrier[e1,j])) endif endif ++ if j = d then "\n" else "" endif | e1 in equipes, j in jours ]
++
["\nMatchs retour espacés de 6 jours ou plus = " ++ show(objectif_match_espaces) ++ "\n"]
;

