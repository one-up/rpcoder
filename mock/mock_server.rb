#
# == Usage
#
#   $ ruby mock_server.rb
#

require 'sinatra'
require 'json'

get '/crossdomain.xml' do
  <<XML
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
<allow-access-from domain="*" />
</cross-domain-policy>
XML
end

get '/mails/:id' do
  puts "url: #{request.url}"
  puts "params: #{params.inspect}"
  {"id" => params[:id], "subject" => "hi", "body" => "hi, I'm ..."}.to_json
end

post '/mails' do
  puts "url: #{request.url}"
  puts "params: #{params.inspect}"
  {}.to_json
end

get '/error/:status_code' do
  halt params[:status_code].to_i, "Error[#{params[:status_code]}]"
end
