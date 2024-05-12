#!/usr/local/bin/sage

def eigenvalues_cycles(n,k):
     G = SymmetricGroup(n)
     CC = G.conjugacy_classes_representatives()
     for x in G:
         if x.cycle_type()[0] == k and x.cycle_type()[1] <= 1:
             y = x
             break
     print y.cycle_type()
     Irr = G.irreducible_characters()
     Ev = []
     for phi in Irr:
         s = phi(y)/phi(G[0])*len(G.conjugacy_class(y))
         Ev.append(s)
     return Ev
