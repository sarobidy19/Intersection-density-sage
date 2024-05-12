#!/usr/local/bin/sage

def t(i):
     return (i,i+1)

def f(i):
     return (i,i+1,i+2)

def g(i):
     return (i,i+2,i+1)

def cycle_small(i,k): # i = 1,2 or 3
    L = [3*j+i for j in range(k)]
    #M = [i +j for j in range(k)]
    return tuple(L)

def c(k):
    N = []
    w = ''
    for i in [1,2,3]:
        N.append(cycle_small(i,k))
    for x in N:
        w += "{0}".format(x)
    return w

def sigma(k):
    N = []
    w = ''
    L = [3*i+1 for i in range(k)]
    for i in range(len(L)-1):
        N.append(f(L[i]))
    for x in N:
        w += "{0}".format(x)
    return w

def tau(k):
    N = []
    w = ''
    L = [3*i+1 for i in range(k)]
    for i in range(len(L)):
        if i == len(L)-2:
            pass
        elif i == 0:
            N.append(f(L[i]))
        elif i == len(L)-1:
            N.append(f(L[i]))
        else:
            N.append(g(L[i]))
    for x in N:
        w += "{0}".format(x)
    return w

def mu(k):
    N = []
    w = ''
    L = [3*i+1 for i in range(k)]
    for i in range(len(L)):
        N.append(t(L[i]))
    for x in N:
        w += "{0}".format(x)
    return w

def group(k):
    return [sigma(k),tau(k),mu(k),c(k)]

def t(i,p):
     return (i,2*p+i)

Z = ['{0}{1}{2}{3}'.format(f(1),f(4),f(7),f(10)),'{0}{1}{2}{3}'.format(f(1),g(4),g(7),f(13)),'{0}{1}{2}{3}{4}'.format(t(1),t(4),t(7),t(10),t(13)),'{0}'.format(c(5))]
