require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'
require 'active_support/inflector'

class SQLObject

  extend Searchable
  extend Associatable

  def self.table_name=(table_name)
    @table_name_override = table_name
  end

  def self.table_name
    @table_name_override || self.to_s.tableize
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        attributes[column]
      end
      define_method("#{column}=") do |val|
        attributes[column] = val
      end
    end
  end

  def self.columns
    @table_data ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    @table_data.first.map { |str| str.to_sym }
  end


  def self.all
    @table_data = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    parse_all(@table_data.drop(1))
  end

  def self.first
    @table_data = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      LIMIT
        1
    SQL
    parse_all(@table_data.drop(1)).first
  end

  def self.last
    @table_data = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      ORDER BY
        id DESC
      LIMIT
        1
    SQL
    parse_all(@table_data.drop(1)).last
  end

  def self.parse_all(results)
    results.inject([]) do |accumulator, entry|
      accumulator << self.new(entry)
    end
  end

  def self.find(id)
    table = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = #{id}
    SQL
    return nil if table.last.is_a?(Array)
    self.new(table.last)

  end

  def initialize(params = {})
    params.each do |attr_name, val|
      attr_name = attr_name.to_sym
      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end
      self.send("#{attr_name}=", val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |attr_name|
      self.send(attr_name)
    end
  end

  def insert
    columns = self.class.columns
    col_names = columns.join(", ")
    question_marks = (["?"] * columns.length).join(", ")
    DBConnection.execute2(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    columns = self.class.columns
    set_statements = self.class.columns.map do |attr_name|
      "#{attr_name} = ?"
    end
    set_statements = set_statements.drop(1).join(", ")
    DBConnection.execute2(<<-SQL, *attribute_values.drop(1), id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_statements}
      WHERE
        id = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
