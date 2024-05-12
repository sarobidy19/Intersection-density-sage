#!/usr/local/bin/sage

import matplotlib.pyplot as plt
import numpy as np

def get_derangements(G):
    D = []
    j = 0 #count iteration (uncomment to show iteration)
    for x in G:
        listx = range(1,G.domain().cardinality()+1)   #domain is the G-set
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

def cayleygraph(G):
      X = G.cayley_graph(generators = get_derangements(G))
      X = Graph(X)
      #show(X)
      #A =  X.adjacency_matrix()
      #print A.eigenvalues()
      print "Cayley graph of size",X.order()," done ..."
      Y = X.independent_set()
      print "Independent set of size",len(Y)," found ..."
      y = list(Y)[0]
      Z = [y.inverse()*i for i in Y]
      a ='False'
      #print G.domain()
      for i in G.domain():
          if set(G.stabilizer(i)) == set(Z):
              a = 'true'#,set(G.stabilizer(i)),Z
              break
          else:
              a = 'false'#,set(G.stabilizer(i)),Z
      return len(Z),G.stabilizer(G.domain()[1]).cardinality(),a#,X.clique_number(algorithm = "MILP")#,Z,G.group_id()#,a

#X = graphs.KneserGraph(6,2)
#X.relabel()
#G = X.automorphism_group()


#print cayleygraph(G)
