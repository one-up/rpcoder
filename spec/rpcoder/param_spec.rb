# encoding: utf-8

module RPCoder
  describe "Param" do
    context do
      let(:param) { Param.new(:foo, 'int') }
      subject { param }
      it { subject.name.should == :foo }
      it { subject.type.should == 'int' }
      it { should_not be_array }
    end

    context do
      let(:param) { Param.new(:foo, 'int', {:array? => true}) }
      subject { param }
      it { should be_array }
    end

    context do
      it { Param.new(:foo, 'int').instance_creator.should == 'elem' }
      it { Param.new(:foo, 'Foo').instance_creator.should == 'new Foo(elem)' }
      it { Param.new(:foo, 'int').instance_creator('bar').should == 'bar' }
      it { Param.new(:foo, 'int').instance_creator('bar', {:object? => true}).should == "object['bar']" }
      it { Param.new(:foo, 'Foo').instance_creator('bar', {:object? => true}).should == "new Foo(object['bar'])" }
    end

  end
end

