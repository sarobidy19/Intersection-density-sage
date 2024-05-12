

class group_ekr():
	def __init__(self,G):
		self.description = G.structure_description
		self.information = [G,G.stabilizer(1)]
		self.irreducible_characters = G.irreducible_characters
		self.conjugacy_classes_representatives = G.conjugacy_classes_representatives
		self.conjugacy_class = G.conjugacy_class
		self.is_simple = G.is_simple
		self.order = G.order
		self.degree = G.degree 
		self.cayley_graph = G.cayley_graph
		self.conjugacy_classes_subgroups = G.conjugacy_classes_subgroups
		self.orbits = G.orbits
		self.orbit = G.orbit 
		self.stabilizer = G.stabilizer
		self.domain = G.domain
		self.list = G.list
	def stab_union(self):
		H = []
		for i in G.domain():
			H += G.stabilizer(i).list()
			K = set(H)
		return PermutationGroup(list(K))

	def eigenvalues_group(self):
	    IRR = self.irreducible_characters()
	    derangement_conjugacy_classes_representatives = []
	    eigenvalues = []
	    CC = self.conjugacy_classes_representatives()
	    for x in CC:
	        if is_derangement(x) == True:
	            derangement_conjugacy_classes_representatives.append(x)
	    for phi in IRR:
	        s = 0
	        for x in derangement_conjugacy_classes_representatives:
	            s += (1/phi.degree()) * ( self.conjugacy_class(x).cardinality()*phi(x) )
	        eigenvalues.append(s)
	    return list(eigenvalues),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)


	def eigenvalues_group_with_conjugacy_classes(self,C):
	    G = self
	    IRR = G.irreducible_characters()
	    derangement_conjugacy_classes_representatives = []
	    eigenvalues = []
	    CC = G.conjugacy_classes_representatives()
	    for x in CC:
	        if is_derangement(x) == True:
	            derangement_conjugacy_classes_representatives.append(x)
	    for phi in IRR:
	        s = 0
	        for x in derangement_conjugacy_classes_representatives:
	            for Y in C:
	                if x in Y:
	                    s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
	        eigenvalues.append(s)
	    return list(eigenvalues),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)

	def eigenvalues_group_with_dim(self):
	     G = self
	     IRR = G.irreducible_characters()
	     derangement_conjugacy_classes_representatives = []
	     eigenvalues = []
	     CC = G.conjugacy_classes_representatives()
	     for x in CC:
	         if is_derangement(x) == True:
	             derangement_conjugacy_classes_representatives.append(x)
	     for phi in IRR:
	         s = 0
	         for x in derangement_conjugacy_classes_representatives:
	             s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
	         eigenvalues.append((s,phi.degree()^2))
	     return list(eigenvalues)#,gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)

	def eigenvalues_group_with_all_dim(self):
	     G = self
	     IRR = self.irreducible_characters()
	     derangement_conjugacy_classes_representatives = []
	     eigenvalues = []
	     CC = G.conjugacy_classes_representatives()
	     for x in CC:
	         if is_derangement(x) == True:
	             derangement_conjugacy_classes_representatives.append(x)
	     for phi in IRR:
	         s = 0
	         for x in derangement_conjugacy_classes_representatives:
	             s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
	         eigenvalues.append((s,phi.degree()^2))
	     Eigenvalues = []
	     eigenvalue_set = list(set(eigenvalues_group(G)[0]))
	     for x in eigenvalue_set:
	         N = []
	         for y in eigenvalues:
	             if x == y[0]:
	                 N.append(y[1])
	             else:
	                 pass
	         Eigenvalues.append((x,sum(N)))

	     return Eigenvalues

	def regularity(G,F):
	    N = []
	    n = len(G.domain())
	    for i in range(1,n+1):
	        for j in range(1,n+1):
	            M = []
	            for x in F:
	                if x(i) == j:
	                    M.append(x)
	            N.append((i,j,len(M)))
	            print ((i,j,len(M)))
	    #return N

	def intersecting(G,F):
	     n = len(G.domain())
	     for x in F:
	         for y in F:
	             a = 'intersecting'
	             for i in range(1,n+1):
	                 if x(i) == y(i):
	                     a = 'intersecting'
	                     #print x,y,i
	                     break
	                 else:
	                     a = 'not-intersecting'
	                     pass
	             if a == 'intersecting':
	                 pass
	             else:
	                 #print (x,y)
	                 return False
	     return True

	def inertia_bound(G):
	     Ev = eigenvalues_group_with_all_dim(G)
	     p,n,z = 0,0,0
	     for x in Ev:
	         if int(x[0])<0:
	             n += x[1]
	         if int(x[0]) > 0:
	             p += x[1]
	         if int(x[0]) == 0:
	             z += x[1]
	     return min(z + n, z+p)

	def is_join(G):
	     Ev = eigenvalues_group(G)
	     return -Ev[1] + Ev[2] == G.order()

	def der_graph(G):
	    CC = G.conjugacy_classes_representatives()
	    D = []
	    for x in CC:
	        if is_derangement(x) == True:
	            D += G.conjugacy_class(x).list()
	    return Graph(G.cayley_graph(generators = D))

	def stabilizer_of_blocks(G,L):
	    N = []
	    Perms = []
	    L = G.blocks_all()[0]
	    L = G.orbit(tuple(L),"OnSets")
	    for x in L:
	        N.append(G.stabilizer(tuple(x),"OnSets"))
	    x = set(N[0])
	    for s in N:
	        x = set(s).intersection(x)
	    return PermutationGroup(list(x))

