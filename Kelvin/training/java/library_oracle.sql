-- drop tables if they exist already

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE transactions';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE books';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE users';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

-- library tables
CREATE TABLE books (
    id NUMBER PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    author VARCHAR2(200) NOT NULL,
    is_issued NUMBER(1) DEFAULT 0 NOT NULL
);

CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(200) NOT NULL
);

-- transaction = which book issued to who
CREATE TABLE transactions (
    book_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    CONSTRAINT fk_transactions_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_transactions_user FOREIGN KEY (user_id) REFERENCES users(id)
);

COMMIT;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE transactions';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE books';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE users';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

-- tables for library system
CREATE TABLE books (
    id NUMBER PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    author VARCHAR2(200) NOT NULL,
    is_issued NUMBER(1) DEFAULT 0 NOT NULL
);

CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(200) NOT NULL
);

CREATE TABLE transactions (
    book_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    CONSTRAINT fk_transactions_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_transactions_user FOREIGN KEY (user_id) REFERENCES users(id)
);

COMMIT;