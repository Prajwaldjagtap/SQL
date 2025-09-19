CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255),
    city VARCHAR(50),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    method VARCHAR(50),
    status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers (first_name, last_name, email, phone, address, city, country)
VALUES ('Alice', 'Johnson', 'alice@example.com', '1234567890', '123 Main St', 'Mumbai', 'India');

INSERT INTO Categories (category_name) VALUES ('Electronics'), ('Clothing');

INSERT INTO Products (name, description, price, stock_quantity, category_id)
VALUES ('Smartphone', 'Latest 5G smartphone', 30000.00, 50, 1),
       ('T-Shirt', 'Cotton round neck', 500.00, 200, 2);
       
       SELECT p.product_id, p.name, p.price, c.category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id;

INSERT INTO Orders (customer_id, status) VALUES (1, 'Pending');

INSERT INTO OrderItems (order_id, product_id, quantity, price)
VALUES (1, 1, 2, 30000.00), (1, 2, 3, 500.00);

SELECT o.order_id, SUM(oi.quantity * oi.price) AS total_amount
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.order_id = 1
GROUP BY o.order_id;

SELECT p.name, SUM(oi.quantity) AS total_sold
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC
LIMIT 5;

SELECT o.order_id, o.order_date, o.status, SUM(oi.quantity * oi.price) AS total_amount
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.customer_id = 1
GROUP BY o.order_id, o.order_date, o.status;