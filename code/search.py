# Casta Ung, 2260067
# Chu Xiang Su, 2079797

# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

from custom_types import Direction
from pacman import GameState
from typing import Any, Tuple,List
import util

"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self)->Any:
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state:Any)->bool:
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state:Any)->List[Tuple[Any,Direction,int]]:
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions:List[Direction])->int:
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()



def tinyMazeSearch(problem:SearchProblem)->List[Direction]:
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem:SearchProblem)->List[Direction]:
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    """

    #Initialisation de la fringe de départ (LIFO) ainsi que de la structure gardant en mémoire les états déjà visités
    l = util.Stack()
    l.push((problem.getStartState(), []))
    visited = set()

    #Boucle sur la recherche d'une solution tant que la fringe n'est pas vide ou que l'état final n'a pas été trouvé
    while not l.isEmpty():
        state, actions = l.pop()
        #Retour des actions nécessaires pour arriver à la solution trouvée si l'état final est trouvé
        if problem.isGoalState(state):
            return actions

        #Vérification de si l'état a déjà été visité, sinon ajout dans la structure de données
        if state not in visited:
            visited.add(state)
            #Pour les états successeurs, vérification de si état déjà visité et si non, ajout dans la fringe
            for next_state, action, _ in problem.getSuccessors(state):
                if next_state not in visited:
                    l.push((next_state, actions + [action]))

    util.raiseNotDefined()

def breadthFirstSearch(problem:SearchProblem)->List[Direction]:
    """Search the shallowest nodes in the search tree first."""

    #Initialisation de la fringe de départ (FIFO) ainsi que de la structure gardant en mémoire les états déjà visités
    l = util.Queue()
    l.push((problem.getStartState(), []))
    visited = set()

    #Boucle sur la recherche d'une solution tant que la fringe n'est pas vide ou que l'état final n'a pas été trouvé
    while not l.isEmpty():
        state, actions = l.pop()
        #Retour des actions nécessaires pour arriver à la solution trouvée si l'état final est trouvé
        if problem.isGoalState(state):
            return actions
        
        #Vérification de si l'état a déjà été visité, sinon ajout dans la structure de données
        if state not in visited:
            visited.add(state)
            #Pour les états successeurs, vérification de si état déjà visité et si non, ajout dans la fringe
            for next_state, action, _ in problem.getSuccessors(state):
                if next_state not in visited:
                    l.push((next_state, actions + [action]))

    util.raiseNotDefined()

def uniformCostSearch(problem:SearchProblem)->List[Direction]:
    """Search the node of least total cost first."""

    #Initialisation de la fringe de départ (PriorityQueue) ainsi que de la structure gardant en mémoire les états déjà visités
    l = util.PriorityQueue()
    l.push((problem.getStartState(), [], 0), 0)
    visited = set()

    #Boucle sur la recherche d'une solution tant que la fringe n'est pas vide ou que l'état final n'a pas été trouvé
    while not l.isEmpty():
        state, actions, cost = l.pop()
        #Retour des actions nécessaires pour arriver à la solution trouvée si l'état final est trouvé
        if problem.isGoalState(state):
            return actions
        
        #Vérification de si l'état a déjà été visité, sinon ajout dans la structure de données
        if state not in visited:
            visited.add(state)
            #Pour les états successeurs, vérification de si état déjà visité et si non, ajout dans la fringe
            #Calcul du coût engendré jusqu'à présent + le coût de transition vers un état successeur
            for next_state, action, step_cost in problem.getSuccessors(state):
                new_cost = cost + step_cost
                new_actions = actions + [action]
                if next_state not in visited:
                    l.update((next_state, new_actions, new_cost), new_cost)

    util.raiseNotDefined()

def nullHeuristic(state:GameState, problem:SearchProblem=None)->List[Direction]:
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem:SearchProblem, heuristic=nullHeuristic)->List[Direction]:
    """Search the node that has the lowest combined cost and heuristic first."""

    #Initialisation de la fringe de départ (PriorityQueue) ainsi que de la structure gardant en mémoire les états déjà visités
    l = util.PriorityQueue()
    l.push((problem.getStartState(), [], 0), 0)
    visited = set()

    #Boucle sur la recherche d'une solution tant que la fringe n'est pas vide ou que l'état final n'a pas été trouvé
    while not l.isEmpty():
        state, actions, cost = l.pop()
        current_state_heuristic = heuristic(state,problem)
        #Retour des actions nécessaires pour arriver à la solution trouvée si l'état final est trouvé
        if problem.isGoalState(state):
            return actions
        
        #Vérification de si l'état a déjà été visité, sinon ajout dans la structure de données
        if state not in visited:
            visited.add(state)
            #Pour les états successeurs, vérification de si état déjà visité et si non, ajout dans la fringe
            #Calcul du coût engendré jusqu'à présent + le coût de transition vers un état successeur - heuristique de l'état précédent + l'heuristique de l'état successeur
            for next_state, action, step_cost in problem.getSuccessors(state):
                next_state_heuristic = heuristic(next_state,problem)
                new_cost = cost + step_cost - current_state_heuristic + next_state_heuristic
                new_actions = actions + [action]
                if next_state not in visited:
                    l.update((next_state, new_actions, new_cost), new_cost)
                    
    util.raiseNotDefined()

# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
