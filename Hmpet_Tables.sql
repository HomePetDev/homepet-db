CREATE SCHEMA hmpet;

CREATE TABLE hmpet.homepets (
  rif varchar(12),
  capacidad int NOT NULL ,
  ciudad varchar(15) NOT NULL ,
  sector varchar(15) NOT NULL ,
  fecha_creacion date NOT NULL ,
  especializacion varchar(15) NOT NULL references hmpet.animal(nombre_especie)  ,

  PRIMARY KEY (rif)
);

CREATE TABLE hmpet.servicios (
  rif varchar(12) references hmpet.homepets(rif),
  nombre varchar(20),
  desc_servicio varchar(60) NOT NULL ,

  PRIMARY KEY(rif,nombre)

);

CREATE TABLE hmpet.actvidades(
  rif varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(15) references hmpet.servicios(nombre),
  id_serial int,
  desc_actividad varchar(60) NOT NULL ,
  precio int NOT NULL CHECK(precio>=0)  ,

  PRIMARY KEY(rif,nombre_serv,id_serial)

);

CREATE TABLE hmpet.almacen(
  id varchar(10),
  capacidad_alamcen int NOT NULL ,
  rifHmpet varchar(12)NOT NULL  references hmpet.homepets(rif) ,

  PRIMARY KEY (id)

);

CREATE TABLE hmpet.animal(
  nombre_especie varchar(15),
  desc_especie varchar(60) NOT NULL ,

  PRIMARY KEY (nombre_especie)
);

CREATE TABLE hmpet.mascota(
  id_mascota varchar(15),
  nombre varchar(20) NOT NULL ,
  fecha_nac date NOT NULL ,
  sexo char NOT NULL CHECK (sexo = 'F' OR sexo = 'M')  ,
  edad int NOT NULL CHECK (edad>=0)  ,
  cantidad varchar(25) NOT NULL ,
  alimento varchar(25) NOT NULL ,
  nombre_especie varchar(15) NOT NULL references hmpet.animal(nombre_especie) ,
  nomb_raza varchar(15) NOT NULL references hmpet.raza(nombre_raza) ,
  id_vet varchar(12) NOT NULL references hmpet.veterinario(id)  ,
  cedula_owner varchar(12) NOT NULL ,

  PRIMARY KEY (id_mascota)

);

CREATE TABLE hmpet.raza(
  nomb_especie varchar(15)references hmpet.animal(nombre_especie),
  nombre_raza varchar(15),
  descripcion varchar(40) NOT NULL ,
  pais varchar(15) NOT NULL ,
  iq int NOT NULL ,
  contextura varchar(20) NOT NULL ,
  talla varchar(10) NOT NULL ,
  color varchar(20) NOT NULL ,
  altura varchar(15) NOT NULL ,
  peso varchar(15) NOT NULL ,

  PRIMARY KEY(nomb_especie,nombre_raza)
);

CREATE TABLE hmpet.veterinario(
  id varchar(12),
  nombre_vet varchar(60) NOT NULL ,
  telefono varchar(15)  ,

  PRIMARY KEY (id)
);

CREATE TABLE hmpet.fichas_servicio(
  id_ficha varchar(10),
  fec_creacion date NOT NULL ,
  nombreAuth varchar(60) NOT NULL ,
  tlfAuth varchar(15) NOT NULL ,
  cedulaAuth varchar(12) NOT NULL ,
  fec_entrada date NOT NULL ,
  fec_salidaest date NOT NULL ,
  fec_salidareal date,
  rif_homepet varchar(12) NOT NULL references hmpet.homepets(rif),
  cedula_cliente varchar(12) NOT NULL references hmpet.clientes(cedula),
  id_mascota varchar(15) NOT NULL references hmpet.mascota(id_mascota),

  PRIMARY KEY (id_ficha)
);

CREATE TABLE hmpet.reservas(
  id_reserva varchar(10) NOT NULL ,
  fec_entrada date NOT NULL ,
  descripcion varchar(60) NOT NULL ,
  aplicada boolean NOT NULL ,
  id_fichaserv varchar(10) NOT NULL references hmpet.fichas_servicio(id_ficha),

  PRIMARY KEY (id_reserva)
);

CREATE TABLE hmpet.accesos(
  id varchar(15),
  nombre_rol varchar(15) NOT NULL ,

  PRIMARY KEY (id)
);

CREATE TABLE hmpet.usuarios(
  cedula_id varchar(12),
  pass varchar(15) ,
  nombre varchar(60) NOT NULL ,
  direccion varchar(60) NOT NULL ,
  telefono varchar(15) NOT NULL ,
  fecha_reg date NOT NULL ,
  id_acceso varchar(15)NOT NULL references hmpet.accesos(nombre_rol) ,

  PRIMARY KEY(cedula_id)
);

CREATE TABLE hmpet.empleados(
  cedula varchar(12) references hmpet.usuarios(cedula_id),
  sueldo int NOT NULL CHECK (sueldo>=0)  ,

  PRIMARY KEY (cedula)
);

CREATE TABLE hmpet.gerentes(
  cedula varchar(12) references hmpet.usuarios(cedula_id) ,
  sueldo int NOT NULL CHECK (sueldo>=0)  ,
  rif_homepet varchar(12) NOT NULL references hmpet.homepets(rif)  ,
  fecha_ini date,

  PRIMARY KEY (cedula)
);

CREATE TABLE hmpet.clientes(
  cedula varchar(12) references hmpet.usuarios(cedula_id),
  email varchar (25) NOT NULL ,

  PRIMARY KEY (cedula)
);

CREATE TABLE hmpet.facturas(
  id_factura varchar(10),
  monto int NOT NULL CHECK(monto >=0)  ,
  fecha_creacion date NOT NULL ,
  descuento int CHECK(descuento>=0),
  rif_homepet varchar(12) NOT NULL references hmpet.homepets(rif) ,
  cedula_client varchar(12) NOT NULL references hmpet.clientes(cedula) ,

  PRIMARY KEY (id_factura)
);

CREATE TABLE hmpet.factura_serv(
  id_factura varchar(10) references hmpet.facturas(id_factura),
  pagada boolean NOT NULL ,
  fec_pagada date NOT NULL ,
  fichaserv varchar(10) NOT NULL references hmpet.fichas_servicio(id_ficha),

  PRIMARY KEY (id_factura)
);

