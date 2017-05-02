require_relative './lib/sql_object'

class Artist < SQLObject
  self.table_name = 'artists'
  self.finalize!

  self.has_many :albums,
    class_name: 'Album',
    primary_key: :id,
    foreign_key: :artist_id
end

class Album < SQLObject
  self.table_name = 'albums'
  self.finalize!

  self.belongs_to :artist,
    class_name: 'Artist',
    primary_key: :id,
    foreign_key: :artist_id
end

class Track < SQLObject
  self.table_name = 'tracks'
  self.finalize!
end
