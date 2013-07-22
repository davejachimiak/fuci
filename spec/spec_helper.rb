require 'minitest/spec/expect'
require 'mocha/setup'

def stub_class klass
  objects = klass.split '::'

  klass = objects.inject(Object) do |memo, obj|
    unless obj == objects.last
      begin
        memo.const_get obj
      rescue
        memo.const_set obj, Module.new
      end
    else
      begin
        memo.const_get obj
      rescue
        memo.const_set obj, Class.new
      end
    end

    memo.const_get obj
  end

  klass.class_eval do
    yield if block_given?
  end
end
