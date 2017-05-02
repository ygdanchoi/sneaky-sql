require_relative 'db_connection'

module Searchable
  def where(params)
    where_statements = params.keys.map { |attr_name| "#{attr_name} = ?" }
    where_statements = where_statements.join(" AND ")
    results = DBConnection.execute2(<<-SQL, params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_statements}
    SQL
    parse_all(results.drop(1))
  end
end
