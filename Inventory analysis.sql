# Most sold Top 3 productcode by sum of quantityordered

Select productcode , sum(quantityOrdered)
from mintclassics.orderdetails
group by productCode
order by sum(quantityOrdered) desc
limit 3 ;

# Which warehouse are the most sold products stored c,b,a

Select *
from mintclassics.products
where productcode in ( "S18_3232" , "S18_1342", "S700_4002");

# Least sold Top 3 productcode by sum of quantityordered

Select productcode , sum(quantityOrdered)
from mintclassics.orderdetails
group by productCode
order by sum(quantityOrdered) asc
limit 3 ;

# Which warehouse are the least sold products stored - b,b,c

Select *
from mintclassics.products
where productcode in ( "S18_4933" , "S24_1046", "S24_3969");

# what is stored in warehouse d 

Select *
from mintclassics.products
where warehousecode = "d" ;

Select sum(quantityInStock)
from mintclassics.products 
where warehousecode = "b" ;


# join to see all the productcodes and  the quantity  ordered from ORDERDETAILS table side by side with the quantity in stock from PRODUCTS table.

select products.productcode, products.quantityInStock,orderdetails.quantityOrdered
from products inner join orderdetails
on products.productCode = orderdetails.productCode;

# statment to see the distinct product codes with their quantity in stock and and sum of quantityo0rdered.(ALL PRODUCTS POSSIBLY PURCHASED)

select products.productcode, products.quantityInStock, sum(orderdetails.quantityOrdered) as orderquantity
from products inner join orderdetails
on products.productCode = orderdetails.productCode
group by products.productcode, products.quantityinstock
order by sum(orderdetails.quantityordered);

# same statment as above to see which warehouse is most used

select products.productcode, products.quantityInStock,products.warehousecode, sum(orderdetails.quantityOrdered) as orderquantity
from products inner join orderdetails
on products.productCode = orderdetails.productCode
where products.warehousecode = "d" 
group by products.productcode, products.quantityinstock, products.warehouseCode 
order by sum(orderdetails.quantityordered) desc ;

# Creating a table of the above join result so I can use it for further calculations

Create table Join_result
select products.productcode, products.quantityInStock,products.warehousecode, sum(orderdetails.quantityOrdered) as orderquantity
from products inner join orderdetails
on products.productCode = orderdetails.productCode
group by products.productcode, products.quantityinstock, products.warehouseCode 
order by sum(orderdetails.quantityordered) desc ;

# New table being used 

select *
from mintclassics.join_result;

# total quanity ordered and stored by each warehouse over the span of 3 years

Select warehousecode, sum(orderquantity) as total_ordered_quantity, sum(quantityInStock) as total_quantity_in_stock
from mintclassics.join_result
group by warehousecode
order by sum(orderquantity) desc;

# understand percentage of quantity in stock actually being used

Select warehousecode, sum(orderquantity) as total_ordered_quantity, 
sum(quantityInStock) as total_quantity_in_stock, (sum(orderquantity)/sum(quantityInStock)*100) as percentageused
from mintclassics.join_result
group by warehousecode
order by sum(orderquantity) desc;

# rough estimate to see what happens if we reduce inventory in stock by 50% 

Select warehousecode, 
sum(orderquantity) as total_ordered_quantity, 
sum(quantityInStock) as total_quantity_in_stock,
(sum(quantityInStock)/2) as halfofquantityinstock,
(sum(orderquantity)/sum(quantityInStock)*100) as percentageorginal,
(sum(orderquantity)/sum(quantityInStock/2)*100) as percentageafterreduction
from mintclassics.join_result
group by warehousecode
order by sum(orderquantity) desc;

# Many possibilites - warehouse b could be emptied entirely and could divided into the other warehouses,etc
