require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

# - the list of search results should be a list of paragraphs containing a
#   match.
# - each paragraph should be linked to the chapter containing the paragraph.
# - more specifically, we want to link to id attributes.

# for the search, it would seem to be useful to work with an array of paragraphs rather than a string. Or alternatively, we could split the paragraphed string on </p><p>.

# matching(query): this method should return:
# - a paragraph (for display)
# - a paragraph id (i.e., the running number of the paragraph) (for the link)
# - the file to which the paragraph belongs (for the link)

helpers do
  def in_paragraphs(string)
    string.split("\n\n").map.with_index do |paragraph, index|
      "<p id='#{index}'>" + paragraph + "</p>"
    end.join
  end
end

before do
  @contents = File.readlines("data/toc.txt")
end

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt").downcase
    yield(name, number, contents)
  end
end

def matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |name, number, contents|
    results << { name: name, number: number } if contents.match(query.downcase)
  end
  results
end

get "/search" do
  query = params[:query]
  @results = matching(query)
  erb(:search)
end


get "/" do
  puts @test || "@test is nil"

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
