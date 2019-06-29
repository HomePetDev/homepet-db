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
  talla varchar(10) NOT NULL CHECK (talla IN ('S','M','L')),
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

CREATE TABLE hmpet.factura_tienda(
  id_factura varchar(10) references hmpet.facturas(id_factura),

  PRIMARY KEY (id_factura)
);

CREATE TABLE hmpet.factura_proveedor(
  id_factura varchar(10) references hmpet.facturas(id_factura),
  id_ordenCompra varchar(15) NOT NULL references hmpet.ordenes_compra(id_ordencompra),
  rif_prov varchar(12) NOT NULL references hmpet.proveedores(rif_proveedor),

  PRIMARY KEY (id_factura)
);

CREATE TABLE hmpet.modos_pago(
  nombre_modo varchar(25),

  PRIMARY KEY (nombre_modo)
);

CREATE TABLE hmpet.productos(
  id_producto varchar(10),
  nombre_prod varchar(35) NOT NULL UNIQUE ,
  descripcion varchar(60) NOT NULL ,
  precio int NOT NULL CHECK(precio>=0),
  instrucciones varchar(70)NOT NULL ,
  nombre_especie varchar(15) NOT NULL references hmpet.animal(nombre_especie),
  contenido varchar(25),

  PRIMARY KEY (id_producto)
);

CREATE TABLE hmpet.comidas(
  id_comida varchar(10) references hmpet.productos(id_producto),
  talla varchar(10) NOT NULL CHECK (talla IN ('S','M','L')),

  PRIMARY KEY(id_comida)
);

CREATE TABLE hmpet.vacunas(
  id_vacuna varchar(10) references hmpet.productos(id_producto),
  edad_aplicacion varchar(10) NOT NULL ,

  PRIMARY KEY (id_vacuna)
);

CREATE TABLE hmpet.proveedores(
  rif_proveedor varchar(12),
  nombre_prov varchar(45) NOT NULL ,
  direccion varchar(60) NOT NULL ,
  nombre_contacto varchar(60) NOT NULL ,
  telefono_local varchar(15) NOT NULL ,
  telefono_movil varchar(15) NOT NULL ,

  PRIMARY KEY (rif_proveedor)
);

CREATE TABLE hmpet.ordenes_compra(
  id_ordencompra varchar(15),
  fec_creacion_orden date NOT NULL ,
  rif_prov varchar(12) NOT NULL references hmpet.proveedores(rif_proveedor),
  rif_homepet varchar(12) NOT NULL references hmpet.homepets(rif),

  PRIMARY KEY (id_ordencompra)
);

CREATE TABLE hmpet.e_trabaja_h(
  cedula_empleado varchar(12) references hmpet.empleados(cedula),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  fec_ini date ,

  PRIMARY KEY (cedula_empleado,rif_homepet,fec_ini)
);

CREATE TABLE hmpet.E_realiza_serv(
  cedula_empleado varchar(12) references hmpet.empleados(cedula),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) references hmpet.servicios(nombre),

  PRIMARY KEY (cedula_empleado,rif_homepet,nombre_serv)
);

CREATE TABLE hmpet.ficha_x_serv(
  id_ficha varchar(10) references hmpet.fichas_servicio(id_ficha),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) references hmpet.servicios(nombre),
  cedula_emp varchar(12) NOT NULL ,

  PRIMARY KEY (id_ficha,rif_homepet,nombre_serv)
);

CREATE TABLE hmpet.e_x_actividad(
  cedula_emp varchar(12) references hmpet.empleados(cedula),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) references hmpet.servicios(nombre),
  id_actividad int NOT NULL references hmpet.actvidades(id_serial),

  PRIMARY KEY(cedula_emp,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE hmpet.ficha_x_actividad(
  id_ficha varchar(10) references hmpet.fichas_servicio(id_ficha),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) references hmpet.servicios(nombre),
  id_actividad int references hmpet.actvidades(id_serial),
  cedula_emp varchar(12) NOT NULL references hmpet.empleados(cedula),

  PRIMARY KEY (id_ficha,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE hmpet.actividad_x_producto(
  id_producto varchar(10) references hmpet.productos(id_producto),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) references hmpet.servicios(nombre),
  id_actividad int references hmpet.actvidades(id_serial),
  cantidad varchar(15) NOT NULL,

  PRIMARY KEY (id_producto,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE hmpet.facturatienda_x_prod(
  id_factura varchar(10) references hmpet.factura_tienda(id_factura),
  id_prod varchar(10) references hmpet.productos(id_producto),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_factura,id_prod)
);

CREATE TABLE hmpet.factura_x_modopago(
  id_factura varchar(10) references hmpet.facturas(id_factura),
  nombre_modopago varchar(25) references hmpet.modos_pago(nombre_modo),
  fecha date ,
  dato_modalidad varchar(20) NOT NULL ,
  monto_pago int NOT NULL CHECK (monto_pago>=0),

  PRIMARY KEY(id_factura,nombre_modopago,fecha)
);

CREATE TABLE hmpet.producto_x_almacen(
  id_prod varchar(10) references hmpet.productos(id_producto),
  id_almacen varchar(10) references hmpet.almacen(id),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_prod,id_almacen)
);

CREATE TABLE hmpet.homepet_x_proveedor(
  rif_homepet varchar(12) references hmpet.homepets(rif),
  rif_proveedor varchar(12) references hmpet.proveedores(rif_proveedor),

  PRIMARY KEY (rif_homepet,rif_proveedor)
);

CREATE TABLE hmpet.proveedor_x_prod(
  rif_prov varchar(12) references hmpet.proveedores(rif_proveedor),
  id_prod varchar(10) references hmpet.productos(id_producto),
  fecha date,
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY (rif_prov,id_prod,fecha)
);

CREATE TABLE hmpet.ordencompra_x_producto(
  id_orden varchar(15) references hmpet.ordenes_compra(id_ordencompra),
  id_prod varchar(10) references hmpet.productos(id_producto),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_orden,id_prod)
);

CREATE TABLE hmpet.historia(
  rif_homepet varchar(12) references hmpet.homepets(rif),
  cedula_cliente varchar(12) references hmpet.clientes(cedula),
  id_mascota varchar(15) references hmpet.mascota(id_mascota),
  fecha date,

  PRIMARY KEY (rif_homepet,cedula_cliente,id_mascota,fecha)
);

CREATE TABLE hmpet.enfermedades_masocta(
  id_mascota varchar(15) references hmpet.mascota(id_mascota),
  nombre_enfermedad varchar(20),

  PRIMARY KEY (id_mascota,nombre_enfermedad)
);

CREATE TABLE hmpet.vacunas_mascota(
  id_mascota varchar(15) references hmpet.mascota(id_mascota),
  nombre_vacuna varchar(40),
  fecha  date,

  PRIMARY KEY(id_mascota,nombre_vacuna,fecha)
);

CREATE TABLE hmpet.comida_porciondiaria_peso(
  id_comida varchar(10) references hmpet.comidas(id_comida),
  porcion_g varchar(15),
  peso_kg varchar(15),

  PRIMARY KEY (id_comida,porcion_g,peso_kg)
);



