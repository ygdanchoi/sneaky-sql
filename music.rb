require_relative './lib/sql_object'

class Artist < SQLObject
  self.table_name = 'artists'

  has_many :albums,
    class_name: 'Album',
    primary_key: :id,
    foreign_key: :artist_id

  has_many_through :tracks, :albums, :tracks

  finalize!
end

class Album < SQLObject
  self.table_name = 'albums'

  belongs_to :artist,
    class_name: 'Artist',
    primary_key: :id,
    foreign_key: :artist_id

  has_many :tracks,
    class_name: 'Track',
    primary_key: :id,
    foreign_key: :album_id

  finalize!
end

class Track < SQLObject
  self.table_name = 'tracks'

  belongs_to :album,
    class_name: 'Album',
    primary_key: :id,
    foreign_key: :album_id

  has_one_through :artist, :album, :artist

  finalize!
end
