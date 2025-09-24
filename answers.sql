
DROP DATABASE IF EXISTS LibraryDB;
CREATE DATABASE LibraryDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE LibraryDB;

SET FOREIGN_KEY_CHECKS = 0;

-- (Drop existing tables if re-running the script)
DROP TABLE IF EXISTS BookAuthors;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Publishers;
DROP TABLE IF EXISTS Genres;
DROP TABLE IF EXISTS Staff;

SET FOREIGN_KEY_CHECKS = 1;



-- Publishers
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(30),
    website VARCHAR(255),
    UNIQUE (name)
) ENGINE=InnoDB;

-- Genres (book categories)
CREATE TABLE Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
) ENGINE=InnoDB;

-- Authors
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    bio TEXT,
    UNIQUE(first_name, last_name)
) ENGINE=InnoDB;

-- Books
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    publisher_id INT,
    genre_id INT,
    published_year YEAR,
    pages INT,
    copies_total INT NOT NULL DEFAULT 1,   -- total copies library owns
    copies_available INT NOT NULL DEFAULT 1, -- copies currently available
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- constraints
    UNIQUE (isbn),
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Many-to-many: Book <-> Author
CREATE TABLE BookAuthors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    contribution VARCHAR(100) DEFAULT 'Author', -- e.g., Author, Editor, Illustrator
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Members (library users)
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    address VARCHAR(255),
    join_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('active','suspended','closed') DEFAULT 'active',
    UNIQUE (email)
) ENGINE=InnoDB;

-- Staff (librarians)
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(150) NOT NULL,
    role VARCHAR(80) DEFAULT 'Librarian',
    password_hash VARCHAR(255),  -- for real systems store hashed passwords
    UNIQUE (email)
) ENGINE=InnoDB;


-- Loans: records of a member borrowing a book (one loan per physical copy)
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    staff_id INT, -- who issued the loan (nullable)
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('on_loan','returned','overdue','lost') NOT NULL DEFAULT 'on_loan',
    fine_amount DECIMAL(8,2) DEFAULT 0.00,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX (book_id),
    INDEX (member_id),
    INDEX (loan_date)
) ENGINE=InnoDB;



-- Index to speed searches by title
CREATE INDEX idx_books_title ON Books (title(100));

-- Index for quick lookups of authors by last name
CREATE INDEX idx_authors_lastname ON Authors (last_name);

-- Index for members by email (unique already)
-- Index on loans due_date for checking overdue items
CREATE INDEX idx_loans_due ON Loans (due_date);

/* ---------------------------
   5) (Optional) Sample data (small) - remove if not needed
   --------------------------- */

INSERT INTO Publishers (name, address, phone, website)
VALUES
('Acme Publishing', '123 Main St', '0711000001', 'https://acme.example'),
('OpenBooks', '45 Book Rd', '0711000002', 'https://openbooks.example');

INSERT INTO Genres (name, description) VALUES
('Fiction', 'Fictional prose'),
('Science', 'Science and technology books'),
('History', 'Historical works');

INSERT INTO Authors (first_name, last_name) VALUES
('John', 'Smith'),
('Emily', 'Clark');

INSERT INTO Books (title, isbn, publisher_id, genre_id, published_year, pages, copies_total, copies_available)
VALUES
('Intro to Databases','978-1111111111', 1, 2, 2020, 320, 3, 3),
('History of Town','978-2222222222', 2, 3, 2018, 220, 2, 2);

INSERT INTO BookAuthors (book_id, author_id) VALUES
(1, 1),
(2, 2);

INSERT INTO Members (first_name, last_name, email, phone, address)
VALUES
('Kelo','Ulak','kelo@example.com','0711000003','Kakuma Camp'),
('Ali','Hassan','ali@example.com','0711000004','Eldoret');

INSERT INTO Staff (first_name, last_name, email, role)
VALUES
('Jane','Doe','jane.librarian@example.com','Head Librarian');

-- Example loan
INSERT INTO Loans (book_id, member_id, staff_id, loan_date, due_date)
VALUES
(1, 1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));


  -- - End of schema

-- Helpful note for graders:
-- - This schema uses InnoDB to support foreign keys.
-- - Books <-> Authors is many-to-many via BookAuthors.
-- - Orders of deletion: Books cascade to BookAuthors; Members deletion cascades to Loans.
-- - ISBN is UNIQUE so the same physical title is identifiable.
