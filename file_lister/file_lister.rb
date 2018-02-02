require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"


get "/" do
  # @files = Dir.glob("public/*").map {|file| File.basename(file) }.sort
  # ^ would still need to filter out directories here
  @files = Dir.entries("./public").select do |file|
    !File.directory?("./public/#{file}") && !file.start_with?(".")
  end.sort
  @files.reverse! if params[:sort] == "desc"
  erb(:home)
end
