-- 1) چند سفارش در مجموع ثبت شدهاست ؟
select sum(o.OrderID) sumOfOrders from orders o 
-- 2)درآمد حاصل از این سفارشها چقدر بوده است؟
select sum(od.Quantity*p.Price) incomeOfOrders from orderdetails od join products p on p.ProductID=od.ProductID
-- 3) 5 مشتری برتر را بر اساس مقداری که خرج کردهاند پیدا کنید. ) ID ، نام و مقدار خرج شده هر یک را
-- گزارش کنید (
with cust as(
select c.CustomerName, c.CustomerID, o.OrderID from customers c join orders o on c.CustomerID=o.CustomerID
),
ordcust as(
select ord.Quantity, ord.OrderID, ord.ProductID,cust.CustomerName cname, cust.CustomerID cid from orderdetails ord join cust on ord.OrderID=cust.OrderID
),
productprice as
 ( select ordcust.cname, ordcust.cid,p.Price*ordcust.Quantity buy from products p join ordcust on p.ProductID=ordcust.ProductID)
select * from productprice ORDER BY buy DESC LIMIT 5
--  4) میانگین هزین هی سفارشات هر مشتری را به همراه ID و نام او گزارش کنید. )به ترتیب نزولی نشان
-- دهید 
with cust as(
select c.CustomerName, c.CustomerID, o.OrderID from customers c join orders o on c.CustomerID=o.CustomerID
),
ordcust as(
select ord.Quantity, ord.OrderID, ord.ProductID,cust.CustomerName cname, cust.CustomerID cid from orderdetails ord join cust on ord.OrderID=cust.OrderID
),
productprice as
 ( select ordcust.cname, ordcust.cid,avg(p.Price*ordcust.Quantity) avgbuy from products p join ordcust on p.ProductID=ordcust.ProductID GROUP BY ordcust.cname, ordcust.cid)
select * from productprice ORDER BY avgbuy DESC
-- 5) مشتر یان را بر اساس مقدار کل هزینهی سفارشات رتبهبندی کنید، اما فقط مشتریا نی را در نظر
-- بگیرید که بیشتر از 5 سفارش دادهاند .
with cust as(
select c.CustomerName, c.CustomerID, o.OrderID from customers c join orders o on c.CustomerID=o.CustomerID
),
ordcust as(
select ord.Quantity quant, ord.OrderID ordid, ord.ProductID,cust.CustomerName cname, cust.CustomerID cid from orderdetails ord join cust on ord.OrderID=cust.OrderID
),
productprice as
 ( select ordcust.cname name, ordcust.cid id,count(ordcust.ordid) numberOfOrders from products p join ordcust on p.ProductID=ordcust.ProductID GROUP BY ordcust.cname, ordcust.cid HAVING COUNT(ordcust.ordid)>5)
 
 
select pd.name, pd.id,
CASE
    WHEN pd.numberOfOrders BETWEEN  6 and 10 THEN "Low"
    WHEN pd.numberOfOrders BETWEEN  11 and 20 THEN "Medium"
    ELSE "High"
END
FROM productprice pd;
get--6)کدام محصول در کل سفارشات ثبت شده بیشترین درآمد را ایجاد کرده است؟ (به همراه ID و نام
--گزارش کنید (.
with ordcust as(
select ord.Quantity quant, ord.OrderID ordid, ord.ProductID from orderdetails ord
),
productprice as
 ( select p.ProductName, p.ProductID, ordcust.quant*p.Price MaximumPrice from products p join ordcust on p.ProductID=ordcust.ProductID)
 
select * FROM productprice pd ORDER BY MaximumPrice DESC LIMIT 1
--7)هر دسته ) category ( چند محصول دارد؟ )به ترتیب نزولی نشان دهید (
SELECT c.CategoryName,count(p.ProductID) NumberOfProducts  from products p join categories c on p.CategoryID=c.CategoryID  GROUP BY c.CategoryName ORDER BY NumberOfProducts DESC
--8)محصول پرفروش در هر دسته بر اساس درآمد را تعیین کنید .
SELECT c.CategoryName, p.ProductName, MAX(p.TotalIncome) AS MaximumIncome
FROM Categories c
JOIN (
    SELECT p.ProductID, p.ProductName, SUM(od.Quantity * p.Price) AS TotalIncome
    FROM products p
    JOIN orderdetails od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
) p ON c.CategoryID = p.ProductID
GROUP BY c.CategoryName, p.ProductName
ORDER BY c.CategoryName;
--9)5کارمند برتر که بالاترین درآمد را ایجاد کردند به همراه ID و نام + ‘ ‘ + نام خانوادگی گزارش کنید .
select e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS FullName, SUM(od.Quantity * p.Price) As TotalSale
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
join OrderDetails od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY SUM(od.Quantity * p.Price) DESC LIMIT 5;
--10) میانگین درآمد هر کارمند به ازای هر سفارش چقدر بودهاست؟ )به ترتیب نزولی نشان دهید(
select  e.EmployeeID, AVG(od.Quantity * p.Price) AverageIncomePerOrder
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
join OrderDetails od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
GROUP BY e.EmployeeID
ORDER BY AverageIncomePerOrder DESC;
--11)کدام کشور بیشترین تعداد سفارشات را ثبت کرد هاست؟ )نام کشور را به همراه تعداد سفارشات
--گزارش کنید (
select Country, COUNT(o.OrderID) TotalOrders
from Customers
LEFT JOIN Orders o on Customers.CustomerID = o.CustomerID
GROUP BY Country
ORDER BY TotalOrders DESC
LIMIT 1;
--12)مجموع درآمد از سفارشات هر کشور چقدر بوده؟ (به همراه نام کشور و به ترتیب نزولی نشان دهید (.
select c.Country, SUM(o.OrderID) TotalIncome
from Customers c
left join Orders o on c.CustomerID = o.CustomerID
GROUP BY c.Country
ORDER BY TotalIncome DESC;
--13) میانگین قیمت هر دسته چقدر است؟ )به همراه نام دسته و به ترتیب نزولی گزارش کنید (
select c.CategoryName, AVG(p.Price) AveragePrice
from Categories c
join Products p on c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY AveragePrice DESC;
--14)گران ترین دسته بندی کدام است؟ )به همراه نام دسته گزارش کنید (
select c.CategoryName, MAX(p.Unit* p.Price) AS MostExpensivePrice
from Categories c
join Products p on c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY MostExpensivePrice DESC
LIMIT 1;
--15) طی سال 1996 هر ماه چند سفارش ثبت شد ه است؟
select MONTH(OrderDate) Month, COUNT(*) OrderCount
from Orders where OrderDate BETWEEN '1996-01-01' AND '1996-12-31'
GROUP BY MONTH(OrderDate) ORDER BY Month
--16) میانگین فاصل هی زمانی بین سفارشات هر مشتری چقدر بوده؟(به همراه نام مشتری و به صورت
--نزولی نشان دهید(
 
with OrderIntervals as (
    select
        c.CustomerName,
        DATEDIFF(OrderDate, LAG(OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY OrderDate)) AS TimeBetweenOrders
    from customers c
    join Orders o on c.CustomerID = o.CustomerID
)
select CustomerName, AVG(TimeBetweenOrders) AvgTimeBetweenOrders
from OrderIntervals
GROUP BY CustomerName
ORDER BY AvgTimeBetweenOrders DESC;
--17)
select 
    case 
        when MONTH(OrderDate) BETWEEN 3 AND 5 THEN 'Spring'
        when MONTH(OrderDate) BETWEEN 6 AND 8 THEN 'Summer'
        when MONTH(OrderDate) BETWEEN 9 AND 11 THEN 'Fall'
        else 'Winter'
    end Season,
    COUNT(*) TotalOrders
from Orders
where YEAR(OrderDate) = 1996
GROUP BY Season
ORDER BY TotalOrders DESC;
--18)  کدام تامین کننده بیشترین تعداد کالا را تامین کرده است؟ (به همراه نام و ID گزارش کنید (.
select s.SupplierID, s.SupplierName, COUNT(p.ProductID) TotalProducts
from Suppliers s join Products p on s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY TotalProducts DESC LIMIT 1;
--19) میانگین قیمت کالای تامین شده توسط هر تامیکننده چقدر بوده؟ )به همراه نام و ID و به صورت
--نزولی گزارش کنید (
select s.SupplierID, s.SupplierName, AVG(p.Price) AveragePrice
from Suppliers s
join Products p on s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName ORDER BY AveragePrice DESC;