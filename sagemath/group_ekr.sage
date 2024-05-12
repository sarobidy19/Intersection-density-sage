#!/usr/local/bin/sage

import numpy as np
import sys
from sage.groups.group import Group
import matplotlib.pyplot as plt

n = int(sys.argv[1])
#G = PermutationGroup(list(SymmetricGroup(n)))
#print G

def get_derangements(G):
    D = []
    j = 0 #count iteration (uncomment to show iteration)
    for x in G:
        listx = range(G.domain().cardinality())   #domain is the G-set
        i = np.random.choice(listx)                 #pick randomly an element to test
        a = 'true'
        while(len(listx) != 0 and a == 'true'):     #list is nonempty and key (derangement) is true
            if x(i) == i:
                a = 'false'
            else:
                listx.remove(i)                     #remove the entry if not a derangement
                if len(listx) == 0:
                    break;
            i = np.random.choice(listx)
        if len(listx) == 0:
            D.append(x)
        else:
            pass
        #j += 1
        #print j
    print "derangements of group found ..."
    f = open("generator.txt",'w+')
    f.write('{0}'.format(D))
    f.close()
    #print len(D)
    return D
#print get_derangements(G)

def cayleygraph(G):
    X = G.cayley_graph(generators = get_derangements(G))
    X = Graph(X)
    #A =  X.adjacency_matrix()
    #print A.eigenvalues()
    #print X.edges()
    print "Cayley graph of size",X.order()," done ..."
    Y = X.independent_set()
    print "Independent set of size",len(Y)," found ..."
    y = list(Y)[0]
    Z = [y.inverse()*i for i in Y]
    a ='False'
    #print G.domain()
    for i in G.domain():
        if set(G.stabilizer(i)) == Z:
            a = 'true'#,set(G.stabilizer(i)),Z
            break
        else:
            a = 'false'#,set(G.stabilizer(i)),Z
    return len(Z),G.stabilizer(G.domain()[1]).cardinality(),X.clique_number(algorithm = "MILP")#,Z,G.group_id()#,a


def HS():
    G = graphs.HigmanSimsGraph()
    A = G.automorphism_group()
    All = A.conjugacy_classes_subgroups()
    All.reverse()     #reverses the list
    for H in All:
        if H.order() == A.order()/2:
            f = open("HigmanSimsGroup.txt",'w+')
            HSG = H
            f.write('{0}'.format(HSG.gens()))
            f.close()
            break
        else:
            pass
    return HSG



#G = SymmetricGroup(n)
#G = MathieuGroup(12)
#Gr = DihedralGroup(7)
#X = Gr.cayley_graph(generators = [Gr[1],Gr[2],Gr[3]])
#X = Graph(X)
X = graphs.CycleGraph(3).disjoint_union(graphs.CycleGraph(3))
X.relabel()
G = X.automorphism_group()
#G = PermutationGroup(['(3,4)', '(2,3)(4,5)', '(1,2)(5,6)'])

print G.order(),G.is_transitive()#,X.is_connected()

print cayleygraph(G)#,"order",X.order()#,G.is_solvable(),G.is_simple()

#for H in G.conjugacy_classes_subgroups():
    #if H.order() == n:
#    if H.is_transitive() == (1==1):
#        print cayleygraph(H)#,"transitive ",
#    else:
#        pass
