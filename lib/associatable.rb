require_relative 'db_connection'
require_relative 'searchable'
require 'active_support/inflector'

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
    assoc_options[name] = options
    define_method(name) do
      primary_key_value = send(options.primary_key)
      result = options.model_class
        .where({options.foreign_key => primary_key_value})
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      id = self.send(through_options.foreign_key)
      results = DBConnection.execute2(<<-SQL, id)
        SELECT
          #{source_options.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
          #{source_options.table_name}
        ON
          #{through_options.table_name}.#{source_options.foreign_key} = #{source_options.table_name}.#{through_options.primary_key}
        WHERE
          #{through_options.table_name}.#{through_options.primary_key} = ?
      SQL
      parsed_results = source_options.model_class.parse_all(results.drop(1))
      parsed_results.first
    end
  end

  def has_many_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      id = self.send(source_options.primary_key)
      results = DBConnection.execute2(<<-SQL, id)
        SELECT
          #{source_options.table_name}.*
        FROM
          #{through_options.table_name}
        JOIN
          #{source_options.table_name}
        ON
          #{through_options.table_name}.#{through_options.primary_key} = #{source_options.table_name}.#{source_options.foreign_key}
        WHERE
          #{through_options.table_name}.#{through_options.primary_key} = ?
      SQL
      parsed_results = source_options.model_class.parse_all(results.drop(1))
      parsed_results
    end
  end
end
