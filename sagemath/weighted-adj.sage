#!/usr/local/bin/sage

def is_derangement(x):
     if len(Permutation(x).fixed_points()) == 0:
         return True
     else:
         return False

def eigenvalue_weighting(G,L):
    CC = G.conjugacy_classes_representatives()
    D = []
    for x in CC:
        if is_derangement(x) == True:
            D.append(x)
    Ev = []
    Irr = G.irreducible_characters()
    for phi in Irr:
        S = 0
        for i in range(len(D)):
            S += phi(D[i])*len(G.conjugacy_class(D[i]))*L[i]
        Ev.append(S/phi.degree())
    return Ev
