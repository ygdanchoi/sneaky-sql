class AttrAccessorObject
  def self.my_attr_accessor(*ivars)
    ivars.each do |ivar|
      at_ivar = "@#{ivar}".to_sym

      define_method(ivar) do
        instance_variable_get(at_ivar)
      end

      define_method("#{ivar}=") do |val|
        instance_variable_set(at_ivar, val)
      end
    end
  end
end
