#!/usr/local/bin/sage

import numpy as np
import sys

def is_derangement(x):  # for 2 intersecting
    if len(Permutation(x).fixed_points()) <= 1:
        if 2 not in x.cycle_type():
          return True
    else:
        return False


def VA(m):
    t = ''
    for i in range(m):
        if i == m-1:
            t += 'X{0}'.format(i)
        else:
            t += 'X{0},'.format(i)
    return var(t)

def weights(n,L,M):
    l,m = len(L),len(M)   #L = conj and M char
    print l,m
    V = VA(m)
    var('z')
    CC_size = []
    char_values = []
    Eq = []
    for F in L:
        for x in SymmetricGroup(n).conjugacy_classes_representatives():
            if x.cycle_type() == F:
                CC_size.append([SymmetricGroup(n).conjugacy_class(x).cardinality(),x])
                break
            else:
                pass
    char = [SymmetricGroupRepresentation(M[i]) for i in range(m)]
    print CC_size
    for chi in char:
        phi = chi.to_character()
        t = 0
        for i in range(m):
            t += V[i]*phi(CC_size[i][1])*CC_size[i][0]
            print chi,V[i],phi(CC_size[i][1]),CC_size[i][1].cycle_type()
        if phi.values() == [1]*len(SymmetricGroup(n).conjugacy_classes_representatives()): ###nothing happens here, I replaced [0]* with [1]*
            Eq.append(t == (n-1)*n/2 -1)  ######## maximum eigenvalue
        else:
            Eq.append(t == -phi.degree())
        Sol = solve(Eq,V)
    print "Weight possible?", len(Sol) != 0
    if len(Sol) == 0:
        return sys.exit()
##################################################################
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    Q = derangement_conjugacy_classes_representatives
    print len(Q)
    W = [0]*len(Q)
    for i in range(len(Q)):
        u = Q[i].cycle_type()
        print u
        for j in range(m):
            #print "#",[u, Partition(L[j])]
            if u == Partition(L[j]):
                W[i] = Sol[0][j].rhs()
    print "Equation",Eq
    print "solution",Sol
    print "Wito",W
    return [Sol[0][i].rhs() for i in range(len(Sol[0]))],W

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
    for psi in Irr:
        #phi = psi.to_character()
        s = 0
        L = derangement_conjugacy_classes_representatives
        for i in range(len(L)):
            s += (1/psi.degree()) * ( W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
        eigenvalues.append(s)
        a,b = 0,0
        a = SymmetricGroupRepresentation([2]+(n-2)*[1]).to_character().values()
        b = SymmetricGroupRepresentation([2,2]+(n-4)*[1]).to_character().values()
        c = SymmetricGroupRepresentation([n-1,1]).to_character().values()
        d = SymmetricGroupRepresentation([n-2,2]).to_character().values()
        if psi.values() == a:
            print "[2,1^{n-2}]",eigenvalues[-1]
        if psi.values() == b:
            print "[2^2,1^{n-4}]", eigenvalues[-1]
        if psi.values() == c:
            print "[n-1,1]", eigenvalues[-1]
        if psi.values() == d:
            print "[n-2,2]",eigenvalues[-1]
    return eigenvalues,gap.Minimum(eigenvalues)



n = int(sys.argv[1])


W = weights(n,[[n-3,3],[n-1,1]],[[n-1,1],[n-2,2]])
print "W",W
G = SymmetricGroup(n)
k = len(G.conjugacy_classes())

L =  eigenvalues_weights(n,W[1])
#U = list(L)
#var('r7')
#r7 = solve(L[0][0] == 0,r7)[0].rhs()
print L[0],gap.Minimum(L[0]),L[1]
print n*(n-1) -1,type(L[0][0])
