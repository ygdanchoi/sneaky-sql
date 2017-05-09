# SneakySQL

SneakySQL is an ORM (object-relational mapping) tool for SQLite3 written in Ruby and inspired by Ruby on Rails. `SQLObject` uses the SQLite and ActiveSupport gems to allow users to manipulate SQL tables using object-oriented programming techniques.

## Demo Instructions

### Cloud9
1. `pry -r './music.rb'`
2. Follow along below with `Artist`, `Album`, and `Track`

### Local Installation
1. `git clone https://github.com/ygdanchoi/sneaky-sql`
2. `cd sneaky-sql`
3. `bundle install`
4. `pry -r './music.rb'`
5. Follow along below with `Artist`, `Album`, and `Track`

## SQLObject

### Key Features & Usage

`SQLObject::finalize!` uses the class instance variable `table_name` to finalize a derived ORM model class
```ruby
require_relative './lib/sql_object'

class Artist < SQLObject
  self.table_name = 'artists'
  finalize!
end
```
`SQLObject::all` returns a mapped `SQLObject` array for all database entries
```ruby
> Artist.all
=> [#<Artist:0x007fffebdf1568 @attributes={:id=>1, :name=>"Coldplay"}>,
 #<Artist:0x007fffebdf13b0 @attributes={:id=>2, :name=>"Kanye West"}>]
```
`SQLObject::first` returns the first database entry mapped to `SQLObject`
```ruby
> Artist.first
=> #<Artist:0x007fffebd56838 @attributes={:id=>1, :name=>"Coldplay"}>
```
`SQLObject::last` returns the last database entry mapped to a `SQLObject`
```ruby
> Artist.last
=> #<Artist:0x007fffeb99b658 @attributes={:id=>2, :name=>"Kanye West"}>
```
`SQLObject::find` returns the `SQLObject` corresponding to a specific id
```ruby
> Album.find(2)
=> #<Album:0x007fffebf4e938 @attributes={:id=>2, :title=>"Graduation", :artist_id=>2}>
```
`SQLObject::where` returns a `SQLObject` array of for database entries matching a query hash
```ruby
> Album.where(title: "Graduation")
=> [#<Album:0x007fffebe11868 @attributes={:id=>2, :title=>"Graduation", :artist_id=>2}>]
```
`SQLObject#attributes` and `SQLObject#attribute_values` return arrays of the attributes and values in the database entry mapped to the `SQLObject` instance
```ruby
> Album.find(2).attributes
=> {:id=>2, :title=>"Graduation", :artist_id=>2}
> Album.find(2).attribute_values
=> [2, "Graduation", 2]
> Album.find(2).title
=> "Graduation"
```
`SQLObject#initialize` allows the user to initialize a new instance of `SQLObject` using a params hash
```ruby
> good_night = Track.new(track: 14, title: "Good Night", album_id: 2)
=> #<Track:0x007fffebd49638 @attributes={:track=>14, :title=>"Good Night", :album_id=>2}>
```
`SQLObject#save` either inserts or updates the database based on whether the `SQLObject` instance has an id
```ruby
> good_night.save
=> 28
> Track.find(28)
=> #<Track:0x007fffeb80d570 @attributes={:id=>28, :track=>14, :title=>"Good Night", :album_id=>2}>
```
`SQLObject::belongs_to` creates an association returning a `SQLObject` for entries containing a corresponding primary key
```ruby
class Album < SQLObject
  belongs_to :artist,
    class_name: 'Artist',
    primary_key: :id,
    foreign_key: :artist_id
end
```
```ruby
> graduation = Album.find(2)
=> #<Album:0x007fffebdbc188 @attributes={:id=>2, :title=>"Graduation", :artist_id=>2}>
> graduation.artist
=> #<Artist:0x007fffebd3d310 @attributes={:id=>2, :name=>"Kanye West"}>
```
`SQLObject::has_many` creates an association returning a `SQLObject` array for entries containing a corresponding foreign key
```ruby
class Album < SQLObject
  has_many :tracks,
    class_name: 'Track',
    primary_key: :id,
    foreign_key: :album_id
end
```
```ruby
> graduation.tracks.map { |track| track.title }
=> ["Good Morning", "Champion", "Stronger", "I Wonder", "Good Life (Feat. T-Pain)", "Can't Tell Me Nothing", "Barry Bonds (Feat. Lil Wayne)", "Drunk And Hot Girls (Feat. Mos Def)", "Flashing Lights (Feat. Dwele)", "Everything I Am (Feat. DJ Premier)", "The Glory", "Homecoming (Feat. Chris Martin)", "Big Brother"]
```
`SQLObject::has_one_through` creates an association returning a `SQLObject` for a `belongs_to` association through a `belongs_to` association
```ruby
class Track < SQLObject
  has_one_through :artist, :album, :artist
end
```
```ruby
> t = Track.first
=> #<Track:0x007fffebe15328 @attributes={:id=>1, :track=>1, :title=>"Mylo Xyloto", :album_id=>1}>
> t.artist
=> #<Artist:0x007fffebd93918 @attributes={:id=>1, :name=>"Coldplay"}>
```
`SQLObject::has_many_through` creates an association returning a `SQLObject` array for a `has_many` association through a `has_many` association
```ruby
class Artist < SQLObject
  has_many_through :tracks, :albums, :tracks
end
```
```ruby
> a = Artist.first
=> #<Artist:0x007fffebd37208 @attributes={:id=>1, :name=>"Coldplay"}>
> a.tracks.map { |track| track.title }
=> ["Mylo Xyloto", "Hurts Like Heaven", "Paradise", "Charlie Brown", "Us Against THe World", "M.M.I.X.", "Every Teardrop Is A Waterfall", "Major Minus", "U.F.O.", "Princess Of China", "Up In Flames", "A Hopeful Transmission", "Don't Let It Break Your Heart", "Up With The Birds"]
```
