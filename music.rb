require_relative './lib/sql_object'

class Artist < SQLObject
  self.table_name = 'artists'
  self.finalize!
end

class Album < SQLObject
  self.table_name = 'albums'
  self.finalize!
end

class Track < SQLObject
  self.table_name = 'tracks'
  self.finalize!
end
