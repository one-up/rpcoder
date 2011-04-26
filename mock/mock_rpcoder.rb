#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
require 'rpcoder'
require 'fileutils'

#######################################
# API definition
#######################################

RPCoder.name_space = 'com.oneup.rpcoder.mock'
RPCoder.api_class_name = 'API'

RPCoder.type "Mail" do |t|
  t.add_field :subject, :String
  t.add_field :body,    :String
end

RPCoder.function "getMail" do |f|
  f.path        = "/mails/:id" # => ("/mails/" + id)
  f.method      = "GET"
  f.set_return_type "Mail"
  f.add_param  :id, "int"
  f.description = 'メールを取得'
end

RPCoder.function "sendMail" do |f|
  f.path        = "/mails" # => ("/mails/" + id)
  f.method      = "POST"
  f.set_return_type "void"
  f.add_param  :subject, "String"
  f.add_param  :body,    "String"
  f.description = 'メールを送信'
end

RPCoder.function "getError" do |f|
  f.path        = "/error/:statusCode"
  f.method      = "GET"
  f.set_return_type "void"
  f.add_param  :statusCode, :int
  f.description = 'Get Error'
end

dir = File.expand_path('src', File.dirname(__FILE__))
RPCoder.export(dir)
