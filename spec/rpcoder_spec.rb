# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RPCoder" do
  context do
    before do
      RPCoder.clear
      RPCoder.name_space = 'foo.bar'
      RPCoder.api_class_name = 'API'
      RPCoder.function "getMail" do |f|
        f.path        = "/mails/:id" # => ("/mails/" + id)
        f.description = 'get mail'
        f.method      = "GET"
        f.add_return_type :mail, "Mail"
        f.add_param  :id, :int
        f.add_param  :foo, :String, :expect => ["A","B"]
        f.add_param  :bar, :Array
        f.add_param  :baz, :Boolean, :description => "日本の文字"
      end

      RPCoder.function "getMails" do |f|
        f.path        = "/mails/"
        f.description = 'get mails'
        f.method      = "GET"
        f.add_return_type :mails, "Mail", {:array? => true}
        f.add_return_type :count, "int"
      end

      RPCoder.type "Mail" do |t|
        t.add_field :subject, :String
        t.add_field :body,    :String
      end
    end

    it { RPCoder.functions.size.should == 2 }

    it { RPCoder.types.size.should == 1 }

    it 'should render_functions' do
      expected = File.read(File.expand_path('fixtures/foo/bar/API.as', File.dirname(__FILE__)))
      RPCoder.render_functions.should == expected
    end

    it 'should render_type' do
      expected = File.read(File.expand_path('fixtures/foo/bar/Mail.as', File.dirname(__FILE__)))
      RPCoder.render_type(RPCoder.types.first).should == expected
    end

    it 'dir_to_export_classes のテスト' do
      RPCoder.dir_to_export_classes('src').should == "src/foo/bar"
    end
  end
end
