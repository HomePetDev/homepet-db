
CREATE TABLE animal(
  nombre_especie varchar(15),
  desc_especie varchar(60) NOT NULL ,

  PRIMARY KEY (nombre_especie)
);

CREATE TABLE homepets (
  rif varchar(12),
  capacidad int NOT NULL ,
  ciudad varchar(15) NOT NULL ,
  sector varchar(15) NOT NULL ,
  fecha_creacion TIMESTAMP  NOT NULL DEFAULT NOW() ,
  especializacion varchar(15) NOT NULL references animal(nombre_especie),

  PRIMARY KEY (rif)
);

CREATE TABLE servicios (
  rif varchar(12) references homepets(rif),
  nombre varchar(20),
  desc_servicio varchar(60) NOT NULL ,

  PRIMARY KEY(rif,nombre)

);

CREATE TABLE actvidades(
  rif varchar(12) references homepets(rif),
  nombre_serv varchar(15),
  id_serial int,
  desc_actividad varchar(60) NOT NULL ,
  precio int NOT NULL CHECK(precio>=0)  ,

  FOREIGN KEY (rif, nombre_serv ) REFERENCES servicios (rif, nombre), 
  PRIMARY KEY(rif,nombre_serv,id_serial)

);

CREATE TABLE almacen(
  id varchar(10),
  capacidad_alamcen int NOT NULL ,
  rifHmpet varchar(12)NOT NULL  references homepets(rif) ,

  PRIMARY KEY (id)

);

CREATE TABLE raza(
  nombre_especie varchar(15)references animal(nombre_especie),
  nombre_raza varchar(15),
  descripcion varchar(40) NOT NULL ,
  pais varchar(15) NOT NULL ,
  iq int NOT NULL ,
  contextura varchar(20) NOT NULL ,
  talla varchar(10) NOT NULL CHECK (talla IN ('S','M','L')),
  color varchar(20) NOT NULL ,
  altura varchar(15) NOT NULL ,
  peso varchar(15) NOT NULL ,

  PRIMARY KEY(nombre_especie,nombre_raza)
);


CREATE TABLE veterinario(
  id varchar(12),
  nombre_vet varchar(60) NOT NULL ,
  telefono varchar(15)  ,

  PRIMARY KEY (id)
);


CREATE TABLE mascota(
  id_mascota varchar(15),
  nombre varchar(20) NOT NULL ,
  fecha_nac TIMESTAMP NOT NULL ,
  sexo char NOT NULL CHECK (sexo = 'F' OR sexo = 'M')  ,
  edad int NOT NULL CHECK (edad>=0)  ,
  cantidad varchar(25) NOT NULL ,
  alimento varchar(25) NOT NULL ,
  nombre_especie varchar(15) NOT NULL references animal(nombre_especie) ,
  nombre_raza varchar(15) NOT NULL,
  id_vet varchar(12) NOT NULL references veterinario(id)  ,
  cedula_owner varchar(12) NOT NULL ,

  FOREIGN KEY (nombre_especie, nombre_raza) REFERENCES raza (nombre_especie, nombre_raza),
  PRIMARY KEY (id_mascota)

);

CREATE TABLE accesos(
  id varchar(15),
  nombre_rol varchar(15) NOT NULL ,

  PRIMARY KEY (id)
);

CREATE TABLE usuarios(
  cedula_id varchar(12),
  pass varchar(250) ,
  nombre varchar(60) NOT NULL ,
  direccion varchar(60) NOT NULL ,
  telefono varchar(15) NOT NULL ,
  fecha_reg TIMESTAMP NOT NULL DEFAULT NOW(),
  id_acceso varchar(15)NOT NULL references accesos(id) ,

  PRIMARY KEY(cedula_id)
);

CREATE TABLE empleados(
  cedula varchar(12) references usuarios(cedula_id),
  sueldo int NOT NULL CHECK (sueldo>=0)  ,

  PRIMARY KEY (cedula)
);

CREATE TABLE gerentes(
  cedula varchar(12) references usuarios(cedula_id) ,
  sueldo int NOT NULL CHECK (sueldo>=0)  ,
  rif_homepet varchar(12) NOT NULL references homepets(rif)  ,
  fecha_ini TIMESTAMP,

  PRIMARY KEY (cedula)
);

CREATE TABLE clientes(
  cedula varchar(12) references usuarios(cedula_id),
  email varchar (25) NOT NULL ,

  PRIMARY KEY (cedula)
);


CREATE TABLE fichas_servicio(
  id_ficha varchar(10),
  fec_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
  nombreAuth varchar(60) NOT NULL ,
  tlfAuth varchar(15) NOT NULL ,
  cedulaAuth varchar(12) NOT NULL ,
  fec_entrada TIMESTAMP NOT NULL ,
  fec_salidaest TIMESTAMP NOT NULL ,
  fec_salidareal TIMESTAMP,
  rif_homepet varchar(12) NOT NULL references homepets(rif),
  cedula_cliente varchar(12) NOT NULL references clientes(cedula),
  id_mascota varchar(15) NOT NULL references mascota(id_mascota),

  PRIMARY KEY (id_ficha)
);

CREATE TABLE reservas(
  id_reserva varchar(10) NOT NULL ,
  fec_entrada TIMESTAMP NOT NULL ,
  descripcion varchar(60) NOT NULL ,
  aplicada boolean NOT NULL ,
  id_fichaserv varchar(10) NOT NULL references fichas_servicio(id_ficha),

  PRIMARY KEY (id_reserva)
);


CREATE TABLE facturas(
  id_factura varchar(10),
  monto int NOT NULL CHECK(monto >=0)  ,
  fecha_creacion TIMESTAMP NOT NULL ,
  descuento int CHECK(descuento>=0),
  rif_homepet varchar(12) NOT NULL references homepets(rif) ,
  cedula_client varchar(12) NOT NULL references clientes(cedula) ,

  PRIMARY KEY (id_factura)
);

CREATE TABLE factura_serv(
  id_factura varchar(10) references facturas(id_factura),
  pagada boolean NOT NULL ,
  fec_pagada TIMESTAMP NOT NULL ,
  fichaserv varchar(10) NOT NULL references fichas_servicio(id_ficha),

  PRIMARY KEY (id_factura)
);

CREATE TABLE factura_tienda(
  id_factura varchar(10) references facturas(id_factura),

  PRIMARY KEY (id_factura)
);


CREATE TABLE modos_pago(
  nombre_modo varchar(25),

  PRIMARY KEY (nombre_modo)
);

CREATE TABLE productos(
  id_producto varchar(10),
  nombre_prod varchar(35) NOT NULL UNIQUE ,
  descripcion varchar(60) NOT NULL ,
  precio int NOT NULL CHECK(precio>=0),
  instrucciones varchar(70)NOT NULL ,
  nombre_especie varchar(15) NOT NULL references animal(nombre_especie),
  contenido varchar(25),

  PRIMARY KEY (id_producto)
);

CREATE TABLE comidas(
  id_comida varchar(10) references productos(id_producto),
  talla varchar(10) NOT NULL CHECK (talla IN ('S','M','L')),

  PRIMARY KEY(id_comida)
);

CREATE TABLE vacunas(
  id_vacuna varchar(10) references productos(id_producto),
  edad_aplicacion varchar(10) NOT NULL ,

  PRIMARY KEY (id_vacuna)
);

CREATE TABLE proveedores(
  rif_proveedor varchar(12),
  nombre_prov varchar(45) NOT NULL ,
  direccion varchar(60) NOT NULL ,
  nombre_contacto varchar(60) NOT NULL ,
  telefono_local varchar(15) NOT NULL ,
  telefono_movil varchar(15) NOT NULL ,

  PRIMARY KEY (rif_proveedor)
);

CREATE TABLE ordenes_compra(
  id_ordencompra varchar(15),
  fec_creacion_orden TIMESTAMP NOT NULL ,
  rif_prov varchar(12) NOT NULL references proveedores(rif_proveedor),
  rif_homepet varchar(12) NOT NULL references homepets(rif),

  PRIMARY KEY (id_ordencompra)
);

CREATE TABLE factura_proveedor(
  id_factura varchar(10) references facturas(id_factura),
  id_ordenCompra varchar(15) NOT NULL references ordenes_compra(id_ordencompra),
  rif_prov varchar(12) NOT NULL references proveedores(rif_proveedor),

  PRIMARY KEY (id_factura)
);

CREATE TABLE e_trabaja_h(
  cedula_empleado varchar(12) references empleados(cedula),
  rif_homepet varchar(12) references homepets(rif),
  fec_ini date ,

  PRIMARY KEY (cedula_empleado,rif_homepet,fec_ini)
);

CREATE TABLE E_realiza_serv(
  cedula_empleado varchar(12) references empleados(cedula),
  rif_homepet varchar(12) references homepets(rif),
  nombre_serv varchar(20) NOT NULL,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES servicios (rif,nombre),
  PRIMARY KEY (cedula_empleado,rif_homepet,nombre_serv)
);

CREATE TABLE ficha_x_serv(
  id_ficha varchar(10) references fichas_servicio(id_ficha),
  rif_homepet varchar(12) references homepets(rif),
  nombre_serv varchar(20) NOT NULL,
  cedula_emp varchar(12) NOT NULL ,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES servicios (rif,nombre),
  PRIMARY KEY (id_ficha,rif_homepet,nombre_serv)
);

CREATE TABLE e_x_actividad(
  cedula_emp varchar(12) references empleados(cedula),
  rif_homepet varchar(12) references homepets(rif),
  nombre_serv varchar(20) NOT NULL,
  id_actividad int NOT NULL,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES servicios (rif,nombre),
  FOREIGN KEY (rif_homepet, nombre_serv, id_actividad) REFERENCES actvidades (rif,nombre_serv, id_serial),

  PRIMARY KEY(cedula_emp,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE ficha_x_actividad(
  id_ficha varchar(10) references fichas_servicio(id_ficha),
  rif_homepet varchar(12) references homepets(rif),
  nombre_serv varchar(20) NOT NULL,
  id_actividad int NOT NULL,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES servicios (rif,nombre),
  FOREIGN KEY (rif_homepet, nombre_serv, id_actividad) REFERENCES actvidades (rif,nombre_serv, id_serial),

  cedula_emp varchar(12) NOT NULL references empleados(cedula),

  PRIMARY KEY (id_ficha,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE actividad_x_producto(
  id_producto varchar(10) references productos(id_producto),
  rif_homepet varchar(12) references homepets(rif),
  nombre_serv varchar(20) NOT NULL,
  id_actividad int NOT NULL, 
  cantidad varchar(15) NOT NULL,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES servicios (rif,nombre),
  FOREIGN KEY (rif_homepet, nombre_serv, id_actividad) REFERENCES actvidades (rif,nombre_serv, id_serial),
  PRIMARY KEY (id_producto,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE facturatienda_x_prod(
  id_factura varchar(10) references factura_tienda(id_factura),
  id_prod varchar(10) references productos(id_producto),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_factura,id_prod)
);

CREATE TABLE factura_x_modopago(
  id_factura varchar(10) references facturas(id_factura),
  nombre_modopago varchar(25) references modos_pago(nombre_modo),
  fecha date ,
  dato_modalidad varchar(20) NOT NULL ,
  monto_pago int NOT NULL CHECK (monto_pago>=0),

  PRIMARY KEY(id_factura,nombre_modopago,fecha)
);

CREATE TABLE producto_x_almacen(
  id_prod varchar(10) references productos(id_producto),
  id_almacen varchar(10) references almacen(id),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_prod,id_almacen)
);

CREATE TABLE homepet_x_proveedor(
  rif_homepet varchar(12) references homepets(rif),
  rif_proveedor varchar(12) references proveedores(rif_proveedor),

  PRIMARY KEY (rif_homepet,rif_proveedor)
);

CREATE TABLE proveedor_x_prod(
  rif_prov varchar(12) references proveedores(rif_proveedor),
  id_prod varchar(10) references productos(id_producto),
  fecha date,
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY (rif_prov,id_prod,fecha)
);

CREATE TABLE ordencompra_x_producto(
  id_orden varchar(15) references ordenes_compra(id_ordencompra),
  id_prod varchar(10) references productos(id_producto),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_orden,id_prod)
);

CREATE TABLE historia(
  rif_homepet varchar(12) references homepets(rif),
  cedula_cliente varchar(12) references clientes(cedula),
  id_mascota varchar(15) references mascota(id_mascota),
  fecha date,

  PRIMARY KEY (rif_homepet,cedula_cliente,id_mascota,fecha)
);

CREATE TABLE enfermedades_masocta(
  id_mascota varchar(15) references mascota(id_mascota),
  nombre_enfermedad varchar(20),

  PRIMARY KEY (id_mascota,nombre_enfermedad)
);

CREATE TABLE vacunas_mascota(
  id_mascota varchar(15) references mascota(id_mascota),
  nombre_vacuna varchar(40),
  fecha  date,

  PRIMARY KEY(id_mascota,nombre_vacuna,fecha)
);

CREATE TABLE comida_porciondiaria_peso(
  id_comida varchar(10) references comidas(id_comida),
  porcion_g varchar(15),
  peso_kg varchar(15),

  PRIMARY KEY (id_comida,porcion_g,peso_kg)
);


INSERT INTO accesos VALUES ('1', 'usuario');
INSERT INTO accesos VALUES ('2', 'cliente');
INSERT INTO accesos VALUES ('3', 'empleado');
INSERT INTO accesos VALUES ('4', 'gerente');

INSERT INTO animal VALUES ('perro', 'Animal de cuatro patas amigable y confiable');
INSERT INTO animal VALUES ('gato', 'Animal de cuatro patas un poco mas odioso');
INSERT INTO animal VALUES ('hamster', 'Pequeño peludo y muy jugueton');

INSERT INTO modos_pago VALUES ('efectivo');
INSERT INTO modos_pago VALUES ('cheque');
INSERT INTO modos_pago VALUES ('tarjeta debito');
INSERT INTO modos_pago VALUES ('tarjeta credito');
INSERT INTO modos_pago VALUES ('transferencia');