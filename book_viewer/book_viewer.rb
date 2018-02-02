require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

helpers do
  def in_paragraphs(string)
    "<p>" + string.gsub("\n\n", "</p><p>") + "</p>"
  end
end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = 'The Adventures of Sherlock Holmes'

  erb(:home)
end

get "/chapters/:number" do
  number = params['number'].to_i
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{params['number']}.txt")

  erb(:chapter)
end

not_found do
  redirect '/'
end
