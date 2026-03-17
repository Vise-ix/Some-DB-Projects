

CREATE TABLE acta_rec_conf (
    id_acta               VARCHAR2(10 BYTE) NOT NULL,
    fecha_acta            DATE NOT NULL,
    firma_arrendatario    BLOB NOT NULL,
    estado_producto       VARCHAR2(10 BYTE) NOT NULL,
    contrato_nro_contrato VARCHAR2(10 BYTE) NOT NULL
);

CREATE UNIQUE INDEX acta_rec_conf__idx ON
    acta_rec_conf (
        contrato_nro_contrato
    ASC );

ALTER TABLE acta_rec_conf ADD CONSTRAINT acta_rec_conf_pk PRIMARY KEY ( id_acta );

CREATE TABLE contrato (
    nro_contrato            VARCHAR2(10 BYTE) NOT NULL,
    valor_bien              NUMBER(10, 2) NOT NULL,
    fecha_inicio            DATE NOT NULL,
    fecha_fin               DATE NOT NULL,
    valor_residual          NUMBER(10, 2) NOT NULL,
    plazo                   NUMBER NOT NULL,
    monto_cuota             NUMBER(10, 2) NOT NULL,
    numero_cuotas           NUMBER NOT NULL,
    estado                  CHAR(1) NOT NULL,
    disponibilidad_producto VARCHAR2(20 BYTE) NOT NULL,
    monto_opcion_de_compra  NUMBER(10, 2) NOT NULL,
    tipo_moneda             VARCHAR2(20 BYTE) NOT NULL,
    solicitud_nro_solicitud VARCHAR2(10 BYTE) NOT NULL,
    proveedor_id_proveedor  VARCHAR2(10 BYTE) NOT NULL,
    seguro_id_poliza        VARCHAR2(10 BYTE) NOT NULL,
    usuario_creacion        VARCHAR2(20 BYTE) NOT NULL,
    fecha_creacion          DATE NOT NULL,
    usuario_modificacion    VARCHAR2(20 BYTE) NOT NULL,
    fecha_modificacion      DATE NOT NULL,
    fecha_ven_ofer          DATE,
    descripcion_del_bien    VARCHAR2(50 BYTE) NOT NULL,
    empresa_arr_id_emp_arr  VARCHAR2(10 BYTE) NOT NULL
);

CREATE UNIQUE INDEX contrato__idx ON
    contrato (
        seguro_id_poliza
    ASC );

CREATE UNIQUE INDEX contrato__idxv1 ON
    contrato (
        solicitud_nro_solicitud
    ASC );

ALTER TABLE contrato ADD CONSTRAINT contrato_pk PRIMARY KEY ( nro_contrato );

CREATE TABLE cuota (
    nro_factura           VARCHAR2(10 BYTE) NOT NULL,
    monto                 NUMBER(10, 2) NOT NULL,
    emisor                VARCHAR2(20 BYTE) NOT NULL,
    tipo_moneda           VARCHAR2(20 BYTE) NOT NULL,
    fecha_emi             DATE NOT NULL,
    fecha_cancel          DATE NULL,
    estado                CHAR(1) NOT NULL,
    contrato_nro_contrato VARCHAR2(10 BYTE) NOT NULL
);

ALTER TABLE cuota ADD CONSTRAINT cuota_pk PRIMARY KEY ( nro_factura );

CREATE TABLE documento (
    nro_doc_aso             VARCHAR2(10 BYTE) NOT NULL,
    fecha_creacion          DATE NOT NULL,
    asunto                  VARCHAR2(40 BYTE) NOT NULL,
    estado_val              CHAR(1 BYTE) NOT NULL,
    tipo_documento          VARCHAR2(20 BYTE) NOT NULL,
    solicitud_nro_solicitud VARCHAR2(10 BYTE) NOT NULL
);

ALTER TABLE documento ADD CONSTRAINT documento_pk PRIMARY KEY ( nro_doc_aso );

CREATE TABLE empresa_arr (
    id_emp_arr   VARCHAR2(10 BYTE) NOT NULL,
    ruc          NUMBER NOT NULL,
    razon_social VARCHAR2(40 BYTE) NOT NULL,
    telefono     NUMBER NOT NULL,
    direccion    VARCHAR2(80 BYTE) NOT NULL
);

ALTER TABLE empresa_arr ADD CONSTRAINT empresa_arr_pk PRIMARY KEY ( id_emp_arr );

CREATE TABLE entidad_bancaria (
    id_banco                VARCHAR2(10 BYTE) NOT NULL,
    ruc                     NUMBER NOT NULL,
    razon_social            VARCHAR2(20 BYTE) NOT NULL,
    telefono                NUMBER,
    correo                  VARCHAR2(20 BYTE) NOT NULL
);



ALTER TABLE entidad_bancaria ADD CONSTRAINT entidad_bancaria_pk PRIMARY KEY ( id_banco );

CREATE TABLE evaluacion (
    nro_evaluacion         VARCHAR2(10 BYTE) NOT NULL,
    capacidad_pago         NUMBER(10, 2) NOT NULL,
    endeudamiento          NUMBER(10, 2) NOT NULL,
    fecha_evaluacion       DATE,
    estado_capacidad       VARCHAR2(20 BYTE) NOT NULL,
    observaciones          VARCHAR2(50 BYTE),
    empresa_arr_id_emp_arr VARCHAR2(10 BYTE) NOT NULL
);

ALTER TABLE evaluacion ADD CONSTRAINT evaluacion_pk PRIMARY KEY ( nro_evaluacion );

CREATE TABLE garantia (
    id_garantia          VARCHAR2(10 BYTE) NOT NULL,
    tipo                 VARCHAR2(20 BYTE) NOT NULL,
    fecha_inicio         DATE NOT NULL,
    fecha_fin            DATE NOT NULL,
    monto_cubierto       NUMBER(10, 2) NOT NULL,
    condiciones          VARCHAR2(50 BYTE) NOT NULL,
    estado               CHAR(1) NOT NULL,
    producto_id_producto VARCHAR2(10 BYTE) NOT NULL,
    seguro_id_poliza     VARCHAR2(10 BYTE) NOT NULL
);

CREATE UNIQUE INDEX garantia__idx ON
    garantia (
        producto_id_producto
    ASC );

CREATE UNIQUE INDEX garantia__idxv1 ON
    garantia (
        seguro_id_poliza
    ASC );

ALTER TABLE garantia ADD CONSTRAINT garantia_pk PRIMARY KEY ( id_garantia );

CREATE TABLE pago (
    nro_pago          VARCHAR2(10 BYTE) NOT NULL,
    fecha_cancelacion DATE NULL,
    estado            VARCHAR2(10 BYTE) NOT NULL,
    metodo_pago       VARCHAR2(20 BYTE) NOT NULL,
    monto_pago        NUMBER(10, 2) NOT NULL,
    cuota_nro_factura VARCHAR2(10 BYTE) NOT NULL
);

ALTER TABLE pago ADD CONSTRAINT pago_pk PRIMARY KEY ( nro_pago );

CREATE TABLE producto (
    id_producto            VARCHAR2(10 BYTE) NOT NULL,
    descripcion            VARCHAR2(40 BYTE) NOT NULL,
    tipo                   VARCHAR2(20 BYTE) NOT NULL,
    precio                 NUMBER(10, 2) NOT NULL,
    estado                 VARCHAR2(20 BYTE) NOT NULL,
    proveedor_id_proveedor VARCHAR2(10 BYTE) NOT NULL,
    contrato_nro_contrato  VARCHAR2(10 BYTE) NOT NULL,
    tipo_moneda            VARCHAR2(20 BYTE) NOT NULL
);

ALTER TABLE producto ADD CONSTRAINT producto_pk PRIMARY KEY ( id_producto );

CREATE TABLE proveedor (
    id_proveedor                VARCHAR2(10 BYTE) NOT NULL,
    ruc                         NUMBER NOT NULL,
    razon_social                VARCHAR2(20 BYTE) NOT NULL,
    telefono                    NUMBER NOT NULL,
    correo                      VARCHAR2(20 BYTE) NOT NULL,
    disponibilidad_del_producto VARCHAR2(20 BYTE) NOT NULL,
    categoria_del_producto      VARCHAR2(20 BYTE) NOT NULL
);

ALTER TABLE proveedor ADD CONSTRAINT proveedor_pk PRIMARY KEY ( id_proveedor );

CREATE TABLE representante (
    id_representante       VARCHAR2(10 BYTE) NOT NULL,
    nombre_completo        VARCHAR2(60 BYTE) NOT NULL,
    nro_doc_ide            VARCHAR2(20 BYTE) NOT NULL,
    telefono               NUMBER NOT NULL,
    fecha_nacimiento       DATE NOT NULL,
    correo                 VARCHAR2(20 BYTE) NOT NULL,
    area_solicitada        VARCHAR2(20 BYTE) NOT NULL,
    empresa_arr_id_emp_arr VARCHAR2(10 BYTE) NOT NULL
);

ALTER TABLE representante ADD CONSTRAINT representante_pk PRIMARY KEY ( id_representante );

CREATE TABLE seguro (
    id_poliza           VARCHAR2(10 BYTE) NOT NULL,
    tipo_cobertura      VARCHAR2(20 BYTE) NOT NULL,
    valor_asegurado     NUMBER(10, 2) NOT NULL,
    fecha_emision       DATE NOT NULL,
    estado              CHAR(1) NOT NULL,
    fecha_fin_cobertura DATE NOT NULL,
    excepciones         VARCHAR2(40 BYTE) NOT NULL,
    tipo_seguro         VARCHAR2(20 BYTE) NOT NULL
);

ALTER TABLE seguro ADD CONSTRAINT seguro_pk PRIMARY KEY ( id_poliza );

CREATE TABLE solicitud (
    nro_solicitud             VARCHAR2(10 BYTE) NOT NULL,
    estado                    CHAR(1 BYTE) NOT NULL,
    fecha_soli                DATE NOT NULL,
    monto_soli                NUMBER(10, 2) NOT NULL,
    tipo_moneda               VARCHAR2(20 BYTE) NOT NULL,
    evaluacion_nro_evaluacion VARCHAR2(10 BYTE) NOT NULL,
    tipo_prod                 VARCHAR2(20 BYTE),
    cantidad_prod             NUMBER NOT NULL,
    fecha_reso                DATE,
    empresa_arr_id_emp_arr    VARCHAR2(10 BYTE) NOT NULL, 
    id_banco VARCHAR2(10 BYTE) NOT NULL
);

CREATE UNIQUE INDEX solicitud__idx ON
    solicitud (
        evaluacion_nro_evaluacion
    ASC );

ALTER TABLE solicitud ADD CONSTRAINT solicitud_pk PRIMARY KEY ( nro_solicitud );

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_banco_fk FOREIGN KEY ( id_banco )
        REFERENCES entidad_bancaria ( id_banco );

ALTER TABLE acta_rec_conf
    ADD CONSTRAINT acta_rec_conf_contrato_fk FOREIGN KEY ( contrato_nro_contrato )
        REFERENCES contrato ( nro_contrato );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_empresa_arr_fk FOREIGN KEY ( empresa_arr_id_emp_arr )
        REFERENCES empresa_arr ( id_emp_arr );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_proveedor_fk FOREIGN KEY ( proveedor_id_proveedor )
        REFERENCES proveedor ( id_proveedor );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_seguro_fk FOREIGN KEY ( seguro_id_poliza )
        REFERENCES seguro ( id_poliza );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_solicitud_fk FOREIGN KEY ( solicitud_nro_solicitud )
        REFERENCES solicitud ( nro_solicitud );

ALTER TABLE cuota
    ADD CONSTRAINT cuota_contrato_fk FOREIGN KEY ( contrato_nro_contrato )
        REFERENCES contrato ( nro_contrato );

ALTER TABLE documento
    ADD CONSTRAINT documento_solicitud_fk FOREIGN KEY ( solicitud_nro_solicitud )
        REFERENCES solicitud ( nro_solicitud );

ALTER TABLE evaluacion
    ADD CONSTRAINT evaluacion_empresa_arr_fk FOREIGN KEY ( empresa_arr_id_emp_arr )
        REFERENCES empresa_arr ( id_emp_arr );

ALTER TABLE garantia
    ADD CONSTRAINT garantia_producto_fk FOREIGN KEY ( producto_id_producto )
        REFERENCES producto ( id_producto );

ALTER TABLE garantia
    ADD CONSTRAINT garantia_seguro_fk FOREIGN KEY ( seguro_id_poliza )
        REFERENCES seguro ( id_poliza );

ALTER TABLE pago
    ADD CONSTRAINT pago_cuota_fk FOREIGN KEY ( cuota_nro_factura )
        REFERENCES cuota ( nro_factura );

ALTER TABLE producto
    ADD CONSTRAINT producto_contrato_fk FOREIGN KEY ( contrato_nro_contrato )
        REFERENCES contrato ( nro_contrato );

ALTER TABLE producto
    ADD CONSTRAINT producto_proveedor_fk FOREIGN KEY ( proveedor_id_proveedor )
        REFERENCES proveedor ( id_proveedor );

ALTER TABLE representante
    ADD CONSTRAINT representante_empresa_arr_fk FOREIGN KEY ( empresa_arr_id_emp_arr )
        REFERENCES empresa_arr ( id_emp_arr );

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_empresa_arr_fk FOREIGN KEY ( empresa_arr_id_emp_arr )
        REFERENCES empresa_arr ( id_emp_arr );

ALTER TABLE solicitud
    ADD CONSTRAINT solicitud_evaluacion_fk FOREIGN KEY ( evaluacion_nro_evaluacion )
        REFERENCES evaluacion ( nro_evaluacion );

