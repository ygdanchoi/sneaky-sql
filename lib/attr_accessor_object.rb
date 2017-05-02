class AttrAccessorObject
  def self.my_attr_accessor(*ivars)
    ivars.each do |ivar|
      at_ivar = "@#{ivar}".to_sym

      define_method(ivar) do
        instance_variable_get(at_ivar)
      end
    end
  end
end
