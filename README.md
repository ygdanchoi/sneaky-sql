# SneakySQL

SneakySQL is an ORM (object-relational mapping) tool for SQLite3 written in Ruby and inspired by Ruby on Rails. `SQLObject` uses the SQLite and ActiveSupport gems to allow users to manipulate SQL tables using object-oriented programming techniques.

## SQLObject

### Key Features

Classes that extend `SQLObject` inherit the following ORM features:
- the `SQLObject::all` method will return an array of all database entries as `SQLObject`s
- the `SQLObject::first` method will return the first database entry as a `SQLObject`
- the `SQLObject::last` method will return the last database entry as a `SQLObject`
- the `SQLObject::find` method will return the `SQLObject` corresponding to the id
- the `SQLObject::where` method will return an array of all database entries matching a query hash as a `SQLObject`
- the `SQLObject#initialize` method will allow the user to initialize an instance of `SQLObject` using a params hash
- the `SQLObject#save` method will either insert or update the row in the SQL table corresponding to the current `SQLObject`
- the `SQLObject#belongs_to` method will create an association returning `SQLObject`s for entries containing a corresponding primary key
- the `SQLObject#has_many` method will create an association returning `SQLObject`s for entries containing a corresponding foreign key
- the `SQLObject#has_one_through` method will create an association returning `SQLObject`s for a belongs_to association through a belongs_to association
- the `SQLObject#has_many_through` method will create an association returning `SQLObject`s for a has_many association through a has_many association

### Example Usage

```ruby
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
```

## Loading the Example Database
1. `git clone https://github.com/ygdanchoi/sneaky-sql`
2. `cd sneaky-sql`
3. `bundle install`
4. `pry -r './music.rb'`
5. Check out `Artist`, `Album`, and `Track`
