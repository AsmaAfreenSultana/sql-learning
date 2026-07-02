--Knihy a Kafe Bookshop Database
--Chapter 2: Initial data
--
--Run this after create-tables.sql
--Usage: psql -U postgres -d knihy_kafe -f insert-data.sql
--Authors
INSERT INTO authors (name, nationality, birth_year) VALUES
('Franz Kafka', 'Czech', 1883),
('Božena Němcová',  'Czech',    1820),
    ('Milan Kundera',   'Czech',    1929),
    ('Karel Čapek',     'Czech',    1890),
    ('Haruki Murakami', 'Japanese', 1949),
    ('George Orwell',   'British',  1903),
    ('Olga Tokarczuk',  'Polish',   1962),
    ('Umberto Eco',     'Italian',  1932);
-- Books
INSERT INTO books (title, author_id, genre, price, pages, published_date, original_language) VALUES
    ('The Trial',                              1, 'fiction', 289.00, 255, '1925-04-26', 'German'),
    ('The Metamorphosis',                      1, 'fiction', 199.00, 96,  '1915-10-01', 'German'),
    ('The Grandmother',                        2, 'fiction', 249.00, 320, '1855-01-01', 'Czech'),
    ('The Unbearable Lightness of Being',      3, 'fiction', 349.00, 314, '1984-01-01', 'French'),
    ('The Book of Laughter and Forgetting',    3, 'fiction', 319.00, 288, '1979-01-01', 'French'),
    ('War with the Newts',                     4, 'fiction', 279.00, 366, '1936-01-01', 'Czech'),
    ('R.U.R.',                                 4, 'fiction', 229.00, 104, '1920-01-25', 'Czech'),
    ('Norwegian Wood',                         5, 'fiction', 369.00, 296, '1987-09-04', 'Japanese'),
    ('Kafka on the Shore',                     5, 'fiction', 399.00, 505, '2002-09-12', 'Japanese'),
    ('1984',                                   6, 'fiction', 259.00, 328, '1949-06-08', 'English'),
    ('Animal Farm',                            6, 'fiction', 199.00, 112, '1945-08-17', 'English'),
    ('Flights',                                7, 'fiction', 329.00, 416, '2007-01-01', 'Polish'),
    ('The Name of the Rose',                   8, 'fiction', 389.00, 536, '1980-01-01', 'Italian'),
    ('Foucaults Pendulum',                     8, 'fiction', 359.00, 623, '1988-01-01', 'Italian');