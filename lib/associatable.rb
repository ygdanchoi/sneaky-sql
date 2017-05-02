require_relative 'searchable'
require 'active_support/inflector'
require 'byebug'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.constantize.table_name
  end

  def merge_and_save!(defaults, options)
    defaults.merge!(options)
    @foreign_key = defaults[:foreign_key]
    @class_name  = defaults[:class_name]
    @primary_key = defaults[:primary_key]
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name}_id".underscore.to_sym,
      class_name:  "#{name}".camelcase,
      primary_key: :id
    }
    merge_and_save!(defaults, options)
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name}_id".underscore.to_sym,
      class_name:  "#{name}".singularize.camelcase,
      primary_key: :id
    }
    merge_and_save!(defaults, options)
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(name) do
      foreign_key_value = send(options.foreign_key)
      result = options.model_class
        .where({options.primary_key => foreign_key_value})
      result.first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    define_method(name) do
      primary_key_value = send(options.primary_key)
      result = options.model_class
        .where({options.foreign_key => primary_key_value})
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
