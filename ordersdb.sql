--Create table Salesman
CREATE TABLE SALESMAN(
 SALESMAN_ID NUMBER(4),
 NAME VARCHAR(15),
 CITY VARCHAR(15),
 COMISSION NUMBER(7,2),
 CONSTRAINT PK_A PRIMARY KEY(SALESMAN_ID)
 );
 
 --Create table Customer
CREATE TABLE CUSTOMER(
 CUSTOMER_ID NUMBER(2),
 CUST_NAME VARCHAR(15),
 CITY VARCHAR(15),
 GRADE NUMBER(3),
 SALESMAN_ID NUMBER(4),
 CONSTRAINT PK_B PRIMARY KEY(CUSTOMER_ID),
 CONSTRAINT FK_D FOREIGN KEY(SALESMAN_ID) REFERENCES SALESMAN(SALESMAN_ID) ON DELETE SET NULL );
 
 --Create table Orders
CREATE TABLE ORDERS(
 ORD_NO NUMBER(4),
 PURCHASE_AMT NUMBER(10,2),
 ORD_DATE DATE,
 CUSTOMER_ID NUMBER(2),
 SALESMAN_ID NUMBER(4),
 CONSTRAINT PK_E PRIMARY KEY(ORD_NO),
 CONSTRAINT FK_G FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON DELETE SET NULL,
 CONSTRAINT FK_H FOREIGN KEY(SALESMAN_ID) REFERENCES SALESMAN(SALESMAN_ID) ON DELETE SET NULL );
 
 --Insert values into the respective tables
 INSERT INTO SALESMAN VALUES(&SALESMAN_ID,'&NAME','&CITY',&COMISSION);
 
 INSERT INTO CUSTOMER VALUES(&CUSTOMER_ID,'&CUST_NAME','&CITY',&GRADE,&SALESMAN_ID);
 
 INSERT INTO ORDERS VALUES(&ORD_NO,&PURCHASE_AMT,'&ORD_DATE',&CUSTOMER_ID,&SALESMAN_ID);
 

Q.1 Count the customers with grades above Bangalore’s average.
>SELECT COUNT(CUSTOMER_ID)
 FROM CUSTOMER
 WHERE GRADE>( SELECT AVG(GRADE)
               FROM CUSTOMER
               WHERE CITY='BANGALORE' );
               
Q.2 Find the name and numbers of all salesmen who had more than one customer.
>SELECT S.NAME,S.SALESMAN_ID
 FROM SALESMAN S,CUSTOMER C
 WHERE S.SALESMAN_ID=C.SALESMAN_ID
 GROUP BY S.NAME,S.SALESMAN_ID
 HAVING COUNT(C.CUSTOMER_ID)>1;

Q.3 List all salesmen and indicate those who have and don’t have customers in their cities. (Use UNION operation)
>(SELECT S.SALESMAN_ID,S.NAME,C.CUST_NAME
  FROM SALESMAN S,CUSTOMER C
  WHERE S.CITY=C.CITY AND S.SALESMAN_ID=C.SALESMAN_ID)
  UNION
 (SELECT S1.SALESMAN_ID,S1.NAME,'NO CUSTOMER'
  FROM SALESMAN S1,CUSTOMER C1
  WHERE S1.CITY!=C1.CITY AND S1.SALESMAN_ID=C1.SALESMAN_ID );
 
Q.4 Create a view that finds the salesman who has the customer with the highest order of a day.
>SELECT * FROM HIGH_ORDER_DAY H
 WHERE H.PURCHASE_AMT=(SELECT MAX(H1.PURCHASE_AMT)
                       FROM HIGH_ORDER_DAY H1
                       WHERE H1.ORD_DATE=H.ORDER_DATE);
                      
Q.5 Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted.
>DELETE FROM SALESMAN WHERE SALESMAN_ID=1000;
