--Triggers:

--1. TRG_PROTEGER_CUOTA_CANCELADA
--This trigger prevents a paid fee from being modified. 
--Before updating any record in the CUOTAS table, the system checks if the current status is "X".
--If so, the operation is stopped and an error message is displayed. 
--This protects the integrity of historical data, preventing changes to closed fees and ensuring that payment 
--records cannot be manipulated after being marked as canceled.

CREATE OR REPLACE TRIGGER TRG PROTEGER_CUOTA_CANCELADA
BEFORE UPDATE ON CUOTA
FOR EACH ROW
BEGIN
END;
	IF :old.estado = 'X' THEN
	RAISE_APPLICATION_ERROR(-20001, 'No se puede modificar una cuota ya cancelada.');
END IF;


--Caso donde si funciona
UPDATE cuota
SET monto 2000
WHERE nro_factura = 'F01-01';


--Caso inválido
UPDATE cuota SET estado='X' WHERE nro_factura='F01-02';

UPDATE cuota
SET monto 5000
WHERE nro_factura = 'F01-02';





--2. TRG_ACTUALIZA_PAGO
--This trigger automates the updating of an installment's status and the contract status each time a payment is recorded. 
--Once a payment is entered, it identifies the corresponding installment, marks it as paid, 
--and then checks if the contract still has any outstanding installments. 
--If there are no more installments to pay, it changes the contract status to "C". 
--In this way, the system ensures that the contract balance is automatically updated and that its closure 
--occurs without manual intervention.

CREATE OR REPLACE TRIGGER TRG_ACTUALIZA_PAGO
AFTER INSERT OR UPDATE ON PAGO
FOR EACH ROW
DECLARE
v_contrato VARCHAR2(10);
v_pendientes NUMBER;
BEGIN

SELECT contrato_nro_contrato INTO v_contrato
FROM cuota
WHERE nro_factura = :NEW.cuota_nro_factura;

UPDATE cuota
SET estado = 'X'
WHERE nro_factura = :NEW.cuota_nro_factura;

SELECT COUNT(*) INTO v_pendientes
FROM cuota
WHERE contrato_nro_contrato = v_contrato
AND estado = 'P';

IF v_pendientes = 0 THEN
  UPDATE contrato
  SET estado = 'C'
  WHERE nro_contrato = v_contrato;
END IF;

END;
/

-- Caso de prueba
INSERT INTO pago VALUES ('PAGO05', SYSDATE, 'CANCELADO', 'TRANSFERENCIA', 3800, 'F04-01');
INSERT INTO pago VALUES ('PAGO06', SYSDATE, 'CANCELADO', 'TRANSFERENCIA', 3800, 'F04-02');

SELECT estado FROM contrato WHERE nro_contrato='CON004';


--3. TRG_VALIDA_CONTRATO_SOLICITUD
--This trigger validates that a contract can only be generated once its associated request has been approved. 
--Before inserting a contract, it checks the request status and, if it is not "A", prevents the record from being created. 
--This ensures that the administrative process follows the correct flow and prevents contracts that do not meet 
--the necessary conditions for formalization.

CREATE OR REPLACE TRIGGER TRG_VALIDA_CONTRATO_SOLICITUD
BEFORE INSERT ON CONTRATO
FOR EACH ROW
DECLARE
v_estado CHAR(1);
BEGIN

SELECT estado INTO v_estado
FROM solicitud
WHERE nro_solicitud = :NEW.solicitud_nro_solicitud;

IF v_estado <> 'A' THEN
  RAISE_APPLICATION_ERROR(-20003, 'La solicitud asociada no esta aprobada.');
END IF;

END;
/

--4. TRG_VALIDA_MONTO_CUOTA
--This trigger ensures that no installment has an invalid amount. 
--Before inserting a new record into the CUOTA table, it checks if any value less than or equal to zero exists. 
--If it detects one, it blocks the insertion and returns an error message. 
--Its function is to ensure that all entered installments have correct and consistent amounts, 
--preventing inconsistencies in the contract's financial calculations and projections.

CREATE OR REPLACE TRIGGER TRG_VALIDA_MONTO_CUOTA
BEFORE INSERT OR UPDATE ON cuota
FOR EACH ROW
BEGIN
IF :NEW.monto <= 0 THEN
  RAISE_APPLICATION_ERROR(-20005, 'El monto de la cuota debe ser mayor que cero.');
END IF;
END;
/

-- Caso válido
INSERT INTO cuota VALUES ('F99-01',1000,'LEASING','USD',SYSDATE,NULL,'P','CON001');

-- Caso inválido
INSERT INTO cuota VALUES ('F95-02',0,'LEASING','USD',SYSDATE,NULL,'P','CON001');

--5. TRG_VALIDA_FECHA_CONTRATO
--This trigger ensures that contract dates are consistent. 
--Before inserting or updating a contract, it compares the start date with the end date, 
--and if the end date is less than or equal to the start date, it stops the operation and displays an error message. 
--Its purpose is to prevent time inconsistencies that could affect the contract's validity, 
--ensuring that deadlines are always recorded correctly.


CREATE OR REPLACE TRIGGER TRG_VALIDA_FECHA_CONTRATO
BEFORE INSERT OR UPDATE ON CONTRATO
FOR EACH ROW
BEGIN
IF :NEW.fecha_fin <= :NEW.fecha_inicio THEN
  RAISE_APPLICATION_ERROR(-20002, 'La fecha final debe ser mayor que la fecha de inicio.');
END IF;
END;
/

-- Caso de prueba
INSERT INTO contrato VALUES ('CON001', 60000.00,
TO_DATE('01/02/2024','DD/MM/YYYY'),
TO_DATE('31/01/2023','DD/MM/YYYY'),
6000.00, 24, 2500.00, 24, 'P',
'ENTREGADO', 1000.00, 'USD',
'SOL001','PROV01','POL001','ADMIN',SYSDATE,'ADMIN',SYSDATE,
TO_DATE('30/01/2026','DD/MM/YYYY'),
'CAMION VOLVO FH','EMP001');