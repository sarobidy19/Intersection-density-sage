def find_graphs(k):
	P = SetPartitions(2*k,[k,k])
	X = Graph()
	X.add_vertices(P)
	C = Combinations(P,2)
	E = []
	for x in C:
		if len(set(x[0][0].intersection(x[1][0]))) in [1,k-1]:
			E.append(tuple(x))
	X.add_edges(E)
	return X

import itertools
def double_cosets(n,H):
	G = SymmetricGroup(n)
	C = G.cosets(H)
	L = []
	T = Combinations(H,2)
	for K in C:
		A = []
		for x in T:
			A += [x[0]* K[0]*x[1]]
		L.append(sorted(A))
	L.sort()
	L = [list(set(x)) for x in L]
	E = sorted(L)
	I = [0..len(E)-1]
	L = list(L for L, _ in itertools.groupby(L))
	J = []
	while len(I)>0:
		i = I[0]
		U = []
		t = 0
		for j in I:
			if E[i] == E[j]:
				t +=1
				U.append(j)
		J.append((i,t))
		N = []
		for j in I:
			if j not in U:
				N.append(j)
		I = N 
	return [E[x[0]][0] for x in J],[x[1] for x in J]


def find_character_table(n,H):
	#O = H.orbits()
	G = SymmetricGroup(n)
	Irr = G.irreducible_characters()
	Lambda = ((H.trivial_character()).induct(G)).irreducible_constituents()
	T,L = double_cosets(n,H)
	E = []
	for phi in Lambda:
		V = []
		for i in range(len(T)):
			V.append(sum([L[i]/H.order()*phi(T[i]*h) for h in H]))
		E.append(V+[phi.degree()])
	return Matrix(E)


def guroby_association_scheme(n,H):
	V = VA(len(CC))
	Non_triv = []
	Labels = []
	for i in range(len(CC)):
          Labels.append((V[i],Permutation(CC[i][0]).cycle_type()))
	triv = H.trivial_character()
	psi = triv.induct(SymmetricGroup(n))
	Irr  = phi.irreducible_constituents()
	T,L = double_cosets(n,H)
	E = []
	for phi in Irr:
		V = []
		for i in range(len(T)):
			V.append(sum([L[i]/H.order()*phi(T[i]*h) for h in H]))
		E.append(sum(V),phi.degree())
