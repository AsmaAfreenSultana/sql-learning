
CREATE TABLE customers (
    id              SERIAL PRIMARY KEY,
    name            TEXT NOT NULL,
    email           VARCHAR(255) UNIQUE NOT NULL,
    city            TEXT DEFAULT 'Prague',
    registered_date DATE DEFAULT current_date NOT NULL
);

CREATE TABLE sales (
    id          SERIAL PRIMARY KEY,
    book_id     INTEGER NOT NULL REFERENCES books(id),
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    quantity    INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    sale_date   DATE NOT NULL DEFAULT current_date,
    total_price NUMERIC(8, 2) NOT NULL CHECK (total_price > 0)
);