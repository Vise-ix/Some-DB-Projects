--EXCEPTION AND TRANSACTION HANDLING



--Procedure: Register Company (INSERT):
--This procedure allows you to insert a new client into the database. It implements a
--duplicate validation by catching the DUP_VAL_ON_INDEX exception,
--preventing the registration of two companies with the same ID or RUC (tax ID).

CREATE OR REPLACE PROCEDURE PR_CREAR_EMPRESA (
	p_id 	IN VARCHAR2,
	p_ruc 	IN NUMBER,
	p_razon IN VARCHAR2,
	p_tel 	IN NUMBER,
	p_dir 	IN VARCHAR2
) IS

BEGIN
	
	INSERT INTO EMPRESA ARR (ID_EMP_ARR, RUC, RAZON_SOCIAL, TELEFONO, DIRECCION) 
	VALUES (p_id, p_ruc, p_razon, p_tel, p_dir);
	
	COMMIT; --Transacción Exitosa
	DBMS_OUTPUT.PUT_LINE('Éxito: Empresa creada correctamente.');
	
EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		ROLLBACK; -- Deshacer cambios
		DBMS_OUTPUT.PUT_LINE('Error controlado: El ID o RUC ya existe en la base de datos.');
		
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/



--Procedure: Update Data (UPDATE):
--Subprogram responsible for modifying contact information (Company Name and Phone Number).
--Before updating, we use a variable v_existe to check whether the client exists in the database.
--If v_existe = 0, the operation is canceled. If the client exists, we proceed with the UPDATE and COMMIT.


CREATE OR REPLACE PROCEDURE PR_ACTUALIZAR EMPRESA ( 
	p_id IN VARCHAR2,
	p_nueva_razon IN VARCHAR2,
	p_nuevo_tel IN NUMBER
)IS
	v_existe NUMBER; --Variable para saber si existe

BEGIN
		-- PASO 1: Verificamos si existe el ID
	SELECT COUNT(*) INTO v_existe
	FROM EMPRESA_ARR
	WHERE ID_EMP_ARR = p_id;
		
	-- PASO 2: Decidimos qué hacer
	IF v_existe = 0 THEN
		-- Si es 0, no existe. No hacemos nada más.
		DBMS_OUTPUT.PUT_LINE('Error controlado: No se encontró el ID para actualizar.');
	ELSE
		-- Si existe, hacemos el UPDATE y guardamos
		UPDATE EMPRESA_ARR
		SET RAZON_SOCIAL = p_nueva_razon,
			TELEFONO = p_nuevo_tel
		WHERE ID_EMP_ARR = p_id;
		
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('Éxito: Datos actualizados.');
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('Error al actualizar: ' || SQLERRM);
END;
/

--Delete Company (DELETE):
--This procedure manages the deletion of records while ensuring referential integrity.
--An exception has been configured using PRAGMA EXCEPTION_INIT associated with Oracle error code -2292 
--This prevents the deletion of companies that already have related contracts or requests, 
--thus protecting the consistency of the relational model.
--As in the previous case, we first verify whether the company exists using a SELECT COUNT.

CREATE OR REPLACE PROCEDURE PR_ELIMINAR_EMPRESA (
	p_id IN VARCHAR2
) IS
	v_existe NUMBER;

	-- Excepción para integridad referencial 
	e_integridad_ref EXCEPTION;
	PRAGMA EXCEPTION_INIT(e_integridad_ref, -2292);

BEGIN
	-- PASO 1: Verificamos si existe
	SELECT COUNT(*) INTO v_existe
	FROM EMPRESA_ARR
	WHERE ID_EMP_ARR = p_id;

	-- PASO 2: Lógica de borrado
	IF v_existe = 0 THEN
		DBMS_OUTPUT.PUT_LINE('Error controlado: La empresa no existe.');
	ELSE
		DELETE FROM EMPRESA_ARR
		WHERE ID_EMP_ARR = p_id;

		COMMIT; -- Confirmamos el borrado
		DBMS_OUTPUT.PUT_LINE('Éxito: Empresa eliminada.');
	END IF;

EXCEPTION
	WHEN e_integridad_ref THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('Error de Integridad: No se puede borrar, tiene contratos asociados.');

	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('Error desconocido: ' || SQLERRM);
END;
/