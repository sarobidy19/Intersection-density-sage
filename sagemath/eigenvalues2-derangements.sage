#!/usr/local/bin/sage

import sys

def  is_derangement(x):
    if len(Permutation(x).fixed_points()) <= 1:
        #if 2 not in x.cycle_type():
          return True
    else:
        return False

def eigenvalues_group(G):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = []
    eigenvalues = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues.append(s)
        print s,phi.degree()
    return eigenvalues

def eigenvalues_groupchar(G):
    IRR = SymmetricGroupRepresentations(n)
    derangement_conjugacy_classes_representatives = []
    eigenvalues = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    for psi in IRR:
      phi = psi.to_character()
      s = 0
      for x in derangement_conjugacy_classes_representatives:
          s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
      eigenvalues.append((s,psi))
      print s,psi
    return eigenvalues

n = int(sys.argv[1])
G = SymmetricGroup(n)
L = eigenvalues_group(G)
print gap.Minimum(eigenvalues_group(G))
#for x in L:
#    print x
print L
print G.stabilizer(1).order(),((factorial(n))/(1- gap.Maximum(L)/gap.Minimum(L))),G.stabilizer(1).order()-((factorial(n))/(1- gap.Maximum(L)/gap.Minimum(L)))
