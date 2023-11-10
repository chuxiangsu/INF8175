from uflp import UFLP
from typing import List, Tuple


def solve(problem: UFLP) -> Tuple[List[int], List[int]]:
    # Le nombre des gares
    n_main = problem.n_main_station
    n_satellite = problem.n_satellite_station

    # Prend la liste des gares satellites avec quelle gare satellite elle est reliée
    # Retourne en ordre croissant des gares principales utilisées en fonction des gares satellites reliées
    def find_opened_main(solution):
        satellite_count = {}
        for sat in solution:
            satellite_count[sat] = satellite_count.get(sat, 0) + 1
        return sorted(satellite_count, key=satellite_count.get)

    # Prend un int de l'index de la gare principale et la liste des gares satellites reliées
    # Retourne tout les gares satellites reliées à ce gare principale en liste
    def find_satellite_linked(main_station, satellite_list):
        linked_station = []
        for index in range(n_satellite):
            if satellite_list[index] == main_station:
                linked_station.append(index)
        return linked_station

    # Prend les deux liste des gares principales et gares satellites
    # Retourne la liste des gares principales qui a des 1 à la bonne place si jamais une gare satellite est reliées à
    # la gare principale et que la gare principale n'est pas ouvert
    def fix_main(main_list, satellite_list):
        fixed_main = main_list
        for elem in satellite_list:
            fixed_main[elem] = 1
        return fixed_main

    # Initialise les deux listes avec le bon nombre de 0 (Toutes fermées) et des -1 (Reliées à aucune gare principale)
    main_solution = [0] * n_main
    satellite_solution = [-1] * n_satellite

    # Relie Toutes les gares satellites à la gare principale la plus proche
    for i in range(n_satellite):
        min_cost = float('inf')
        main = 0
        for j in range(n_main):
            distance = problem.get_association_cost(j, i)
            if distance < min_cost:
                min_cost = distance
                main = j
        satellite_solution[i] = main
        if main_solution[main] == 0:
            main_solution[main] = 1


    opened_station = []
    station_closed = True
    # Compare la l'acienne solution à la nouvelle, s'il y a changement, refait la recherche une autre fois
    while station_closed:
        if opened_station != find_opened_main(satellite_solution):
            opened_station = find_opened_main(satellite_solution)
            station_closed = True
        else:
            station_closed = False

        initial_cost = problem.calcultate_cost(main_solution, satellite_solution)

        # Dans toutes les gares principales ouvertes, ferme une gare
        for station in opened_station:
            test_main = main_solution[:]
            test_satellite = satellite_solution[:]
            test_main[station] = 0
            satellite_linked_list = find_satellite_linked(station, test_satellite)
            changes_made = False
            # Essaye de le relier les gares satellites reliées à ce gare centraile fermée
            # à un autre gare principale déjà ouverte qui est le plus proche
            for satellite in satellite_linked_list:
                min_cost = float('inf')
                new_main = None
                # Trouve une nouvelle gare ouvert le plus proche
                for test_station in opened_station:
                    if test_station != station:
                        distance = problem.get_association_cost(test_station, satellite)
                        if distance < min_cost:
                            min_cost = distance
                            new_main = test_station
                # Si new main a été modifié, ça signifie qu'il y a une solution pour relier la gare
                # satellite, donc on le remplace.
                if new_main is not None:
                    test_satellite[satellite] = new_main
                    # Pour les satellites reliées à la gare principale, tant qu'il y a une qui a été reliée à un autre gare
                    changes_made = True
            # S'il y a eu un changement, on modifie les deux listes de test
            if changes_made:
                test_main = fix_main(test_main, test_satellite)
                test_cost = problem.calcultate_cost(test_main, test_satellite)
                # Repasse une fois sur la carte au complet, si les deux listes de test génère une meilleure solution
                # on le remplace, sinon on fait rien
                if test_cost < initial_cost:
                    main_solution = test_main
                    satellite_solution = test_satellite
                    initial_cost = test_cost

    return main_solution, satellite_solution

