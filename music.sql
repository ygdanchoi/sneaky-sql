CREATE TABLE artists (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE albums (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  artist_id INTEGER NOT NULL,
  FOREIGN KEY(artist_id) REFERENCES artist(id)
);

CREATE TABLE tracks (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  album_id INTEGER NOT NULL,
  FOREIGN KEY(album_id) REFERENCES album(id)
);

INSERT INTO
  artists (id, name)
VALUES
  (1, "Coldplay"),
  (2, "Kanye West");

INSERT INTO
  albums (id, title, artist_id)
VALUES
  (1, "Mylo Xyloto", 1),
  (2, "Graduation", 2);

INSERT INTO
  tracks (id, title, album_id)
VALUES
  (1, "Mylo Xyloto", 1),
  (2, "Hurts Like Heaven", 1),
  (3, "Paradise", 1),
  (4, "Charlie Brown", 1),
  (5, "Us Against THe World", 1),
  (6, "M.M.I.X.", 1),
  (7, "Every Teardrop Is A Waterfall", 1),
  (8, "Major Minus", 1),
  (9, "U.F.O.", 1),
  (10, "Princess Of China", 1),
  (11, "Up In Flames", 1),
  (12, "A Hopeful Transmission", 1),
  (13, "Don't Let It Break Your Heart", 1),
  (14, "Up With The Birds", 1);
