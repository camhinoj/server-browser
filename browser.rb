require 'socket'
require 'json'

host = 'localhost'
port = 2000
path = "/index.html"

post_data = ''
puts "GET or POST?"
input = gets.chomp
if input == "GET"
	request = "GET /index.html HTTP/1.0\r\n\r\n"
else
	post_data = {:viking => {}}
	printf "Viking Name? "
	post_data[:viking][:name] = gets.chomp
	printf "Viking Email? "
	post_data[:viking][:email] = gets.chomp
	request_type = "POST /thanks.html HTTP/1.0\nContent-Length: #{post_data.size}\n"
	request = request_type + post_data.to_json + "\n"
end



socket = TCPSocket.open(host, port)
if post_data == ''
	socket.print(request)
else
	socket.print(request)
end
response = socket.read

#headers,body = response.split("\r\n\r\n", 2)
print response