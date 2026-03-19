CREATE SCHEMA logistica;

CREATE TABLE logistica.clientes (
    id_cliente SERIAL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT NOW(),
    activo BOOLEAN DEFAULT true,

    CONSTRAINT pk_clientes PRIMARY KEY (id_cliente),
    CONSTRAINT correo_telefono_unico UNIQUE (correo, telefono)

);

CREATE TABLE logistica.estados (
    id_estado SERIAL ,
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT pk_estados PRIMARY KEY (id_estado),
    CONSTRAINT nombre_unico UNIQUE (nombre)
);

CREATE TABLE logistica.ciudades (
    id_ciudad SERIAL 
    ,
    nombre VARCHAR(100) NOT NULL,
    id_estado INTEGER NOT NULL,

    CONSTRAINT nombre_unico_estado UNIQUE (nombre, id_estado),
    CONSTRAINT pk_ciudades PRIMARY KEY (id_ciudad),

    CONSTRAINT fk_ciudades_estados
    FOREIGN KEY (id_estado)
        REFERENCES logistica.estados(id_estado)
        ON DELETE RESTRICT
);

CREATE TABLE logistica.direcciones (
    id_direccion SERIAL,
    id_cliente INTEGER NOT NULL,
    id_ciudad INTEGER NOT NULL,
    calle VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    colonia VARCHAR(100) NOT NULL,

    CONSTRAINT pk_direcciones PRIMARY KEY (id_direccion),

    CONSTRAINT fk_direcciones_clientes
    FOREIGN KEY (id_cliente)
        REFERENCES logistica.clientes(id_cliente)
        ON DELETE RESTRICT,

    CONSTRAINT fk_direcciones_ciudades    
    FOREIGN KEY (id_ciudad)
        REFERENCES logistica.ciudades(id_ciudad)
        ON DELETE RESTRICT
);

CREATE TABLE logistica.envios (
    id_envio SERIAL,
    numero_guia VARCHAR(50) NOT NULL,
    id_cliente INTEGER NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT NOW(),
    fecha_envio TIMESTAMP NULL,
    fecha_entrega TIMESTAMP NULL,
    costo DECIMAL(10,2) NOT NULL,

    CONSTRAINT pk_envios PRIMARY KEY (id_envio),
    CONSTRAINT numero_guia_unico UNIQUE (numero_guia),
    

    CONSTRAINT fk_envios_clientes
    FOREIGN KEY (id_cliente)
        REFERENCES logistica.clientes(id_cliente)
        ON DELETE RESTRICT
);

CREATE TABLE logistica.paquetes (
    id_paquete SERIAL,
    descripcion TEXT DEFAULT 'SIN DESCRIPCION',
    peso DECIMAL(10,2) NOT NULL,
    alto DECIMAL(10,2) NOT NULL,
    ancho DECIMAL(10,2) NOT NULL,
    largo DECIMAL(10,2) NOT NULL,
    id_envio INTEGER NOT NULL,

    CONSTRAINT pk_paquetes PRIMARY KEY (id_paquete),
    CONSTRAINT peso_positivo CHECK (peso > 0),
    CONSTRAINT dimensiones_positivas CHECK (alto > 0 AND ancho > 0 AND largo > 0),

    CONSTRAINT fk_paquetes_envios
    FOREIGN KEY (id_envio)
        REFERENCES logistica.envios(id_envio)
        ON DELETE RESTRICT
);

CREATE TABLE logistica.estados_envio (
    id_estado_envio SERIAL,
    nombre VARCHAR(50) NOT NULL,

    CONSTRAINT nombre_unico_estado_envio UNIQUE (nombre),
    CONSTRAINT pk_estados_envio PRIMARY KEY (id_estado_envio)
);

CREATE TABLE logistica.historial_estados (
    id_historial SERIAL,
    id_envio INTEGER NOT NULL,
    id_estado_envio INTEGER NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT NOW(),
    comentarios TEXT,

    CONSTRAINT pk_historial_estados PRIMARY KEY (id_historial),

    CONSTRAINT fk_historial_envios
    FOREIGN KEY (id_envio)
        REFERENCES logistica.envios(id_envio)
        ON DELETE RESTRICT,

    CONSTRAINT fk_historial_estados_envio
    FOREIGN KEY (id_estado_envio)
        REFERENCES logistica.estados_envio(id_estado_envio)
        ON DELETE RESTRICT
);

INSERT INTO logistica.estados_envio (nombre) VALUES
('CREADO'),
('EN_BODEGA'),
('EN_TRANSITO'),
('EN_REPARTO'),
('ENTREGADO'),
('CANCELADO');

CREATE INDEX idx_clientes_correo
ON logistica.clientes(correo);