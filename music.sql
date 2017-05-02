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
  track INTEGER,
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
  tracks (id, track, title, album_id)
VALUES
  (1, 1, "Mylo Xyloto", 1),
  (2, 2, "Hurts Like Heaven", 1),
  (3, 3, "Paradise", 1),
  (4, 4, "Charlie Brown", 1),
  (5, 5, "Us Against THe World", 1),
  (6, 6, "M.M.I.X.", 1),
  (7, 7, "Every Teardrop Is A Waterfall", 1),
  (8, 8, "Major Minus", 1),
  (9, 9, "U.F.O.", 1),
  (10, 10, "Princess Of China", 1),
  (11, 11, "Up In Flames", 1),
  (12, 12, "A Hopeful Transmission", 1),
  (13, 13, "Don't Let It Break Your Heart", 1),
  (14, 14, "Up With The Birds", 1),
  (15, 1, "Good Morning", 2),
  (16, 2, "Champion", 2),
  (17, 3, "Stronger", 2),
  (18, 4, "I Wonder", 2),
  (19, 5, "Good Life (Feat. T-Pain)", 2),
  (20, 6, "Can't Tell Me Nothing", 2),
  (21, 7, "Barry Bonds (Feat. Lil Wayne)", 2),
  (22, 8, "Drunk And Hot Girls (Feat. Mos Def)", 2),
  (23, 9, "Flashing Lights (Feat. Dwele)", 2),
  (24, 10, "Everything I Am (Feat. DJ Premier)", 2),
  (25, 11, "The Glory", 2),
  (26, 12, "Homecoming (Feat. Chris Martin)", 2),
  (27, 13, "Big Brother", 2);
