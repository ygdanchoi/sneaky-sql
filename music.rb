require_relative './lib/sql_object'

class Artist < SQLObject
  self.table_name = 'artists'

  self.has_many :albums,
    class_name: 'Album',
    primary_key: :id,
    foreign_key: :artist_id

  self.has_many_through :tracks, :albums, :tracks

  self.finalize!
end

class Album < SQLObject
  self.table_name = 'albums'

  self.belongs_to :artist,
    class_name: 'Artist',
    primary_key: :id,
    foreign_key: :artist_id

  self.has_many :tracks,
    class_name: 'Track',
    primary_key: :id,
    foreign_key: :album_id

  self.finalize!
end

class Track < SQLObject
  self.table_name = 'tracks'

  self.belongs_to :album,
    class_name: 'Album',
    primary_key: :id,
    foreign_key: :album_id

  self.has_one_through :artist, :album, :artist

  self.finalize!
end
