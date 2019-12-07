--Create table Publisher
CREATE TABLE PUBLISHER(
	Name varchar(15),
	Address varchar(15),
	Phone number(3),
	CONSTRAINT PK_1 PRIMARY KEY(Name)
);

--Create table Book
CREATE TABLE BOOK(
	Book_id number(4),
	Title varchar(20),
	Publisher_Name varchar(15),
	Pub_year number(4),
	CONSTRAINT PK_2 PRIMARY KEY(Book_id),
	CONSTRAINT FK_1 FOREIGN KEY(Publisher_Name) REFERENCES PUBLISHER(Name) ON DELETE CASCADE
);

--Create table Library_branch
CREATE TABLE LIBRARY_BRANCH
(
	Branch_id Number(4),
	Branch_Name varchar(10),
	Address varchar(15),
	CONSTRAINT PK_3 PRIMARY KEY(Branch_id)
);

--Create table Book_authors.
CREATE TABLE BOOK_AUTHORS
(
	Book_id Number(4),
	Author_Name varchar(15),
	CONSTRAINT FK_2 FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE
);

--Create table Book_copies.
CREATE TABLE BOOK_COPIES
(
	Book_id number(4),
	Branch_id number(4),
	No_of_copies number(2),
	CONSTRAINT FK_3 FOREIGN KEY(Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id) ON DELETE CASCADE,
	CONSTRAINT FK_4 FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE
);

--Create table Book_lending.
CREATE TABLE BOOK_LENDING
(
	Book_id number(4),
	Branch_id number(4),
	Card_No number(2),
	Date_out date,
	CONSTRAINT FK_5 FOREIGN KEY(Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id) ON DELETE CASCADE,
	CONSTRAINT FK_6 FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE
);

--Insert values into respective tables
INSERT INTO PUBLISHER VALUES('&NAME','&ADDRESS',&PHONE);
 
INSERT INTO LIBRARY_BRANCH VALUES(&BRANCH_ID,'&BRANCH_NAME','&ADDRESS');

INSERT INTO BOOK VALUES(&BOOK_ID,'&TITLE','&PUBLISHER_NAME',&PUB_YEAR);

INSERT INTO BOOK_AUTHORS VALUES(&BOOK_ID,'&AUTHOR_NAME');

INSERT INTO BOOK_COPIES VALUES(&BOOK_ID,&BRANCH_ID,&NO_OF_COPIES);

INSERT INTO BOOK_LENDING VALUES(&BOOK_ID,&BRANCH_ID,&CARD_NO,'&DATE_OUT','&DUE_DATE');


Q.1 Retrieve  details  of  all  books  in  the  library –id,  title,  name  of  publisher,  authors, number of copies in each branch, etc.
>SELECTC.BRANCH_ID,L.BRANCH_NAME,B.BOOK_ID,B.TITLE,B.PUBLISHER_NAME,B.PUB_YEAR,A.AUTHOR_NAME,C.NO_OF_COPIES
 FROM BOOK B,BOOK_AUTHORS A,LIBRARY_BRANCH L,BOOK_COPIES C
 WHERE B.BOOK_ID=A.BOOK_ID 
 AND B.BOOK_ID=C.BOOK_ID
 AND L.BRANCH_ID=C.BRANCH_ID 
 AND (C.BRANCH_ID,C.BOOK_ID) IN
     (SELECT BRANCH_ID,BOOK_ID
      FROM BOOK_COPIES
      GROUP BY BRANCH_ID,BOOK_ID);

Q.2 Get the particulars of borrowers who have borrowed more than 3 books, but from Jan 2017 to Jun 2017.
>SELECT * FROM BOOK_LENDING
 WHERE DATE_OUT BETWEEN '01-JAN-17' AND '30-JUN-17' AND CARD_NO
 IN
 (SELECT CARD_NO FROM BOOK_LENDING
  GROUP BY CARD_NO
  HAVING COUNT(CARD_NO)>3);

Q.3 Delete  a  book  in  BOOK  table.  Update  the  contents  of  other  tables  to  reflect  this  data manipulation operation.
>DELETE FROM BOOK WHERE BOOK_ID=5555;

Q.4 Partition the BOOK table based on year of publication. Demonstrate its working with a simple query.
>CREATE VIEW YEAR AS 
 SELECT PUB_YEAR FROM BOOK;

SELECT * FROM YEAR;

Q.5 Create  a  view  of  all  books  and  its number  of copies  that  are  currently  available in  the Library.
> CREATE VIEW ALL_BOOK AS
  SELECT B.BOOK_ID,B.TITLE,C.NO_OF_COPIES,L.BRANCH_NAME
  FROM BOOK B,BOOK_COPIES C,LIBRARY_BRANCH L
  WHERE B.BOOK_ID=C.BOOK_ID
  AND L.BRANCH_ID=C.BRANCH_ID;
  
  SELECT * FROM ALL_BOOK;
