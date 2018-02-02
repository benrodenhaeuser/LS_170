require 'socket'

server = TCPServer.new("localhost", 3003)

def parse_request(request_line)
  request_method, url, version = request_line.split(' ')
  path, params = url.split('?')
  params = (params || "").split('&').map { |item| item.split('=') }.to_h

  [request_method, path, params]
end

loop do
  client = server.accept
  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  puts request_line

  request_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"

  client.puts "<pre>"
  client.puts request_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<!doctype html>"
  client.puts "<html>"
  client.puts "<body>"

  number = params["number"].to_i

  client.puts "<p>The current number is #{number}</p>"

  client.puts "<a href='?number=#{number + 1}'>increment<a>"

  client.puts "<a href='?number=#{number - 1}'>decrement<a>"


  client.puts "</body>"
  client.puts "</html>"

  client.close
end
