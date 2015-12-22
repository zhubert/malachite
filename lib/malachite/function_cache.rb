module Malachite
  def self.function_cache
    @function_cache ||= {}
  end

  def self.function_cache=(cache)
    @function_cache = cache
  end

  def self.from_function_cache(method_name)
    existing_function = Malachite.function_cache[method_name]
    return existing_function if existing_function.present?
    Malachite.add_to_function_cache(method_name)
  end

  def self.add_to_function_cache(method_name)
    function_cache = Malachite.function_cache
    function = Malachite.fiddle_function(method_name)
    function_cache[method_name] = function
    Malachite.function_cache = function_cache
    function
  end

  def self.dylib
    @dylib ||= Fiddle.dlopen(Malachite.shared_object_path)
  rescue Fiddle::DLError
    raise Malachite::DLError, 'Unable to open dynamic library.'
  end

  def self.fiddle_function(method_name)
    call_method = Malachite.called_method(method_name)
    Fiddle::Function.new(Malachite.dylib[call_method], [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOIDP)
  end

  def self.called_method(method_name)
    "call#{method_name.to_s.camelize}"
  end

  def self.shared_object_path
    @so_path ||= Malachite::Compiler.new.compile
  end
end
