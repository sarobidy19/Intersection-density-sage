

# This file was *autogenerated* from the file ./generalized_setwise.sage
from sage.all_cmdline import *   # import sage library

_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4)#!/usr/local/bin/sage

import numpy as np
import sys

def is_derangement(x,P): #x is a permutation and P is a set of partitions. If any partition in P is part of the cycle type, then x is not a derangement
    u = Permutation(x).cycle_type()
    for y in P:
        if is_submultiset(y,u) == True:
            return False
    return True

def is_submultiset(A,B):
    B = list(B)
    n = len(A)
    a = True
    i = _sage_const_0 
    while i<n and a == True:
        u = A[i]
        if u in B:
            B.remove(u)
        else:
            a = False
        i += _sage_const_1 
    return a

def conjugacy_class_scheme(G):
    L = []
    CC = G.conjugacy_classes()
    for C in CC:
        print C
        M = Matrix(G.order(),G.order())
        for i in range(G.order()):
            for j in range(G.order()):
                if G[j]*G[i].inverse() in C:
                    M[i,j] = _sage_const_1 
        L.append(M)
    return L

def VA(m):
      t = ''
      for i in range(m):
          if i == m-_sage_const_1 :
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
        t = _sage_const_0 
        for i in range(m):
            t += V[i]*phi(CC_size[i][_sage_const_1 ])*CC_size[i][_sage_const_0 ]
            print chi,V[i],phi(CC_size[i][_sage_const_1 ]),CC_size[i][_sage_const_1 ].cycle_type()
        if phi.values() == [_sage_const_1 ]*len(SymmetricGroup(n).conjugacy_classes_representatives()):
            Eq.append(t == binomial(n,k) -_sage_const_1 )  ######## maximum eigenvalue
        else:
            Eq.append(t == -phi.degree())
        Sol = solve(Eq,V)
    print "Weight possible?", len(Sol) != _sage_const_0 
    if len(Sol) == _sage_const_0 :
        return sys.exit()
##################################################################
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x,P) == True:
            derangement_conjugacy_classes_representatives.append(x)
    Q = derangement_conjugacy_classes_representatives
    print len(Q)
    W = [_sage_const_0 ]*len(Q)
    for i in range(len(Q)):
        u = Q[i].cycle_type()
        #print u
        for j in range(m):
            if u == Partition(L[j]):
                W[i] = Sol[_sage_const_0 ][j].rhs()
    print "Equation",Eq
    print Sol
    return [Sol[_sage_const_0 ][i].rhs() for i in range(len(Sol[_sage_const_0 ]))],W

def eigenvalues_weights(n,k,W):
    P = Partitions(k)
    eigenvalues = []
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x,P) == True:
            derangement_conjugacy_classes_representatives.append(x)
    #print derangement_conjugacy_classes_representatives
    Irr = G.irreducible_characters()#
    #Irr = SymmetricGroupRepresentations(n)
    for psi in Irr:
        #phi = psi.to_character()
        s = _sage_const_0 
        L = derangement_conjugacy_classes_representatives
        for i in range(len(L)):
            s += (_sage_const_1 /psi.degree()) * ( W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
        eigenvalues.append(s)
        #print (s,psi)
    return eigenvalues#,gap.Minimum(eigenvalues)

def modified_weights(n,k,L,M,Phi):
    print Phi
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
    T = []
    for j in range(_sage_const_5 ):
        t = _sage_const_0 
        for i in range(m):
            t += V[i]*Phi[j][i]*CC_size[i][_sage_const_0 ]
            #print V[i],Phi[j][i],CC_size[i][1].cycle_type()
        T.append(t)
    #print char
    for i in range(len(char)):
        if i == _sage_const_0 :
            Eq.append(T[i] == binomial(n,k) -_sage_const_1 )  ######## maximum eigenvalue
        elif i == _sage_const_2 :
            Eq.append(T[i] == -binomial(n,_sage_const_3 )+binomial(n,_sage_const_3 -_sage_const_1 ))
        elif  i == 1or i == _sage_const_4 :
            Eq.append(T[i] == -binomial(n,_sage_const_1 )+binomial(n,_sage_const_1 -_sage_const_1 ))
        else:
            Eq.append(T[i] == -binomial(n,_sage_const_2 )+binomial(n,_sage_const_2 -_sage_const_1 ))
    Sol = solve(Eq,V)
    print Eq
    print "Weight possible?", len(Sol) != _sage_const_0 
    if len(Sol) == _sage_const_0 :
        return sys.exit()
##################################################################
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x,P) == True:
            derangement_conjugacy_classes_representatives.append(x)
    Q = derangement_conjugacy_classes_representatives
    print len(Q)
    W = [_sage_const_0 ]*len(Q)
    for i in range(len(Q)):
        u = Q[i].cycle_type()
        #print u
        for j in range(m):
            if u == Partition(L[j]):
                W[i] = Sol[_sage_const_0 ][j].rhs()
    print "Equation",Eq
    print Sol
    return [Sol[_sage_const_0 ][i].rhs() for i in range(len(Sol[_sage_const_0 ]))],W


n = int(sys.argv[_sage_const_1 ])
k = _sage_const_3 
#W = weights(n,k,[[n],[n-3,2,1],[n-1,1],[n-5,5],[n-3,1,1,1],[n-2,1,1]],[[n],[n-1,1],[n-2,2],[n-3,3],[n-4,4],[n-1,1]])
#W = weights(n,k,[[n-2,1,1],[n-2,2],[n],[n-5,4,1],[n-6,5,1]],[[n],[n-1,1],[n-3,3],[n-2,2],[n-1,1]]) #works for odd
#W = weights(n,k,[[n-4,4],[n-5,5],[n],[n-1,1]],[[n],[n-1,1],[n-3,3],[n-2,2]]) #tsy mety
#W = weights(n,k,[[n-6,2,2,2],[n-5,5],[n-6,5,1],[n-6,4,2],[n-6,4,1,1]],[[n],[n-1,1],[n-3,3],[n-2,2],[n-1,1]]) #works for even
#W = weights(n,k,[[n-8,2,2,2,2],[n-5,5],[n-6,5,1],[n-6,4,2],[n-6,4,1,1]],[[n],[n-1,1],[n-3,3],[n-2,2],[n-1,1]])
W = weights(n,k,[[n-_sage_const_2 ,_sage_const_1 ,_sage_const_1 ],[n-_sage_const_2 ,_sage_const_2 ],[n],[n-_sage_const_5 ,_sage_const_4 ,_sage_const_1 ],[n-_sage_const_4 ,_sage_const_4 ]],[[n],[n-_sage_const_1 ,_sage_const_1 ],[n-_sage_const_3 ,_sage_const_3 ],[n-_sage_const_2 ,_sage_const_2 ],[n-_sage_const_1 ,_sage_const_1 ]])
#W = modified_weights(n,k,[[n-2,1,1],[n],[n-1,1],[n-5,4,1],[n-2,2]],[[n],[n-1,1],[n-3,3],[n-2,2],[n-1,1]],[[1,1,1,1,1],[1,-1,0,0,-1],[-1,0,0,0,-1],[-1,0,-1,-1,1],[1,-1,0,0,-1]]) #works for odd - good
#W = weights(n,k,[[n-2,1,1],[n],[n-1,1],[n-5,4,1],[n-2,2]],[[n],[n-1,1],[n-3,3],[n-2,2],[n-1,1]])
#W = weights(n,k,[[n-2,1,1],[n],[n-1,1],[n-2,2]],[[n],[n-1,1],[n-3,3],[n-2,2]])
#W = weights(n,k,[[n-2,1,1],[n],[n-1,1],[n-2,2]],[[n],[n-1,1],[n-3,3],[n-2,2]])
eigenvalues_weights(n,k,W[_sage_const_1 ])
"""K = [[8],[7,1],[6,2],[6,1,1],[4,4],[4,2,2],[2,2,2,2]]
C = Combinations(K,4)
i = 0
for x in C:
    W = weights(n,k,x,[[n],[n-1,1],[n-3,3],[n-2,2]])
    G = SymmetricGroup(n)
    CC = G.conjugacy_classes_representatives()
    D = []
    for x in CC:
        if is_derangement(x) == True:
            D.append(1)
        else:
            D.append(0)
    L =  eigenvalues_weights(n,k,W[1])
    print L
    i+= 1
    print i,"-----------------------------"
    """
