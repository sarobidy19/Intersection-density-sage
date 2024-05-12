#!/usr/local/bin/sage

def unique_intersection(G,F,x):
    i = 0
    for z in F:
        if z != x and is_derangement(x*z.inverse()) == True:
            i += 1
            if i >1:
                return False
            else:
                pass
    return True


def is_almost_intersecting(G,F):
    for x in F:
        if unique_intersection(G,F,x) == True:
            pass
        else:
            return False
    return True
