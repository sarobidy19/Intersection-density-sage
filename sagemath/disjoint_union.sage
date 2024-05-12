#!/usr/local/bin/sage

import numpy as np

def get_derangements(G):
    D = []
    j = 0 #count iteration (uncomment to show iteration)
    for x in G:
        listx = range(1,G.domain().cardinality())   #domain is the G-set
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
    print "derangements of group found ..."
    f = open("generator.txt",'w+')
    f.write('{0}'.format(D))
    f.close()
    return D

def test():
    G = graphs.CycleGraph(6).disjoint_union(graphs.CycleGraph(6))
    G.relabel()
    A = G.automorphism_group()
    D = get_derangements(A)
    #print D
    X = A.cayley_graph(generators = D)
    X = Graph(X)
    #print X.is_connected()
    Y = X.complement()
    Max = Y.cliques_maximum()
    #print A.order(),len(X.edges())-binomial(A.order(),2),len(Max)
    for S in Max:
        s = S[0]
        P = [i*s.inverse() for i in S]
        if PermutationGroup(P).order() != len(P):
            print P
    print "done"

test()
