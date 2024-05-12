#!/usr/local/bin/sage

def point_stabilizer(G,S):
    T = [G.stabilizer(x) for x in S]
    u = T[0]
    for x in T:
        u = u.intersection(x)
    return u
