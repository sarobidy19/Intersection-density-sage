#!/usr/local/bin/sage

import numpy as np

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

def cayleygraph(G):
    X = G.cayley_graph(generators = get_derangements(G))
    X = Graph(X)
    return X


n,k = 8,2
X = graphs.KneserGraph(n,k)
X.relabel()
G = X.automorphism_group()
Y = cayleygraph(G)
print Y.clique_number(),binomial(n,k)
