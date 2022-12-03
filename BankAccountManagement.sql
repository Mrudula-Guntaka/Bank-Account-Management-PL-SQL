<---------------Bank Account Management System--------------->

/* ======================= CREATING TABLES ========================*/
CREATE TABLE BankAccount(
    account_number VARCHAR(10), 
    holder_name VARCHAR(30)
    dob DATE, 
    phone_number NUMBER(10),
    balance NUMBER(10),
    holder_address VARCHAR(50),
    holder_city VARCHAR(20),
    holder_postal VARCHAR(10),
    bank_branch VARCHAR(20)
);

CREATE TABLE AccountLoginDetails(
    account_number VARCHAR(10),
    username VARCHAR(20),
    passwrd VARCHAR(15)
);

/* ======================= INSERTING VALUES INTO TABLES ========================*/
INSERT INTO BankAccount VALUES ("178W1A05D1","Mrudula","25-02-2002",8688132653 , 25000, "Ganapavaram", "Vijayawada", "521230",  "Nuzividu");
INSERT INTO BankAccount VALUES ("178W1A05D2","Venkateswara Reddy","31-03-1979", 9985145183 , 70000, "Ganapavaram", "Vijayawada", "521230",  "Mylavaram");
INSERT INTO BankAccount VALUES ("178W1A05D3","Ramana","15-01-1978", 9581672767, 45000, "Mylavaram", "Vijayawada", "521230",  "Mylavaram");
INSERT INTO BankAccount VALUES ("178W1A05D4","Lakshmi Kantamma","01-01-1960", 709511289, 40000, "Vijayawada", "Vijayawada", "500030",  "Vijayawada");
INSERT INTO BankAccount VALUES ("178W1A05D5","Sai Pravallika","27-04-2000", 7993435789, 100000, "Ganapavaram", "Vijayawada", "521230",  "Nuzividu");
INSERT INTO BankAccount VALUES ("178W1A05D6","Pavan","22-09-2004",9441827127 , 25000, "KunchinaPalli", "Vijayawada", "500085",  "KunchinaPalli");
INSERT INTO BankAccount VALUES ("178W1A05D7","Pandu","07-04-2004", 9985296449, 25000, "Ibrahimpatnam", "Vijayawada", "501438",  "Ibrahimpatnam");
INSERT INTO BankAccount VALUES ("178W1A05D8","Mohith","29-08-2007", 9966967832, 20000, "KunchinaPalli", "Vijayawada", "500085",  "Nuzividu");
INSERT INTO BankAccount VALUES ("178W1A05D9","Chinuu","16-09-2009", 8330972615 , 30000, "Ibrahimpatnam", "Ibrahimpatnam", "501438",  "Ibrahimpatnam");
INSERT INTO BankAccount VALUES ("178W1A05E0","Shreyas Vardhan Reddy","26-12-2010",9966881212 , 40000, "Chirala", "Ongole", "580900",  "Chirala");
INSERT INTO BankAccount VALUES ("178W1A05E1","Chintu","07-11-1997", 855848393 , 50000, "Kothagudem", "Tiruvuru", "500230",  "Tiruvuru");


INSERT INTO AccountLoginDetails VALUES ("178W1A05D1", "mrudula25", "mrudula@25");
INSERT INTO AccountLoginDetails VALUES ("178W1A05D2", "venkateswara31", "venkateswara@31");
INSERT INTO AccountLoginDetails VALUES ("178W1A05D3", "ramana15", "ramana@15");
INSERT INTO AccountLoginDetails VALUES ("178W1A05D4", "lakshmi01", "lakshmi@01");
INSERT INTO AccountLoginDetails VALUES ("178W1A05D5", "pravallika05", "Pravallika@5");
INSERT INTO AccountLoginDetails VALUES ("178W1A05D6", "pavan22", "pavan@22");
INSERT INTO AccountLoginDetails VALUES ("178W1A05D7", "pandu04", "pandu@04");
INSERT INTO AccountLoginDetails VALUES ("178W1A05D8", "mohith29", "mohith@29");
INSERT INTO AccountLoginDetails VALUES ("178W1A05D9", "chinnu16", "chinnu@16");
INSERT INTO AccountLoginDetails VALUES ("178W1A05E0", "shreyas26", "shreyas@26");
INSERT INTO AccountLoginDetails VALUES ("178W1A05E1", "chintu07", "chintu@07");


/* ======================= PLSQL FUNCTIONS ========================*/

<---------- 1. USER REGISTRATION PROCEDURE---------->
CREATE OR REPLACE PROCEDURE registerUser()
AS 
    uname AccountLoginDetails.username%TYPE;
    user_password AccountLoginDetails.passwrd%TYPE;

    name BankAccount.holder_name%TYPE;
    dateofbirth BankAccount.dob%TYPE;
    phonenumber BankAccount.phone_number%TYPE;
    amount BankAccount.balance%TYPE;
    address BankAccount.holder_address%TYPE;
    city BankAccount.holder_city%TYPE;
    postal BankAccount.holder_postal%TYPE;
    branch BankAccount.bank_branch%TYPE;

BEGIN

    DBMS_OUTPUT.PUT_LINE("Choose a username with max 20 characters and no special characters");
    uname := &UserName;
    DBMS_OUTPUT.PUT_LINE("Create a password with max 15 characters");
    user_password := &Password;
    INSERT INTO AccountLoginDetails VALUES(SUBSTR(MD5(RAND()), 1, 10), uname, user_password);

    SELECT TOP ((SELECT COUNT(*) FROM AccountLoginDetails)-(1)) account_number INTO accountnumber FROM AccountLoginDetails;
    
    DBMS_OUTPUT.PUT_LINE("Please enter your details");

    name := &Name;
    dateofbirth := &DateOfBirth;
    phonenumber := &PhoneNumber;
    amount := &OpeningBalance;
    address := &Address;
    city := &City;
    postal := &PostalCode;
    branch:=&Branch;

    INSERT INTO BankAccount VALUES (accountnumber, name, dateofbirth, phonenumber, amount,address, city, postal, branch);
    DBMS_OUTPUT.PUT_LINE("Registration is successful");

END;

<---------- 2. USER LOGIN VALIDATION PROCEDURE---------->

CREATE OR REPLACE PROCEDURE loginValidation(accountnumber IN VARCHAR, uname IN VARCHAR, userpassword IN VARCHAR)
IS

  user_password AccountLoginDetails.passwrd%TYPE;
  incorrect_passwrd EXCEPTION;

BEGIN

  SELECT passwrd INTO password
  FROM AccountLoginDetails
  WHERE account_number LIKE accountnumber AND username LIKE uname  ;
  
  IF password LIKE userpasswrd THEN
    DBMS_OUTPUT.PUT_LINE('User ' || uname || ' has successfully logged in');

  ELSE
    RAISE incorrect_password;

  END IF;
  
EXCEPTION
  WHEN no_data_found OR incorrect_password THEN 
       DBMS_OUTPUT.PUT_LINE('OOPS!! Incorrect username or password. Please try again');
                                   
END;

/* PL/SQL block to perform operations on the balance amount */
SET SERVEROUTPUT ON;

DECLARE 
    option NUMBER;
BEGIN

    DBMS_OUTPUT.PUT_LINE('1.New User');
    DBMS_OUTPUT.PUT_LINE('2.Existing User');
    option := %Option;

    IF (option==1) THEN
        registerUser();

    ELSE IF(option==2) THEN 
        accountnumber AccountLoginDetails.account_number%TYPE:= &AccountNumber;
        username AccountLoginDetails.username%TYPE:= &username;
        userpassword AccountLoginDetails.passwrd%TYPE:= &Password;
        loginValidation(accountnumber,username,userpassword);
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('Something went wrong. Please choose correct option');
    END IF;

END;

/* PL/SQL block to register a new user or login the existing user */
SET SERVEROUTPUT ON;

DECLARE 
    option NUMBER;
    accountnumber BankAccount.account_number%TYPE;

BEGIN

    DBMS_OUTPUT.PUT_LINE('1.Deposit');
    DBMS_OUTPUT.PUT_LINE('2.Withdraw');
    DBMS_OUTPUT.PUT_LINE('3.View Account Balance');
    option := %Option;
    accountnumber:= &AccountNumber;

    SELECT balance INTO available_balance FROM BankAccount WHERE account_number=accountnumber ; 

    IF (option==1) THEN
        deposit BankAccount.balance%TYPE := &DepositAmount;

        UPDATE BankAccount
        SET balance = balance+deposit
        WHERE account_number = accountnumber ; 

        available_balance := available_balance + deposit;
        DBMS_OUTPUT.PUT_LINE('Rs. '||deposit||' has been creadited to  your account');
        DBMS_OUTPUT.PUT_LINE('Your available balance is Rs. '||available_balance );

    ELSE IF(option==2) THEN
        Withdraw BankAccount.balance%TYPE := &WithdrawAmount;
        
        IF ( withdraw<=available_balance ) THEN
            UPDATE BankAccount
            SET balance = balance - withdraw;
            WHERE account_number = accountnumber ;
    
            available_balance := available_balance - withdraw;
            DBMS_OUTPUT.PUT_LINE('Rs. '||withdraw||' has been debited from your account');
            DBMS_OUTPUT.PUT_LINE('Your available balance is Rs.'||available_balance );
    
        ELSE
            DBMS_OUTPUT.PUT_LINE('Your withdraw amount is greater than balance');
            DBMS_OUTPUT.PUT_LINE('Your transaction failed');
            DBMS_OUTPUT.PUT_LINE('Your available balance is Rs.'||available_balance ); 
        END IF;

    ELSE IF(option==3) THEN

        DBMS_OUTPUT.PUT_LINE('Your Account Balance is Rs. '|| available_balance);

    ELSE 
        DBMS_OUTPUT.PUT_LINE('Something went wrong. Please choose correct option');
    END IF;

END;