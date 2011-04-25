# encoding: utf-8

module RPCoder
  describe "Function" do
    context do
      before do
        @function = Function.new
        @function.name        = "getMail"
        @function.description = "get a mail"
        @function.path         = "/mails/:id" # => ("/mails/" + id)
        @function.method      = "GET"
        @function.return_type = "Mail"
        @function.add_param  :id, :integer
        @function.add_param  :foo, :string, :expect => ["A","B"]
        @function.add_param  :bar, :array
        @function.add_param  :baz, :boolean, :decription => "日本の文字"
      end

      {
        '/mail/:id'              => ['"/mail/"', 'id'],
        '/mail/:id/foo'          => ['"/mail/"', 'id', '"/foo"'],
        '/mail/:mail_id/foo/:id' => ['"/mail/"', 'mail_id', '"/foo/"', 'id'],
        '/mail/:foo/:bar'        => ['"/mail/"', 'foo', '"/"', 'bar'],
      }.each do |path, path_parts|
        it "path が #{path} のとき path_parts が #{path_parts.inspect}" do
          @function.path = path
          @function.path_parts.should == path_parts
        end
      end

      {
        '/mail/:id'      => [:foo, :bar, :baz],
        '/mail/:foo/:id' => [:bar, :baz],
      }.each do |path, query_params|
        it "path が #{path} のとき query_params が #{query_params.inspect}" do
          @function.path = path
          @function.query_params.map { |i| i.name }.sort.should == query_params.sort
        end
      end

      [
        'foo/bar',
        ':foo/bar',
      ].each do |path|
        it "path が #{path} のとき invalid" do
          @function.path = path
          lambda { @function.path_parts }.should raise_error
        end
      end
    end
  end
end
