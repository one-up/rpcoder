# encoding: utf-8

require 'erb'
require 'rpcoder/function'
require 'rpcoder/type'

module RPCoder
  class << self
    def name_space=(name_space)
      @name_space = name_space
    end

    def name_space
      @name_space
    end

    def api_class_name=(name)
      @api_class_name = name
    end

    def api_class_name
      @api_class_name
    end

    def types
      @types ||= []
    end

    def type(name)
      type = Type.new
      type.name = name
      yield type
      types << type
      type
    end

    def functions
      @functions ||= []
    end

    def function(name)
      func = Function.new
      func.name = name
      yield func
      functions << func
      func
    end

    def export(dir)
      class_dir = dir_to_export_classes(dir)
      FileUtils.mkdir_p(class_dir)

      export_functions(File.join(class_dir, api_class_name.split('.').last + ".as"))
      types.each { |type| export_type(type, File.join(class_dir, "#{type.name}.as")) }
    end

    def export_functions(path)
      puts "API: #{path}"
      File.open(path, "w") { |file| file << render_functions }
    end

    def render_functions
      render_erb('API.erb', binding)
    end

    def export_type(type, path)
      puts "Type: #{path}"
      File.open(path, "w") { |file| file << render_type(type) }
    end

    def render_type(type)
      render_erb('Type.erb', binding)
    end

    def render_erb(template, _binding)
      ERB.new(File.read(template_path(template)), nil, '-').result(_binding)
    end

    def template_path(name)
      File.join File.dirname(__FILE__), 'templates', name
    end

    def dir_to_export_classes(dir)
      File.join(dir, *name_space.split('.'))
    end

    def clear
      functions.clear
      types.clear
    end
  end
end
