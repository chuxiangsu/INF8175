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

array[equipes] of int: equipe_indices = [1, 2, 3, 4, 5, 6, 7, 8];

% 2. Un match entre 2 équipes doit avoir lieu sur un terrain domicile de l'une des 2 équipes
constraint forall(e1, e2 in equipes where e1 < e2) (
    % Vérifier que les matchs se déroulent sur le terrain de l'une des deux équipes
    (calendrier[e1, dates[e1, e2].1] = equipe_indices[e1] \/ calendrier[e1, dates[e1, e2].1] = equipe_indices[e2]) /\
    (calendrier[e1, dates[e1, e2].2] = equipe_indices[e1] \/ calendrier[e1, dates[e1, e2].2] = equipe_indices[e2]) /\
    
    % 7. Les deux rencontres doivent être espacées de 3 jours au minimum
    (abs(dates[e1, e2].1 - dates[e1, e2].2) >= 3) /\
    
    % 8. Les rencontres doivent avoir lieu sur des terrains différents
    (calendrier[e1, dates[e1, e2].1] != calendrier[e1, dates[e1, e2].2]) /\
    
    % Relier la date avec le calendrier
    forall(j in jours where j = dates[e1, e2].1 \/ j = dates[e1, e2].2) (
        calendrier[e1, j] = calendrier[e2, j]
    ) /\
    
    % Assurer que les rencontres sont symétriques
    dates[e1, e2] = dates[e2, e1]
);

% 3. Un terrain ne peut accueillir plus de deux équipes
constraint forall(j in jours, t in terrains where t != 0) (
    count(e in equipes)(calendrier[e,j] = t) <= 2
);

% 5. Une équipe ne doit pas jouer plus de 7 jours sur son propre terrain (à domicile)
constraint forall(e in equipes) (
    count(j in jours)(calendrier[e, j] = equipe_indices[e]) = 7 /\
    
    % Assurer qu'il ne joue seulement pas pendant 2 jours
    count(j in jours)(calendrier[e,j] = 0) = 2 /\
    
    % Assurer que les dates de match sont différentes pour chaque équipe
    all_different([dates[e, e2].1 | e2 in equipes where e != e2]) /\
    all_different([dates[e, e2].2 | e2 in equipes where e != e2])
);

% Définition de l'objectif qui est le nombre de matchs espacés de 6 jours ou plus
constraint objectif_match_espaces = sum(e1, e2 in equipes where e1 < e2)(abs(dates[e1, e2].1-dates[e1, e2].2)>=6);
    
% Trouver une solution qui maximise le nombre de matchs espacés de 6 jours ou plus tout en respectant les contraintes
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
