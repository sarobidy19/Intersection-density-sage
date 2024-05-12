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
    if len(Permutation(x).fixed_points()) == 0:
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
        if phi.values() == [1]*len(SymmetricGroup(n).conjugacy_classes_representatives()):
            Eq.append(t == (n-1))  ######## maximum eigenvalue
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
def weighting(n):
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    L = derangement_conjugacy_classes_representatives
    #print [L[i].cycle_type() for i in range(len(L))]
    W = [0]*len(L)
    for i in range(len(L)):
        u = L[i].cycle_type()
        #print u,i
        #####################weights for n even ##########################
        """if u == Partition([n-1,1]):
            b = (n - 2)/factorial(n - 2)
            #b = 1/factorial(n-3)
            W[i] = b
        if u == Partition([n-2,2]):
            c = 2/(n*factorial(n - 3))
            W[i] = c
            print "ee" """
        ###################################################################
        #####################weights for n odd ##########################
        """if u == Partition([n]):
            #a = -1/2*(n^2 - 3*n + 2)/factorial(n - 1)
            W[i] = 1/4*(n^2 + n - 4)/factorial(n - 1)"""
        if u == Partition([n-3,3]):
            a = 2*binomial(n,3)*factorial(n-4)
            #b = -1/2*(n - 5)/((n - 2)*factorial(n - 4)) - 3*((n - 1)*n - 1)/((n - 1)*(n - 2)*n*factorial(n - 4)) + 3/((n - 2)*n*factorial(n - 4))
            W[i] = (-n*(n-1)*(n-5)/6 - n*(n-1) - binomial(n-1,2))/(a)
        if u == Partition([n]):
            b = factorial(n-1)
            W[i] = (1/6*n*(n-1)-n*(n-1)*(n-5))/b
        if u == Partition([n-4,3,1]):
            c = 8*binomial(n,4)*factorial(n-5)
            W[i] = (n*(n-1) - binomial(n-1,2))/c
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
    for psi in Irr:
        #phi = psi.to_character()
        s = 0
        L = derangement_conjugacy_classes_representatives
        for i in range(len(L)):
            s += (1/psi.degree()) * ( W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
        eigenvalues.append(s)
        print (s,psi)
        if psi.degree() == 1:
            print s
    return eigenvalues,gap.Minimum(eigenvalues)

def alt_char(n):
    return [1]*n

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
#W = weighting(n)
#print W

#Alt = alt_char(n)
#print Alt
W = weights(n,[[n],[n-2,2]],[[n],[n-1,1]])
#W = weights(n,[[n-1,1],[n-2,2],[n-3,2,1]],[[n],[n-1,1],[n-2,1,1]]) #works for even
#W = weights(n,[[n-1,1],[n],[n-3,2,1]],[[n],[n-1,1],[n-2,1,1]]) #works for odd
G = SymmetricGroup(n)
L =  eigenvalues_weights(n,W[1])
#U = list(L)
#var('r7')
#r7 = solve(L[0][0] == 0,r7)[0].rhs()
print L[0],gap.Minimum(L[0])#,L[1], n*(n-1) -1,type(L[0][0])

"""sage: def intersecting(F):
....:     for x in F:
....:         for y in F:
....:             a = 'intersecting'
....:             print x,y
....:             for i in range(n):
....:                 if x(i) == y(i):
....:                     a = 'intersecting'
....:                     break
....:                 else:
....:                     a = 'not-intersecting'
....:                     pass
....:             if a == 'intersecting':
....:                 pass
....:             else:
....:                 print (x,y)
....:                 return False
....:     return True
....:
sage: def is_derangement(x):  # for 2 intersecting
....:     if len(Permutation(x).fixed_points()) <= 0:
....:           return True
....:     else:
....:         return False
....:                         """
