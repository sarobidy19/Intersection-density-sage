#!/usr/local/bin/sage

import functions
import numpy as np

n,k = 5,2
X = graphs.KneserGraph(n,k)
X.relabel()
G = X.automorphism_group()
Y = functions.cayleygraph(G)

print Y.clique_number(),binomial()
