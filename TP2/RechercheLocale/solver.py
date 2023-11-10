from uflp import UFLP
from typing import List, Tuple

def solve(problem: UFLP) -> Tuple[List[int], List[int]]:
    n_main = problem.n_main_station
    n_satellite = problem.n_satellite_station

    def find_opened_main(solution):
        satellite_count = {}
        for sat in solution:
            satellite_count[sat] = satellite_count.get(sat, 0) + 1
        return sorted(satellite_count, key=satellite_count.get)

    def find_satellite_linked(main_station, satellite_list):
        linked_station = []
        for index in range(n_satellite):
            if satellite_list[index] == main_station:
                linked_station.append(index)
        return linked_station

    def fix_main(main_list, satellite_list):
        fixed_main = main_list
        for elem in satellite_list:
            fixed_main[elem] = 1
        return fixed_main

    main_solution = [0] * n_main
    satellite_solution = [-1] * n_satellite

    # Link every satellite to the nearest main station
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
    while station_closed:
        if opened_station != find_opened_main(satellite_solution):
            opened_station = find_opened_main(satellite_solution)
            station_closed = True
        else:
            station_closed = False

        initial_cost = problem.calcultate_cost(main_solution, satellite_solution)
        for station in opened_station:
            test_main = main_solution[:]
            test_satellite = satellite_solution[:]
            test_main[station] = 0
            satellite_linked_list = find_satellite_linked(station, test_satellite)
            changes_made = False
            for satellite in satellite_linked_list:
                min_cost = float('inf')
                new_main = None
                for test_station in opened_station:
                    if test_station != station:
                        distance = problem.get_association_cost(test_station, satellite)
                        if distance < min_cost:
                            min_cost = distance
                            new_main = test_station
                if new_main is not None:
                    test_satellite[satellite] = new_main
                    changes_made = True
            if changes_made:
                test_main = fix_main(test_main, test_satellite)
                test_cost = problem.calcultate_cost(test_main, test_satellite)
                if test_cost < initial_cost:
                    main_solution = test_main
                    satellite_solution = test_satellite
                    initial_cost = test_cost

    # problem.show_solution(main_solution, satellite_solution)
    return main_solution, satellite_solution

