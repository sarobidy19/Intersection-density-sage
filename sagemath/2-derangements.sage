#!/usr/local/bin/sage

import sys

def is_2derangement(x):
    if len(Permutation(x).fixed_points()) <=2:
      #if 2 not in x.cycle_type():
      return True
    else:
      return False

def is_derangement(x):  # for 3 intersecting
          if len(Permutation(x).fixed_points()) >= 3:
              return False
          elif len(Permutation(x).fixed_points()) == 2:
              if 2 not in x.cycle_type() and 3 not in x.cycle_type():
                return True
              else:
                return False
          elif len(Permutation(x).fixed_points()) == 1:
              if 2 not in x.cycle_type() and 3 not in x.cycle_type():
                return True
              else:
                return False
          elif len(Permutation(x).fixed_points()) == 0:
              if 3 not in x.cycle_type():
                return True
              else:
                return False
          else:
              return False

def number_of_2derangements(n):
    G = SymmetricGroup(n)
    CC = G.conjugacy_classes_representatives()
    L = []
    s = 0
    for x in CC:
        if is_2derangement(x) == True:
            L.append(x)
    for x in L:
        s += len(G.conjugacy_class(x))
    return s

n = int(sys.argv[1])
print number_of_2derangements(n)
