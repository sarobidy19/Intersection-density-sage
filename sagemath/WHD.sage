#!/usr/local/bin/sage

import numpy as np

def characteristic_vector(X,S):
    u = [0]*X.order()
    for i in range(X.order()):
        if X.vertices()[i] in S:
            u[i] = 1
    return u #.transpose()


X = graphs.CompleteGraph(3)
Y = graphs.KneserGraph(8,2)#X.cartesian_product(X)
Z = Y.complement()
E = Y.eigenspaces()
MaxCliques = [characteristic_vector(Y,x) for x in  Y.cliques_maximum()]
MaxCocliques = [characteristic_vector(Z,x) for x in Z.cliques_maximum()]

W1 = []
for i in range(len(MaxCocliques)-1):
    W1.append(np.array(MaxCocliques[i] - np.array(MaxCocliques[i+1]) ))

W2 = []
for i in range(len(MaxCliques)-1):
    W2.append(np.array(MaxCliques[i] - np.array(MaxCliques[i+1]) ))
