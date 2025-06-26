SET SERVEROUTPUT ON;

DECLARE
    -- Cursor for Scenario 1: Apply 1% interest discount to customers age > 60
    CURSOR cust_interest_cur IS
        SELECT CUSTOMERID, LOANINTERESTRATE
        FROM CUSTOMERS
        WHERE AGE > 60
        FOR UPDATE;

    -- Cursor for Scenario 2: Set VIP flag for high balance
    CURSOR cust_vip_cur IS
        SELECT CUSTOMERID, BALANCE
        FROM CUSTOMERS
        FOR UPDATE;

    -- Cursor for Scenario 3: Loans due in next 30 days
    CURSOR loan_due_cur IS
        SELECT LOANID, CUSTOMERID, DUEDATE
        FROM LOANS
        WHERE DUEDATE <= SYSDATE + 30;

    v_cust_name CUSTOMERS.CUSTOMERNAME%TYPE;

BEGIN
    -- Scenario 1: Apply 1% discount on LOANINTERESTRATE for age > 60
    FOR cust_rec IN cust_interest_cur LOOP
        UPDATE CUSTOMERS
        SET LOANINTERESTRATE = cust_rec.LOANINTERESTRATE - 1
        WHERE CUSTOMERID = cust_rec.CUSTOMERID;
    END LOOP;

    -- Scenario 2: Set ISVIP = 'Y' for BALANCE > 10000
    FOR cust_rec IN cust_vip_cur LOOP
        IF cust_rec.BALANCE > 10000 THEN
            UPDATE CUSTOMERS
            SET ISVIP = 'Y'
            WHERE CUSTOMERID = cust_rec.CUSTOMERID;
        END IF;
    END LOOP;

    -- Scenario 3: Print reminder for due loans
    FOR loan_rec IN loan_due_cur LOOP
        BEGIN
            SELECT CUSTOMERNAME INTO v_cust_name
            FROM CUSTOMERS
            WHERE CUSTOMERID = loan_rec.CUSTOMERID;

            DBMS_OUTPUT.PUT_LINE('Reminder: Loan ID ' || loan_rec.LOANID ||
                                 ' for Customer ' || v_cust_name ||
                                 ' is due on ' || TO_CHAR(loan_rec.DUEDATE, 'DD-MON-YYYY'));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Customer not found for Loan ID ' || loan_rec.LOANID);
        END;
    END LOOP;
END;
/
