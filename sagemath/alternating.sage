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
        #print AlternatingGroup(n).conjugacy_classes_representatives()
        for x in AlternatingGroup(n).conjugacy_classes_representatives():
            if x.cycle_type() == F:
                CC_size.append([AlternatingGroup(n).conjugacy_class(x).cardinality(),x])
                break
            else:
                pass
    char = [SymmetricGroupRepresentation(M[i]).to_character().restrict(AlternatingGroup(n)) for i in range(m)]
    print CC_size
    for chi in char:
        phi = chi
        t = 0
        for i in range(m):
            t += V[i]*phi(CC_size[i][1])*CC_size[i][0]
            print V[i],phi(CC_size[i][1]),CC_size[i][1].cycle_type()
        if phi.values() == [1]*len(AlternatingGroup(n).conjugacy_classes_representatives()):
            print "YESSSSSSS"
            Eq.append(t == (n-1))  ######## maximum eigenvalue
        else:
            Eq.append(t == -phi.degree())
        Sol = solve(Eq,V)
    print "Weight possible?", len(Sol) != 0
    if len(Sol) == 0:
        return sys.exit()
##################################################################
    G = AlternatingGroup(n)
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

def eigenvalues_weights(n,W):
    eigenvalues = []
    G = AlternatingGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    print "length",len(CC)
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
#    print derangement_conjugacy_classes_representatives
    Irr = G.irreducible_characters()#
    #for f in Irr:
    #    print f.values()
    #print "----------------------------------------------"
    #Irr = SymmetricGroupRepresentations(n)
    for psi in Irr:
        #phi = psi.to_character()
        s = 0
        L = derangement_conjugacy_classes_representatives
        for i in range(len(L)):
            if L[i].cycle_type() == [n] or L[i].cycle_type() == [n-3,3]: #if conjugacy class splits
                #print "yes"
                #print (1/psi.degree()) * ( 1/2*W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
                s += (1/psi.degree()) * ( 1/2*W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
            else:
                s += (1/psi.degree()) * ( W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
                #print (1/psi.degree()) * ( W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
        eigenvalues.append(s)
        print (s,psi.degree())
        #if psi.degree() == 1:
        #    print "degree 1",s
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
#W = weights(n,[[n],[n-1,1],[n-2,2],[n-3,2,1]],[[n],[n-1,1],[n-2,2],[n-2,1,1]])
W = weights(n,[[n-2,2],[n-3,3]],[[n],[n-1,1]]) #works for even
#W = weights(n,[[n],[n-4,2,2]],[[n],[n-1,1]]) #works for odd
G = AlternatingGroup(n)
L =  eigenvalues_weights(n,W[1])
#U = list(L)
#var('r7')
#r7 = solve(L[0][0] == 0,r7)[0].rhs()
print L[0],gap.Minimum(L[0])#,L[1], n*(n-1) -1,type(L[0][0])
