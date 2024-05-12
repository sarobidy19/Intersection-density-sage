#!/usr/local/bin/sage

import group_vs_der
import numpy as np

def get_derangement_graph(X):
    X.relabel()
    G = X.automorphism_group()
    D = group_vs_der.get_derangements(G)
    return Graph(G.cayley_graph(generators = D))

def weighted_adjacency_matrix(X):
    G = X.vertices()
    D = X.neighbors(X.vertices()[0])
    G = PermutationGroup(G)
    Cl = G.conjugacy_classes()
    conjugacy_classes_in_derangements = []
    for x in Cl:
        if x[0] in D:     #test if the conjugacy_class (rather one of its element) is in the set of derangements
            conjugacy_classes_in_derangements.append(x)
    l = len(conjugacy_classes_in_derangements)
    weight = tuple(list([1,2]))
    Adj_matrix = np.eye(G.order(),G.order())
    """for i in range(G.order()):
        for j in range(G.order()):
            for X in conjugacy_classes_in_derangements:
                if G[i].inverse()*G[j] in X:
                    Adj_matrix[i,j] = 1
                else:
                    Adj_matrix[i,j] = 0
    return Adj_matrix"""

def graph_compare(G,H):
    X = G.automorphism_group()
    Y = H.automorphism_group()
    LX = X.conjugacy_classes_subgroups()
    LY = Y.conjugacy_classes_subgroups()
    print X.is_solvable(),Y.is_solvable()
G = graphs.KneserGraph(7,2)
G.relabel()
A = G.automorphism_group()
X = A.cayley_graph(generators = group_vs_der.get_derangements(A))
X = Graph(X)
#graph_compare(G,H)
print G.order(),X.clique_number()
