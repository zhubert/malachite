module Malachite
  def self.function_cache
    @function_cache ||= {}
  end
  
  def self.from_function_cache(method_name)
    existing_function = Malachite.function_cache[method_name]
    return existing_function if existing_function.present?
    Malachite.add_to_function_cache(method_name)
  end

  def self.add_to_function_cache(method_name)
    @function_cache ||= {}
    function = fiddle_function(method_name)
    @function_cache[method_name] = function
    function
  end

  def self.dylib
    @dylib ||= open_dylib
  end


  def fiddle_function(method_name)
    Fiddle::Function.new(Malachite.dylib[called_method(method_name)], [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOIDP)
  end

  def called_method(method_name)
    "call#{method_name.to_s.camelize}"
  end

  def open_dylib
    Fiddle.dlopen(shared_object_path)
  rescue Fiddle::DLError
    raise Malachite::DLError, 'Unable to open dynamic library.'
  end

  def shared_object_path
    Malachite::Compiler.new.compile
  end

end
