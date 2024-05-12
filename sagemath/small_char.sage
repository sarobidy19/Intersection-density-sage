#!/usr/local/bin/sage

import sys

n = int(sys.argv[1])



def get_characters(k):
     IRR = SymmetricGroupRepresentations(k)
     chars = []
     for i in range(len(SymmetricGroup(k).conjugacy_classes())):
         g = IRR[i]
         if g.to_character().degree() < 2*binomial(k,2):
             chars.append(g)
     return chars

for x in get_characters(n):
    print x
