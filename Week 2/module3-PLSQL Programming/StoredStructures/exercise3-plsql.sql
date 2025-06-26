SET SERVEROUTPUT ON;
-- Cleanup existing objects
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Accounts';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Employees';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP PROCEDURE ProcessMonthlyInterest';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP PROCEDURE UpdateEmployeeBonus';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP PROCEDURE TransferFunds';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Create Accounts table
CREATE TABLE Accounts (
  AccountID NUMBER PRIMARY KEY,
  CustomerName VARCHAR2(100),
  AccountType VARCHAR2(20),
  Balance NUMBER
);

-- Create Employees table
CREATE TABLE Employees (
  EmpID NUMBER PRIMARY KEY,
  EmpName VARCHAR2(100),
  Department VARCHAR2(50),
  Salary NUMBER
);

-- Sample data
INSERT INTO Accounts VALUES (1, 'Alice', 'Savings', 10000);
INSERT INTO Accounts VALUES (2, 'Bob', 'Savings', 15000);
INSERT INTO Accounts VALUES (3, 'Charlie', 'Current', 8000);
INSERT INTO Accounts VALUES (4, 'David', 'Savings', 20000);

INSERT INTO Employees VALUES (101, 'John', 'Sales', 50000);
INSERT INTO Employees VALUES (102, 'Jane', 'HR', 55000);
INSERT INTO Employees VALUES (103, 'Mike', 'Sales', 52000);

COMMIT;

-- Procedure 1: ProcessMonthlyInterest
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
BEGIN
  UPDATE Accounts
  SET Balance = Balance + (Balance * 0.01)
  WHERE AccountType = 'Savings';
  
  DBMS_OUTPUT.PUT_LINE('Monthly interest applied to savings accounts.');
END;
/

-- Procedure 2: UpdateEmployeeBonus
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
  p_Department IN VARCHAR2,
  p_BonusPercent IN NUMBER
) IS
BEGIN
  UPDATE Employees
  SET Salary = Salary + (Salary * p_BonusPercent / 100)
  WHERE Department = p_Department;
  
  DBMS_OUTPUT.PUT_LINE('Bonus updated for department: ' || p_Department);
END;
/

-- Procedure 3: TransferFunds
CREATE OR REPLACE PROCEDURE TransferFunds(
  p_FromAccountID IN NUMBER,
  p_ToAccountID IN NUMBER,
  p_Amount IN NUMBER
) IS
  v_FromBalance NUMBER;
BEGIN
  SELECT Balance INTO v_FromBalance FROM Accounts WHERE AccountID = p_FromAccountID FOR UPDATE;

  IF v_FromBalance < p_Amount THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in source account.');
  END IF;

  -- Deduct from source
  UPDATE Accounts
  SET Balance = Balance - p_Amount
  WHERE AccountID = p_FromAccountID;

  -- Add to destination
  UPDATE Accounts
  SET Balance = Balance + p_Amount
  WHERE AccountID = p_ToAccountID;

  DBMS_OUTPUT.PUT_LINE('Transfer completed from Account ' || p_FromAccountID || ' to Account ' || p_ToAccountID);
END;
/

-- Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- Sample executions
BEGIN
  ProcessMonthlyInterest;
  UpdateEmployeeBonus('Sales', 10);
  TransferFunds(1, 2, 2000);
END;
/
