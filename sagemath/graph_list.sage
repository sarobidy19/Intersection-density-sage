#!/usr/local/bin/sage

def graph_list():
    LstJG = []
    for i in range(1,10):
        for j in range(2,9):
            LstJG.append(graphs.JohnsonGraph(i,j))

    LstCommonGraphs = [graphs.PapusGraph(),graphs.HeawoodGraph(),graphs.CoxeterGraph(),graphs.TutteCoxeterGraph,graphs.DodecahedralGraph()
    ,graphs.DesarguesGraph(),graphs.BiggsSmithGraph(),graphs.FosterGraph(),graphs.HoffmanSingletonGraph()]

    return LstJG + LstCommonGraphs
