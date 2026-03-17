--Procedures:

--1. Arrears Report:
--This procedure generates a hierarchical report of the company's overdue accounts receivable.
--Its objective is to identify and quantify outstanding debt grouped by client to facilitate collections management.
/
CREATE OR REPLACE PROCEDURE SP_REPORTE_MOROSIDAD_CLIENTES IS
CURSOR c_clientes_deudores IS
SELECT DISTINCT
E.id_emp_arr,
E.razon_social,
E.telefono
FROM EMPRESA_ARR
JOIN CONTRATO C ON E.id_emp_arr = C.empresa_arr_id_emp_arr
JOIN CUOTA Q ON C.nro_contrato = Q.contrato_nro_contrato
WHERE Q.estado != 'C'
AND Q.fecha_cancel < SYSDATE
ORDER BY E.razon_social;

CURSOR c_detalle_deuda (p_id_cliente VARCHAR2) IS
SELECT
C.nro_contrato,
Q.nro_factura,
Q.monto,
Q.tipo_moneda,
Q.fecha_cancel AS fecha_vencimiento,
TRUNC(SYSDATE - Q.fecha_cancel) AS dias_atraso
FROM CONTRATO C
JOIN CUOTA Q ON C.nro_contrato = Q.contrato_nro_contrato
WHERE C.empresa_arr_id_emp_arr = p_id_cliente
AND Q.estado != 'C'
AND Q.fecha_cancel < SYSDATE
ORDER BY Q.fecha_cancel ASC;

v_subtotal_cliente NUMBER(15,2);
v_gran_total NUMBER(15,2) := 0;

BEGIN
DBMS_OUTPUT.PUT_LINE('REPORTE DE MOROSIDAD');
DBMS_OUTPUT.PUT_LINE('Fecha de Corte: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'));

FOR r_cli IN c_clientes_deudores LOOP
  DBMS_OUTPUT.PUT_LINE('CLIENTE: ' || r_cli.razon_social);
  DBMS_OUTPUT.PUT_LINE('Telefono: ' || r_cli.telefono);
  DBMS_OUTPUT.PUT_LINE('--- Detalle de Facturas Vencidas ---');

  v_subtotal_cliente := 0;

  FOR r_det IN c_detalle_deuda(r_cli.id_emp_arr) LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Contrato: ' || r_det.nro_contrato ||
      ' | Fac: ' || r_det.nro_factura ||
      ' | Vencio: ' || r_det.fecha_vencimiento ||
      ' (Hace ' || r_det.dias_atraso || ' dias)' ||
      ' | Deuda: ' || r_det.tipo_moneda || ' ' || r_det.monto
    );

    v_subtotal_cliente := v_subtotal_cliente + r_det.monto;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('TOTAL CLIENTE: ' || v_subtotal_cliente);

  v_gran_total := v_gran_total + v_subtotal_cliente;
END LOOP;

DBMS_OUTPUT.PUT_LINE('DEUDA TOTAL: ' || v_gran_total);

END;
/


--2. Contract Statement
--This procedure generates a detailed transaction history for a specific lease agreement. 
--Its purpose is to provide an operational tool for quickly checking payment compliance status, 
--which is necessary for customer service and financial reconciliation.


CREATE OR REPLACE PROCEDURE SP_ESTADO_CUENTA_CONTRATO (
p_nro_contrato IN VARCHAR2
)
IS
CURSOR c_detalle (cp_contrato VARCHAR2) IS
SELECT
nro_factura,
fecha_emi,
fecha_cancel
FROM cuota
WHERE contrato_nro_contrato = cp_contrato
ORDER BY fecha_emi ASC;

v_cliente VARCHAR2(100);
v_bien VARCHAR2(100);
v_estado_desc VARCHAR2(20);
v_pagado NUMBER := 0;
v_pendiente NUMBER := 0;

BEGIN
SELECT e.razon_social, c.descripcion_del_bien
INTO v_cliente, v_bien
FROM contrato c
JOIN empresa_arr e ON c.empresa_arr_id_emp_arr = e.id_emp_arr
WHERE c.nro_contrato = p_nro_contrato;

EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('Error: El contrato ' || p_nro_contrato || ' no existe.');
  RETURN;
END;

DBMS_OUTPUT.PUT_LINE('ESTADO DE CUENTA DETALLADO');

FOR r IN c_detalle(p_nro_contrato) LOOP

  IF r.fecha_cancel < SYSDATE THEN
    v_estado_desc := 'VENCIDO';
    v_pendiente := v_pendiente + 1;
  ELSE
    v_estado_desc := 'PENDIENTE';
    v_pendiente := v_pendiente + 1;
  END IF;

  DBMS_OUTPUT.PUT_LINE(
    r.nro_factura || ' | ' ||
    r.fecha_cancel || ' | ' ||
    v_estado_desc
  );

END LOOP;

DBMS_OUTPUT.PUT_LINE('Pagado: ' || v_pagado || ' | Pendiente: ' || v_pendiente);

END;
/


