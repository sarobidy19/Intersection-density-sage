#!/usr/local/bin/sage


def is_derangements(x,P):
    u = Permutation(x).cycle_type()
    for y in P:
        if is_submultiset(y,u) == True:
            return False
    return True

def is_submultiset(A,B):
    B = list(B)
    n = len(A)
    a = True
    i = 0
    while i<n and a == True:
        u = A[i]
        if u in B:
            B.remove(u)
        else:
            a = False
        i += 1
    return a
