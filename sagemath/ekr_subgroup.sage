#!/usr/bin/sage

import group_ekr

G = PermutationGroup(7)
for H in G.subgroups():
    cayleygraph(H)
    
