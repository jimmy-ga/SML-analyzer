require 'rubygems'
require 'sinatra'
require 'haml' 

set :bind, '0.0.0.0'
#El index de la página
get "/" do
	haml :index
end

# Handle GET-request (Show the upload form)
get "/analizar" do
  haml :cargaArchivo
end

get "/resultados" do
	haml :resultados
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
  return "el archivo "+name+" ha sido cargado exitosamente"
end
