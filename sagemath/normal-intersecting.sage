#!/usr/local/bin/sage

def trivial_normal_intersecting(G):
    CC = G.conjugacy_classes()
    n = G.degree()
    F = []
    for x in CC:
        if len(Permutation(x[0]).fixed_points()) > ceil((n-1)/2):
            F = F + x.list()
    return F
