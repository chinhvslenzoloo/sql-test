-- use workbench;
-- CREATE TABLE Products (
--     product_id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(255) NOT NULL,
--     price DECIMAL(10, 2) NOT NULL CHECK (price >= 10000), -- үнэ нь 10,000₮-өөс багагүй
--     category VARCHAR(255),
--     stock_quantity INT NOT NULL
-- );

-- -- Users хүснэгт
-- CREATE TABLE Users (
--     user_id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(255) NOT NULL,
--     email VARCHAR(255) NOT NULL,
--     phone_number VARCHAR(15)
-- );

-- -- Orders хүснэгт
-- CREATE TABLE Orders (
--     order_id INT AUTO_INCREMENT PRIMARY KEY,
--     user_id INT,
--     order_date DATE NOT NULL,
--     total_price DECIMAL(10, 2) NOT NULL,
--     FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
-- );

-- -- Order_Details хүснэгт
-- CREATE TABLE Order_Details (
--     order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
--     order_id INT,
--     product_id INT,
--     quantity INT NOT NULL,
--     FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
--     FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
-- );

-- Products хүснэгтэд өгөгдөл оруулах
-- INSERT INTO Products (name, price, category, stock_quantity)
-- VALUES 
-- ('Product 1', 15000, 'Category A', 100),
-- ('Product 2', 25000, 'Category B', 50),
-- ('Product 3', 12000, 'Category A', 75),
-- ('Product 4', 20000, 'Category C', 30),
-- ('Product 5', 30000, 'Category B', 20);

-- -- Users хүснэгтэд өгөгдөл оруулах
-- INSERT INTO Users (name, email, phone_number)
-- VALUES 
-- ('User 1', 'user1@example.com', '1234567890'),
-- ('User 2', 'user2@example.com', '0987654321'),
-- ('User 3', 'user3@example.com', '1122334455');

-- -- Orders хүснэгтэд 1 захиалга оруулах
-- INSERT INTO Orders (user_id, order_date, total_price)
-- VALUES 
-- (1, '2024-12-05', 45000);

-- -- Order_Details хүснэгтэд 2 бараа оруулах
-- INSERT INTO Order_Details (order_id, product_id, quantity)
-- VALUES 
-- (1, 1, 2), -- Product 1, quantity 2
-- (1, 2, 1); -- Product 2, quantity 1

-- Бүх бүтээгдэхүүний нэр болон үнэ
-- SELECT name, price FROM Products;


-- SELECT P.name, O.total_price
-- FROM Order_Details OD
-- JOIN Products P ON OD.product_id = P.product_id
-- JOIN Orders O ON OD.order_id = O.order_id
-- WHERE O.order_id = 1;


-- SELECT U.name, COUNT(O.order_id) AS total_orders, SUM(O.total_price) AS total_spent
-- FROM Users U
-- JOIN Orders O ON U.user_id = O.user_id
-- GROUP BY U.user_id;

-- order_summary view үүсгэх
-- CREATE VIEW order_summary AS
-- SELECT O.order_id, U.name AS user_name, O.order_date, O.total_price, P.name AS product_name, OD.quantity
-- FROM Orders O
-- JOIN Users U ON O.user_id = U.user_id
-- JOIN Order_Details OD ON O.order_id = OD.order_id
-- JOIN Products P ON OD.product_id = P.product_id;

-- Products хүснэгтийн stock_quantity баганын утгыг өөрчлөх
-- UPDATE Products
-- SET stock_quantity = stock_quantity - 1
-- WHERE product_id = 1;

-- -- Захиалгын барааг устгах
-- DELETE FROM Order_Details
-- WHERE order_detail_id = 1;

-- suppliers хүснэгт үүсгэх
-- CREATE TABLE Suppliers (
--     supplier_id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(255),
--     contact_email VARCHAR(255)
-- );

-- Бараа нийлүүлэгчтэй холбох
-- CREATE TABLE Product_Suppliers (
--     product_id INT,
--     supplier_id INT,
--     FOREIGN KEY (product_id) REFERENCES Products(product_id),
--     FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
-- );

-- -- Холбоотой өгөгдөл оруулах
-- INSERT INTO Suppliers (name, contact_email)
-- VALUES ('Supplier 1', 'supplier1@example.com'),
--        ('Supplier 2', 'supplier2@example.com');

-- INSERT INTO Product_Suppliers (product_id, supplier_id)
-- VALUES (1, 1), (2, 2), (3, 1);

-- supplier_product_summary view үүсгэх
-- CREATE VIEW supplier_product_summary AS
-- SELECT S.name AS supplier_name, P.name AS product_name, P.category
-- FROM Product_Suppliers PS
-- JOIN Suppliers S ON PS.supplier_id = S.supplier_id
-- JOIN Products P ON PS.product_id = P.product_id;

-- Барааны үлдэгдэл 0 болсон эсвэл хугацаа хэтэрсэн бүтээгдэхүүнийг устгах
--  DELETE FROM Products WHERE stock_quantity = 0; 
-- 100,000₮-өөс дээш үнэтэй бүх бүтээгдэхүүн
-- SELECT * FROM Products WHERE price >= 100000;

-- -- @gmail.com хаягтай хэрэглэгчид
-- SELECT * FROM Users WHERE email LIKE '%@gmail.com';

-- Захиалгад хамгийн их бараа багтсан хэрэглэгчийн нэрийг ол
-- SELECT name
-- FROM Users
-- WHERE user_id = (
--     SELECT user_id
--     FROM Orders
--     JOIN Order_Details ON Orders.order_id = Order_Details.order_id
--     GROUP BY Orders.user_id
--     ORDER BY COUNT(Order_Details.product_id) DESC
--     LIMIT 1
-- );

-- -- Хамгийн их бараа зарагдсан категориудыг ол
-- SELECT category, SUM(OD.quantity) AS total_quantity
-- FROM Order_Details OD
-- JOIN Products P ON OD.product_id = P.product_id
-- GROUP BY P.category
-- ORDER BY total_quantity DESC;

-- Бүтээгдэхүүний үнэнд доод хязгаарлалт тогтоох
-- ALTER TABLE Products ADD CONSTRAINT price_check CHECK (price >= 10000);

-- Бүх хэрэглэгчийн захиалсан нийт барааны тоо, захиалгын огноогоор нь жагсаах тайлан
-- SELECT U.name, O.order_date, SUM(OD.quantity) AS total_items
-- FROM Users U
-- JOIN Orders O ON U.user_id = O.user_id
-- JOIN Order_Details OD ON O.order_id = OD.order_id
-- GROUP BY O.order_id
-- ORDER BY O.order_date;

-- Барааны төрөл болон тоо хэмжээний мэдээллийг тусгайлан агуулсан хүснэгт үүсгэж өгөгдлийг хуул
-- CREATE TABLE Product_Categories AS
-- SELECT category, SUM(stock_quantity) AS total_quantity
-- FROM Products
-- GROUP BY category;-- 

-- Хэрэглэгчдийн хамгийн сүүлд хийсэн захиалга
-- SELECT U.name, MAX(O.order_date) AS last_order_date
-- FROM Users U
-- JOIN Orders O ON U.user_id = O.user_id
-- GROUP BY U.user_id;

-- -- Нийт хамгийн их борлуулалттай бараа
-- SELECT P.name, SUM(OD.quantity) AS total_sold
-- FROM Order_Details OD
-- JOIN Products P ON OD.product_id = P.product_id
-- GROUP BY OD.product_id
-- ORDER BY total_sold DESC
-- LIMIT 1;









