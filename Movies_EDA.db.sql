-- How many foreign keys does the “languagemap” table have?

SELECT COUNT(*) AS ForeignKeyCount
FROM pragma_foreign_key_list('languagemap');

-- How many movies exist that no longer use their original titles? 

SELECT COUNT(*) AS NonOriginalTitleCount
FROM movies
WHERE title <> original_title;

-- What is the most popular movie that was made after 01/01/2000 with a budget of more than $100 000 000?

SELECT title, release_date, budget, popularity
FROM movies
WHERE release_date > '2000-01-01'
  AND budget > 100000000
ORDER BY popularity DESC
LIMIT 1;

-- How many movies do not have English as their original language?

SELECT COUNT(*) AS NonEnglishMoviesCount
FROM movies
WHERE original_language <> 'en'
   OR original_language IS NULL;

--How many movies in the database were produced by Pixar Animation Studios?

SELECT production_company_id
FROM productioncompanies
WHERE production_company_name = 'Pixar Animation Studios';

-- How many movies contains at least one of the official South African Languages, Afrikaans or Zulu

SELECT COUNT(DISTINCT lm.movie_id) AS number_of_movies
FROM LanguageMap lm
WHERE lm.iso_639_1 IN ('af', 'zu');

-- How many times was the actress Cate Blanchett nominated for an Oscar?

SELECT COUNT(*) AS number_of_nominations
FROM Oscars
WHERE winner = 'Cate Blanchett';

--Which of the movies mentioned above is the most popular? (District 9,Blood Diamond, Tsotsi, Gangster's Paradise: Jerusalema)

SELECT title, popularity
FROM Movies
WHERE title IN ('District 9', 'Blood Diamond', 'Tsotsi', 'Gangster''s Paradise: Jerusalema')
ORDER BY popularity DESC
LIMIT 1;

--What would be the code to change the name of the language with the ‘zh’ iso code in the “language” table to ‘Chinese’? 

UPDATE languages
SET language_name = 'Chinese'
WHERE iso_639_1 = 'zh';

-- How many movies in the database have a runtime of over 120 minutes?

SELECT COUNT(*) AS number_of_movies
FROM Movies
WHERE runtime > 120;

-- Which genres have the most movies associated with them?

SELECT g.genre_name, COUNT(gm.movie_id) AS movie_count
FROM Genres g
JOIN GenreMap gm ON g.genre_id = gm.genre_id
GROUP BY g.genre_name
ORDER BY movie_count DESC;

-- What are the names of movies that won an Oscar in the year 2010?

SELECT DISTINCT o.film
FROM Oscars o
WHERE o.year = 2010;

-- List the top 10 highest revenue movies along with their titles and revenues.

SELECT title, revenue
FROM Movies
ORDER BY revenue DESC
LIMIT 10;

-- Find the names of all actors who starred in the movie "Inception".

SELECT a.actor_name
FROM Actors a
JOIN Casts c ON a.actor_id = c.actor_id
JOIN Movies m ON c.movie_id = m.movie_id
WHERE m.title = 'Inception';

-- What are the average vote averages of movies released each year?

SELECT STRFTIME('%Y', release_date) AS release_year, AVG(vote_average) AS average_vote
FROM Movies
GROUP BY STRFTIME('%Y', release_date)
ORDER BY release_year;

--Which production company has produced the most movies?

SELECT pc.production_company_name, COUNT(pcm.movie_id) AS movie_count
FROM ProductionCompanies pc
JOIN ProductionCompanyMap pcm ON pc.production_company_id = pcm.production_company_id
GROUP BY pc.production_company_name
ORDER BY movie_count DESC
LIMIT 1;

--What are the names and budgets of the movies with the highest budget in each genre?

SELECT g.genre_name, m.title, m.budget
FROM Genres g
JOIN GenreMap gm ON g.genre_id = gm.genre_id
JOIN Movies m ON gm.movie_id = m.movie_id
WHERE (g.genre_id, m.budget) IN (
    SELECT g2.genre_id, MAX(m2.budget)
    FROM Genres g2
    JOIN GenreMap gm2 ON g2.genre_id = gm2.genre_id
    JOIN Movies m2 ON gm2.movie_id = m2.movie_id
    GROUP BY g2.genre_id
)
ORDER BY g.genre_name;

-- Find the titles of movies that have a higher revenue than their budget.

SELECT title
FROM Movies
WHERE revenue > budget;

--What are the titles and vote averages of the top 5 most popular movies?

SELECT title, vote_average
FROM Movies
ORDER BY popularity DESC
LIMIT 5;
