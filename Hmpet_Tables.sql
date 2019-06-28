CREATE SCHEMA hmpet;

CREATE TABLE hmpet.homepets (
  rif varchar(12),
  capacidad int ,
  ciudad varchar(15),
  sector varchar(15),
  fecha_creacion date,
  especializacion varchar(15) references hmpet.animal(nombre_especie),

  PRIMARY KEY (rif)
);

CREATE TABLE hmpet.servicios (
  rif varchar(12) references hmpet.homepets(rif),
  nombre varchar(20),
  desc_servicio varchar(60),

  PRIMARY KEY(rif,nombre)

);

CREATE TABLE hmpet.actvidades(
  rif varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(15) references hmpet.servicios(nombre),
  id_serial int,
  desc_actividad varchar(60),
  precio int CHECK(precio>=0),

  PRIMARY KEY(rif,nombre_serv,id_serial)

);

CREATE TABLE hmpet.almacen(
  id varchar(10),
  capacidad_alamcen int,
  rifHmpet varchar(12) references hmpet.homepets(rif),

  PRIMARY KEY (id)

);

CREATE TABLE hmpet.animal(
  nombre_especie varchar(15),
  desc_especie varchar(60),

  PRIMARY KEY (nombre_especie)
);

CREATE TABLE hmpet.mascota(
  id_mascota varchar(15),
  nombre varchar(20),
  fecha_nac date,
  sexo char CHECK (sexo = 'F' OR sexo = 'M'),
  edad int CHECK (edad>=0),
  cantidad varchar(25),
  alimento varchar(25),
  nombre_especie varchar(15) references hmpet.animal(nombre_especie),
  nomb_raza varchar(15) references hmpet.raza(nombre_raza),
  id_vet varchar(12) references hmpet.veterinario(id),
  cedula_owner varchar(12),

  PRIMARY KEY (id_mascota)

);

CREATE TABLE hmpet.raza(
  nomb_especie varchar(15)references hmpet.animal(nombre_especie),
  nombre_raza varchar(15),
  descripcion varchar(40),
  pais varchar(15),
  iq int,
  contextura varchar(20),
  talla varchar(10),
  color varchar(20),
  altura varchar(15),
  peso varchar(15),

  PRIMARY KEY(nomb_especie,nombre_raza)
);

CREATE TABLE hmpet.veterinario(
  id varchar(12),
  nombre_vet varchar(60),
  telefono varchar(15),

  PRIMARY KEY (id)
);


CREATE TABLE hmpet.accesos(
  id varchar(15),
  nombre_rol varchar(15),

  PRIMARY KEY (id)
);

CREATE TABLE hmpet.usuarios(
  cedula_id varchar(12),
  pass varchar(15) ,
  nombre varchar(60),
  direccion varchar(60),
  telefono varchar(15),
  fecha_reg date,
  id_acceso varchar(15) references hmpet.accesos(nombre_rol),

  PRIMARY KEY(cedula_id)
);