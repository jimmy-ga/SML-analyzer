require "calculus"

x="5"

exp = Calculus::Expression.new("x+var2+y")

lista = []
for var in exp.unbound_variables do
	lista=lista+[var]
end
listaVar=[["x",5],["var2",3],["y",10]]

contador = 0
while exp.unbound_variables != [] do
	contador2 =0
	while contador2<listaVar.length do
		if lista[contador]==listaVar[contador2][0]
			lista[contador]==listaVar[contador2][1]
		else
			contador2 = contador2+1
		end
	end
	contador = contador+1

end

puts exp.calculate


