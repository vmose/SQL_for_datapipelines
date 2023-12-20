-- Given

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50)
);

INSERT INTO Orders (OrderID, ProductID, Quantity)
VALUES
    (1, 1, 10),
    (1, 2, 5),
    (2, 1, 8),
    (2, 3, 15),
    (3, 2, 20);

INSERT INTO Products (ProductID, ProductName)
VALUES
    (1, 'ProductA'),
    (2, 'ProductB'),
    (3, 'ProductC');


--query execution

DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);

-- Generate a comma-separated list of distinct ProductNames for dynamic pivot
SELECT @columns = COALESCE(@columns + ', ', '') + QUOTENAME(ProductName)
FROM Products;

-- Dynamic SQL for pivot
SET @sql = '
    SELECT *
    FROM (
        SELECT OrderID, ProductName, Quantity
        FROM Orders
        JOIN Products ON Orders.ProductID = Products.ProductID
    ) AS SourceTable
    PIVOT (
        SUM(Quantity)
        FOR ProductName IN (' + @columns + ')
    ) AS PivotTable;
';

-- Execute dynamic SQL
EXEC sp_executesql @sql;

