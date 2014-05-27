class Lector
	def initialize(variable,tipo,valor,str)
		@variable = variable
		@valor = valor
		@tipo = tipo
	end

	def initialize(lista,str)
		@lista = lista
		@str = str
	end

	def busca_variables(codigo)
		@str = codigo
		indice = 0
		variable = ''
		largo_str = codigo.length
		while largo_str > 0 and codigo.index('var') != nil do 
			indice = codigo.index('var')
			num_espacios = 0
			while codigo[indice] != nil and num_espacios < 4 do
				if codigo[indice]=="'" or codigo[indice]== '"' #Para encontrar los valores de los strings
					variable = variable + codigo[indice]
					indice = indice + 1
					while codigo[indice]!="'" and codigo[indice]!= '"' do
						variable = variable + codigo[indice]
						indice = indice + 1
					end
				elsif codigo[indice]=="[" or codigo[indice]== '(' #Para encontrar los valores de las listas y tuplas
					variable = variable + codigo[indice]
					indice = indice + 1
					while codigo[indice]!="]" and codigo[indice]!= ')' do
						variable = variable + codigo[indice]
						indice = indice + 1
					end
				end
				variable = variable + codigo[indice] #Para encontrar los valores de los integer y booleans
				indice = indice + 1
				if codigo[indice] == ' ' and (codigo[indice+1]!="*" or codigo[indice+1]!="/" or codigo[indice+1]!="-" or codigo[indice+1]!="+")
					num_espacios = num_espacios + 1
				end
			end
			codigo = codigo.slice(indice..codigo.length)
			largo_str = codigo.length
			@lista = @lista + [variable]
			variable = ''
		end
		puts @lista
	end
end
#Es un ejemplo"fun x(lista:int list) = var x = 9 var y = 10"
a = Lector.new(["Estas son la variables"],"")
b = a.busca_variables("fun x(lista:int list) = var x = (5,6) if x == 1 var y = 'Hola mundo' var z = True var n = [1,2,3]")