require 'socket'
require 'json'

server = TCPServer.open(2000)

loop {
	client = server.accept
	input = client.gets
	request_type = input.scan(/^[A-Z]+\b/).join('')
	path = input.scan(/\/[a-z]+.[a-z]+/).join('')
	version = input.scan(/[A-Z]+\/.+/).join('')
	if request_type == "GET"
		if File.exist?("."+path)
			client.puts(version.strip + " 200 OK")
			client.puts(Time.now.ctime)
			client.puts("Content-type: text/html")
			client.puts("Content-length: "+File.size("."+path).to_s)
			client.puts
			client.puts(File.read("."+path))
		else
			client.puts(version + "400 File does not Eixst")
		end
	else
		if File.exist?("."+path.to_s)
			params = nil 
			content_length = client.gets
			json_stuff = client.gets
			params = JSON.parse(json_stuff)
			thanks = File.read("."+path)
			ul = "<ul></ul>"
			params["viking"].each do |key, value|
				ul.insert(-5, "<li>#{key.to_s.capitalize}: #{value}</li>")
			end
			response = thanks.gsub(/<%= yield %>/, ul)
			client.puts(version.strip + " 200 OK")
			client.puts(Time.now.ctime)
			client.puts("Content-type: text/html")
			client.puts("Content-length: "+ response.size.to_s)
			client.puts(response)
		else
			client.puts(version.to_s + "400 File .#{path} does not exist")
		end
	end
	client.close
}