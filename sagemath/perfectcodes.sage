#!/usr/local/bin/sage

import random

def test(G,H):
    i = 0
    L = []
    for x in G:
        if x not in H:
            L.append(x)
    for g in L:
        if test_property(g,H) == True:
            i += 1
            pass
        else:
            #print g
            return False
    return True

def test_property(g,H):
    M = [g*i for i in H]
    for x in M:
        if x.order() == 2 or x^2 not in H:
            return True
        else:
            pass
    return False

def perfect_codes(G):
    M = G.conjugacy_classes_subgroups()
    L = []
    for x in M:
        if test(G,x) == True:
            L.append(x)
        else:
            pass
    return L,len(M)-len(L)

def is_inverse_closed(S):
    for x in S:
        if x.inverse() in S:
            pass
        else:
            return False
    return True

def find_transversal(G,H):
    C = G.cosets(H)
    S = []
    for x in C:
        S.append(x[random.choice(range(len(H)))])
    while is_inverse_closed(S) == False:
        S = []
        for x in C:
            S.append(x[random.choice(range(len(H)))])
    return [S[i] for i in range(1,len(S))]

def draw_graphs(G,H):
    S = find_transversal(G,H)
    X = Graph(G.cayley_graph(generators = S))
    T = []
    for x in G:
        if x not in H:
            T.append(x)
    return T,X{"red":H.list(),"green":T}



def latex_table(content, caption, label, header_rows = 1, header_columns = 0, position = 'htb'):
    code = """\\begin{table}[%s]
    \\centering
    \\caption{\\label{tab:%s} %s}
    """ % (position, label, caption)
    code += '\\begin{tabular}{|%s|} \\hline\n' % '|'.join('c' for i in range(len(content[0])))
    bold_format = '\\textbf{%s}'

    for line_no, line in enumerate(content):
        row_format_string = bold_format if line_no < header_rows else '%s'
        code += '        ' + ' & '.join([(bold_format if column_no < header_columns else row_format_string ) % i for column_no,i in enumerate(line)]) + ' \\\\ \\hline \n'
    code += '    \\end{tabular}\n\end{table}\n'
    return code


def Phi(G,H):
    a = 0
    for g in G:
        if g^2 in H:
            for x in [g*h for h in H]:
                if x.order() == 2:
                    a = 1
            if a == 0:
                return False
            else:
                pass
    return True

def test_perfect_codes(X,S,T):
    for x in T:
        i = 0
        for y in S:
            if X.distance(x,y) == 1:
                i += 1
                if i > 1:
                    return False
                else:
                    pass
    return True

def perfect_subset_codes(X,S):
    V = X.vertices()
    T = []
    for x in V:
        if x in S:
            pass
        else:
            T.append(x)
    return test_perfect_codes(X,S,T)
