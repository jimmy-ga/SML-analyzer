require 'rubygems'
require 'sinatra'
require 'haml' 

set :bind, '0.0.0.0'
#El index de la página
get "/" do
	haml :index
end

# Handle GET-request (Show the upload form)
get "/upload" do
  haml :upload
end

get "/resultados" do
	listaElem = [["X","3","int"],["S","3.45","float"],["tuplis","(5,7)","int*int"],["lista","[6,8,7,4,3]","int list"]]
  haml :resultados, :locals => {:resultados => listaElem}
end
    
# Handle POST-request (Receive and save the uploaded file)
post '/analizar' do
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    @error = "No file selected"
    #return haml(:upload)
  end
  STDERR.puts "Uploading file, original name #{name.inspect}"
  while blk = tmpfile.read(65536)
    # here you would write it to its final location
    STDERR.puts blk.inspect
  end
  "el archivo "+name+" ha sido cargado exitosamente"

end

# Handle POST-request (Receive and save the uploaded file)
post "/upload" do 
  File.open('uploads/' + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end
  name= params['myfile'][:filename]
  return "The file #{name}was successfully uploaded!"
end

