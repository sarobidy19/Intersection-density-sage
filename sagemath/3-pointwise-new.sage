#!/usr/local/bin/sage

import numpy as np
import sys

def is_derangement(x): #x is a permutation and P is a set of partitions. If any partition in P is part of the cycle type, then x is not a derangement
    u = Permutation(x).fixed_points()
    if len(u) >=3:
            return False
    return True

def VA(m):
      t = ''
      for i in range(m):
          if i == m-1:
              t += 'X{0}'.format(i)
          else:
              t += 'X{0},'.format(i)
      return var(t)

def weights(n,k,L,M):
    P = Partitions(k)
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
        if phi.values() == [1]*len(SymmetricGroup(n).conjugacy_classes_representatives()):
            Eq.append(t == factorial(k)*binomial(n,k) -1)  ######## maximum eigenvalue
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
        #print u
        for j in range(m):
            if u == Partition(L[j]):
                W[i] = Sol[0][j].rhs()
    print "Equation",Eq
    print Sol
    return [Sol[0][i].rhs() for i in range(len(Sol[0]))],W

def eigenvalues_weights(n,k,W):
    P = Partitions(k)
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
        #print (s,psi)
    return eigenvalues#,gap.Minimum(eigenvalues)

def DistinctEntries(L):
    return L[0] != L[1] and L[0] != L[2] and L[1] != L[2]

def Triples(n):
    C = Tuples([1..n],3)
    N = []
    for x in C:
        if DistinctEntries(x) == True:
            N.append(x)
        else:
            pass
    return N

def SymmetricGroupOnTriples(n):
    PermGens = []
    G = SymmetricGroup(n)
    S = G.gens()
    K = label_triples(n)
    L = K[1]
    D = K[0]
    for g in S:
        N = [0]*len(L)
        for x in L:
            i = D[x]
            j = D[action_of_element_as_permutation(g,x)]
            N[i-1] = j
        PermGens.append(Permutation(N))
    return PermutationGroup(PermGens)

def action_of_element_as_permutation(f,T):
    return (f(T[0]),f(T[1]),f(T[2]))

def label_triples(n):
    L = [tuple(x) for x in Triples(n)]
    D = dict()
    i = 1
    for x in L:
        D[tuple(x)] = i
        i += 1
    return D,L

def set_equation(L,k):
    E = []
    T = []
    V = []
    for x in [L[i] for i in [0..k-1]]:
        x = symbolic_expression(x)
        if len(x.arguments()) >0:
            E.append(x>=-1)
            V += list(x.arguments())
    T.append(E)
    V = list(set(V))
    for x in V:
        T.append(x)
    return T


n = int(sys.argv[1])
k = 3
#W = weights(n,k,[[n],[n-5,4,1],[n-1,1],[n-2,2],[n-6,3,3],[n-2,1,1],[n-3,3]],[[n],[n-1,1],[n-2,2],[n-2,1,1],[n-3,3],[n-3,2,1],[n-3,1,1,1]])
#W = weights(n,k,[[n-2,1,1],[n],[n-4,3,1],[n-6,3,3],[n-7,4,3],[n-3,2,1],[n-2,2],[n-8,8]],[[n],[n-1,1],[n-2,1,1],[n-2,2],[n-3,1,1,1],[n-3,2,1],[n-3,3],[n-1,1]])
W = weights(n,k,[[n-3,2,1],[n-1,1],[n-2,1,1],[n-5,3,1,1],[n-5,5],[n-3,3],[n-2,2],[n-4,2,1,1]],[[n],[n-1,1],[n-2,1,1],[n-2,2],[n-3,1,1,1],[n-3,2,1],[n-3,3],[n-1,1]])
L =  eigenvalues_weights(n,k,W[1])
print L
