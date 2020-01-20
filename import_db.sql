DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE users
(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions
(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows
(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (question_id) REFERENCES questions (id)
);

CREATE TABLE replies
(
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    subject_question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (subject_question_id) REFERENCES questions (id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies (id),
    FOREIGN KEY (author_id) REFERENCES users (id)
);

CREATE TABLE question_likes
(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (question_id) REFERENCES questions (id)
);

INSERT INTO
  users (fname, lname)
VALUES
    ('Jimmy', 'Garappolo'),
    ('Thomas', 'Brady'),
    ('Brady', 'Quinn');

INSERT INTO
  questions (title, body, author_id)
VALUES
    ('Jimmy Question', 'football 1', (SELECT id FROM users WHERE fname = 'Jimmy' AND lname = 'Garappolo')),
    ('Tommy Question', 'football 2', (SELECT id FROM users WHERE fname = 'Thomas' AND lname = 'Brady')),
    ('Brady Question', 'football 3', (SELECT id FROM users WHERE fname = 'Brady' AND lname = 'Quinn'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Jimmy' AND lname = 'Garappolo'), (SELECT id FROM questions WHERE title = 'Jimmy Question')),
    ((SELECT id FROM users WHERE fname = 'Thomas' AND lname = 'Brady'), (SELECT id FROM questions WHERE title = 'Tommy Question'));

INSERT INTO
  replies (body, subject_question_id, parent_reply_id, author_id)
VALUES
    ('this question sucks', (SELECT id FROM questions WHERE title = 'Jimmy Question'), NULL, (SELECT id FROM users WHERE fname = 'Thomas' AND lname = 'Brady'));

INSERT INTO
  question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Brady' AND lname = 'Quinn'), (SELECT id FROM questions WHERE title = 'Jimmy Question'));