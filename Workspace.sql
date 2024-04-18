-- # Final – Hands On

-- ## Question 1 (5 marks) – Basic PL/SQL Block Structures

-- The Brewbean’s application needs a block that determines whether a customer is rated high, mid,
-- or low based on his or her total purchases. The block needs to determine the rating and then
-- display the results onscreen. The code rates the customer high if total purchases are greater than
-- $200, mid if greater than $100, and low if $100 or lower. Develop a flowchart to outline the
-- conditional processing steps needed for this block.

-- ## Question 2 (5 marks) – Using IF Statements

-- Create a PLSQL block using an IF statement to perform the actions described in Question 1. Use
-- a scalar variable for the total purchase amount and initialize this variable to different values to
-- test your block.
-- Capture your output and include in a word document.
DECLARE
   lv_total_purchase NUMBER := 150;
   lv_customer_rating VARCHAR2(10);
BEGIN
   IF lv_total_purchase > 200 THEN
      lv_customer_rating := 'High';
   ELSIF lv_total_purchase > 100 THEN
      lv_customer_rating := 'Mid';
   ELSE
      lv_customer_rating := 'Low';
   END IF;
   
   DBMS_OUTPUT.PUT_LINE('Customer Rating: ' || lv_customer_rating);
END;
/

-- # Question 3 (5 marks) – Procedures

-- Create a procedure named STATUS_SHIP_SP that allows an employee in the Shipping
-- Department to update an order status to add shipping information. The BB_BASKETSTATUS
-- table lists events for each order so that a shopper can see the current status, date, and comments
-- as each stage of the order process is finished. The IDSTAGE column of the
-- BB_BASKETSTATUS table identifies each stage; the value 3 in this column indicates that an
-- order has been shipped. The procedure should allow adding a row with an IDSTAGE of 3, date
-- shipped, tracking number, and shipper. The BB_STATUS_SEQ sequence is used to provide a
-- value for the primary key column.

-- Test the procedure with the following information:
-- - Basket # = 3
-- - Date shipped = 20-FEB-12
-- - Shipper = UPS
-- - Tracking # = ZW2384YXK4957

-- # Question 4 (5 marks) - Functions

-- Create a function named TAX_CALC_SF that accepts a basket ID, calculates the tax amount by
-- using the basket subtotal, and returns the correct tax amount for the order. The tax is determined
-- by the shipping state, which is stored in the BB_BASKET table. The BB_TAX table contains the
-- tax rate for states that require taxes on Internet purchases. If the state isn’t listed
-- in the tax table or no shipping state is assigned to the basket, a tax amount of zero should be
-- applied to the order. Use the function in a SELECT statement that displays the shipping costs for
-- a basket that has tax applied and a basket with no shipping state.
