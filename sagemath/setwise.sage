#!/usr/local/bin/sage

import numpy as np
import sys

def conjugacy_class_scheme(G):
    L = []
    CC = G.conjugacy_classes()
    for C in CC:
        print C
        M = Matrix(G.order(),G.order())
        for i in range(G.order()):
            for j in range(G.order()):
                if G[j]*G[i].inverse() in C:
                    M[i,j] = 1
        L.append(M)
    return L

def is_derangement(x):  # for 2 intersecting
    if len(Permutation(x).fixed_points()) <= 1:
        if 2 not in x.cycle_type():
            return True
    else:
        return False

"""def eigenvalues_group(G):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = []
    eigenvalues = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(G,x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues.append(s)
    return list(eigenvalues),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)
"""


def weighting(n):
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    L = derangement_conjugacy_classes_representatives
    print [L[i].cycle_type() for i in range(len(L))]
    W = [0]*len(L)
    for i in range(len(L)):
        u = L[i].cycle_type()
        #print u,i
        #####################weights for n even ##########################
        """if u == Partition([n-1,1]):
            #b = (n - 2)/factorial(n - 2)
            b = (n-3)/(2*factorial(n - 2))
            W[i] = b
        if u == Partition([n]):
            c = 1/factorial(n-2)
            W[i] = c
            #print "ee"
        """
        ###################################################################
        #####################weights for n odd ##########################
        if u == Partition([n-3,3]):
            a = (n-1)/(2*binomial(n,3)*factorial(n-4))
            W[i] = a
        if u == Partition([n-4,3,1]):
            b = (binomial(n,2) -n)/(2*n*binomial(n-1,3)*factorial(n-5))
            W[i] = b
    return W

def eigenvalues_weights(n,W):
    eigenvalues = []
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    #print derangement_conjugacy_classes_representatives
    Irr = G.irreducible_characters()#
    #Irr = SymmetricGroupRepresentations(n)
    for phi in Irr:
        s = 0
        L = derangement_conjugacy_classes_representatives
        for i in range(len(L)):
            s += (1/phi.degree()) * ( W[i]*G.conjugacy_class(L[i]).cardinality()*phi(L[i]) )
            """if phi.degree() == 1:
                print W[i]*G.conjugacy_class(L[i]).cardinality()*phi(L[i])
                print "s",s
        print "--------------"
        """
        eigenvalues.append(s)
    return eigenvalues



#G = CyclicPermutationGroup(30)
#L = conjugacy_class_scheme(G)
#for X in L:
#    print X,"\n"
#print [G[i] for i in range(G.order())]

#f = open("2-intersecting1.txt","w+")
#for n in filter(is_odd,range(4,16)):
    #W = weighting(n)
    #f.write( "{1} ==> {0} \n".format(eigenvalues_weights(n,W),n))

n = int(sys.argv[1])
W = weighting(n)
print W
L =  eigenvalues_weights(n,W)
print L,gap.Minimum(L),gap.Maximum(L), 1/2*n*(n-1) -1
