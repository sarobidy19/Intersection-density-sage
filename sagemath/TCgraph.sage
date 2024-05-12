#!/usr/local/bin/sage

import group_vs_der

G = graphs.TutteCoxeterGraph()
G.relabel()
A = SymmetricGroup(3)
print A.order()
#X = A.cayley_graph(generators = group_vs_der.get_derangements(A))
#X = Graph(X)
CC = A.conjugacy_classes()
CCrep = A.conjugacy_classes_representatives()
print CCrep

def get_derangements():
    return filter(is_derangement,A)
def is_derangement(x):
    for i in A.domain():
        if x(i) == i:
            return False
        else:
            pass
    return True


print get_derangements(),group_vs_der.get_derangements(A)
