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
CREATE OR REPLACE PROCEDURE STATUS_SHIP_SP (
    p_basket_id IN bb_basket.idBasket%TYPE,
    p_date_shipped IN DATE,
    p_shipper IN VARCHAR2,
    p_tracking_num IN VARCHAR2
)
AS
    v_status_id bb_basketstatus.idStatus%TYPE;
BEGIN
    -- Generate unique ID for the status entry
    SELECT bb_status_seq.NEXTVAL INTO v_status_id FROM dual;
    
    -- Insert shipping information into the basket status table
    INSERT INTO bb_basketstatus (idStatus, idBasket, idStage, dtStage, shipper, ShippingNum)
    VALUES (v_status_id, p_basket_id, 3, p_date_shipped, p_shipper, p_tracking_num);
    
    -- Commit the transaction
    COMMIT;
    
    -- Output success message
    DBMS_OUTPUT.PUT_LINE('Shipping information added successfully for Basket ID ' || p_basket_id);
EXCEPTION
    WHEN OTHERS THEN
        -- Output error message
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END STATUS_SHIP_SP;
/

BEGIN
    STATUS_SHIP_SP(
        p_basket_id => 3,
        p_date_shipped => TO_DATE('20-FEB-12', 'DD-MON-YY'),
        p_shipper => 'UPS',
        p_tracking_num => 'ZW2384YXK4957'
    );
END;
/

-- # Question 4 (5 marks) - Functions

-- Create a function named TAX_CALC_SF that accepts a basket ID, calculates the tax amount by
-- using the basket subtotal, and returns the correct tax amount for the order. The tax is determined
-- by the shipping state, which is stored in the BB_BASKET table. The BB_TAX table contains the
-- tax rate for states that require taxes on Internet purchases. If the state isn’t listed
-- in the tax table or no shipping state is assigned to the basket, a tax amount of zero should be
-- applied to the order. Use the function in a SELECT statement that displays the shipping costs for
-- a basket that has tax applied and a basket with no shipping state.
CREATE OR REPLACE FUNCTION TAX_CALC_SF(p_basket_id IN NUMBER)
  RETURN NUMBER
IS
  lv_state bb_basket.shipstate%TYPE;
  lv_tax_rate bb_tax.taxrate%TYPE;
  lv_subtotal bb_basket.subtotal%TYPE;
  lv_tax_amount NUMBER(7,2);
BEGIN
  -- Retrieve shipping state and subtotal for the given basket ID
  SELECT shipstate, subtotal
  INTO lv_state, lv_subtotal
  FROM bb_basket
  WHERE idbasket = p_basket_id;

  -- Retrieve the tax rate for the shipping state
  SELECT taxrate
  INTO lv_tax_rate
  FROM bb_tax
  WHERE state = lv_state;

  -- Calculate tax amount
  IF lv_tax_rate IS NOT NULL THEN
    lv_tax_amount := lv_subtotal * lv_tax_rate;
  ELSE
    lv_tax_amount := 0;
  END IF;

  -- Return tax amount
  RETURN lv_tax_amount;
EXCEPTION
  -- Handle exceptions such as state not found or other errors
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
  WHEN OTHERS THEN
    RETURN NULL; -- Indicate error occurred
END TAX_CALC_SF;
/
