
# This file was *autogenerated* from the file ./group_vs_der.sage
from sage.all_cmdline import *   # import sage library

_sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_6 = Integer(6)#!/usr/local/bin/sage

import matplotlib.pyplot as plt
import numpy as np

def get_derangements(G):
    D = []
    j = _sage_const_0  #count iteration (uncomment to show iteration)
    for x in G:
        listx = range(_sage_const_1 ,G.domain().cardinality())   #domain is the G-set
        i = np.random.choice(listx)                 #pick randomly an element to test
        a = 'true'
        while(len(listx) != _sage_const_0  and a == 'true'):     #list is nonempty and key (derangement) is true
            if x(i) == i:
                a = 'false'
            else:
                listx.remove(i)                     #remove the entry if not a derangement
                if len(listx) == _sage_const_0 :
                    break;
            i = np.random.choice(listx)
        if len(listx) == _sage_const_0 :
            D.append(x)
        else:
            pass
    print "derangements of group found ..."
    f = open("generator.txt",'w+')
    f.write('{0}'.format(D))
    f.close()
    return D

def cayleygraph(G):
      X = G.cayley_graph(generators = get_derangements(G))
      X = Graph(X)
      #show(X)
      #A =  X.adjacency_matrix()
      #print A.eigenvalues()
      print "Cayley graph of size",X.order()," done ..."
      Y = X.independent_set()
      print "Independent set of size",len(Y)," found ..."
      y = list(Y)[_sage_const_0 ]
      Z = [y.inverse()*i for i in Y]
      a ='False'
      #print G.domain()
      for i in G.domain():
          if set(G.stabilizer(i)) == set(Z):
              a = 'true'#,set(G.stabilizer(i)),Z
              break
          else:
              a = 'false'#,set(G.stabilizer(i)),Z
      return len(Z),G.stabilizer(G.domain()[_sage_const_1 ]).cardinality(),a#,X.clique_number(algorithm = "MILP")#,Z,G.group_id()#,a

X = graphs.KneserGraph(_sage_const_6 ,_sage_const_2 )
X.relabel()
G = X.automorphism_group()


print cayleygraph(G)
