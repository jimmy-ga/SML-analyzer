$indice = 0
class Lector
	@@abc = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
	@@lista_ns = ['1','2','3','4','5','6','7','8','9','0','+','-','/','*']
	
	def initialize(lista,str) #constructor que tiene el codigo y lista con variables
		@lista = lista
		@str = str
	end

	def self.buscar_n(str)
		for i in @@lista_ns
			if str==i
				return true
			end
		end
		false
	end

	def self.buscar_abc(str)
		for i in @@abc
			if str==i
				return true
			end
		end
		false
	end

	def encuentra_strings(codigo,variable) #Saca los strings
		variable = variable + codigo[$indice]
		$indice = $indice + 1
		while codigo[$indice]!="'" and codigo[$indice]!= '"' do #Concatena los strings
			variable = variable + codigo[$indice]
			$indice = $indice + 1
		end
		variable = variable + codigo[$indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
		$indice = $indice + 1
		variable
	end

	def encuentra_tuplas_listas(codigo,variable)
		num_parentesis = 0
		if codigo[$indice] == '[' or codigo[$indice] == '('
			num_parentesis = num_parentesis + 1
		end
		variable = variable + codigo[$indice]
		$indice = $indice + 1
		while codigo[$indice]!="]" and codigo[$indice]!= ')' do #Concatena las listas y tuplas
			if codigo[$indice] == '[' or codigo[$indice] == '('
				num_parentesis = num_parentesis + 1
			end
			variable = variable + codigo[$indice]
			$indice = $indice + 1
		end
		while num_parentesis > 0 do
			if codigo[$indice] == ']' or codigo[$indice] == ')'
				num_parentesis = num_parentesis - 1
			elsif codigo[$indice] == '[' or codigo[$indice] == '('
				num_parentesis = num_parentesis + 1
			end
			variable = variable + codigo[$indice]
			$indice = $indice + 1
		end
		variable = variable + codigo[$indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
		$indice = $indice + 1
		variable
	end

	def encuentra_int_float(codigo,variable)
		while not Lector.buscar_abc(codigo[$indice]) do
			variable = variable + codigo[$indice]
			$indice = $indice + 1
		end
		variable
	end

	def busca_variables() #Busca todas las variables de un codigo y las mete en el atributo lista
		codigo = @str #@str es el codigo SML que contiene el objeto
		variable = '' #aqui se almacena la varible temporalmente para despues meterla a la lista
		largo_str = codigo.length #largo del codigo restante
		while largo_str > 0 and codigo.index('var') do  #codigo.index determina si existe el string "var", si existe devuelve el indice donde se encuentra, sino devuelve nil
			$indice = codigo.index('var')					   #el primer while recorre todo el codigo en busca de var
			num_espacios = 0 #variable para determinar
			while codigo[$indice] != nil and num_espacios < 4 do #este while va aumentando el indice y concatena hasta terminar de leer la variable
				if codigo[$indice]=="'" or codigo[$indice]== '"' #Para encontrar los valores de los strings
					variable = encuentra_strings(codigo,variable)
					break
				elsif codigo[$indice]=="[" or codigo[$indice]== '(' #Para encontrar los valores de las listas y tuplas
					variable = encuentra_tuplas_listas(codigo,variable)
					break
				elsif (codigo[$indice]+codigo[$indice+1]+codigo[$indice+2])=="let"
					variable = variable + codigo[$indice]+codigo[$indice+1]+codigo[$indice+2]
					$indice = $indice + 3
					while (codigo[$indice]+codigo[$indice+1]+codigo[$indice+2])!="end" do
						variable = variable + codigo[$indice]
						$indice = $indice + 1
					end
					variable = variable + codigo[$indice]
					$indice = $indice + 1
					break
				elsif Lector.buscar_n(codigo[$indice])
					variable = encuentra_int_float(codigo,variable)
					break
				end
				variable = variable + codigo[$indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
				$indice = $indice + 1
				if codigo[$indice] == ' '
					num_espacios = num_espacios + 1
				end
			end
			codigo = codigo.slice($indice..codigo.length) #corta el codigo ya utilizado para no volverlo a usar, ya que no se ocupa
			largo_str = codigo.length #largo del codigo restante
			@lista = @lista + [variable] #concatena la variable con el resto de la lista
			variable = '' #La variable se vuelve a poner vacia
		end
		puts @lista
	end
end

class Separador
	def initialize(variable,tipo,valor,str) #Constructor para crear un objeto que tenga la variable, valor, tipo. Esto para facilitar la construccion de la tabla
		@variable = variable
		@valor = valor
		@tipo = tipo
	end
end

#Es un ejemplo de codigo => "fun x(lista:int list) = var x = 9 var y = 10"
a = Lector.new(["Estas son la variables"],"fun x(lista:int list) = var r = 5 + 2.8989 /34 -099676 + 576567 var largo_lisp = (((5,6),(987,354)),((76,32),(5654,456))) let if x == 1 end var y = 'Hola mundo' var z = True var n = [1,2,3] if x>3")
a.busca_variables()