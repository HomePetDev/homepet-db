CREATE SCHEMA hmpet;

CREATE TABLE  hmpet.animal(
  nombre_especie varchar(15),
  desc_especie varchar(200) NOT NULL ,

  PRIMARY KEY (nombre_especie)
);

CREATE TABLE  hmpet.homepets (
  rif varchar(12),
  capacidad int NOT NULL ,
  ciudad varchar(100) NOT NULL ,
  sector varchar(100) NOT NULL ,
  telefono varchar(15) NOT NULL ,
  fecha_creacion TIMESTAMP  NOT NULL DEFAULT NOW() ,
  especializacion varchar(15) NOT NULL references hmpet.animal(nombre_especie),

  PRIMARY KEY (rif)
);

CREATE TABLE  hmpet.servicios (
  rif varchar(12) references hmpet.homepets(rif),
  nombre varchar(20),
  desc_servicio varchar(200) NOT NULL ,

  PRIMARY KEY(rif,nombre)

);

CREATE TABLE  hmpet.actividades(
  rif varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(15),
  id_serial int,
  desc_actividad varchar(200) NOT NULL ,
  precio int NOT NULL CHECK(precio>=0)  ,

  FOREIGN KEY (rif, nombre_serv ) REFERENCES hmpet.servicios (rif, nombre), 
  PRIMARY KEY(rif,nombre_serv,id_serial)

);

CREATE TABLE  hmpet.almacen(
  id varchar(10),
  capacidad int NOT NULL ,
  rifHmpet varchar(12)NOT NULL  references hmpet.homepets(rif) ,

  PRIMARY KEY (id)

);

CREATE TABLE  hmpet.raza(
  nombre_especie varchar(15)references hmpet.animal(nombre_especie),
  nombre_raza varchar(15),
  descripcion varchar(255) NOT NULL ,
  pais varchar(15) NOT NULL ,
  iq varchar(255) NOT NULL ,
  talla varchar(10) NOT NULL CHECK (talla IN ('S','M','L', 'XL')),
  color varchar(255) NOT NULL ,
  altura varchar(255) NOT NULL ,
  peso varchar(255) NOT NULL ,
  fotoUrl varchar(255),

  PRIMARY KEY(nombre_especie,nombre_raza)
);


CREATE TABLE  hmpet.veterinario(
  cedula varchar(12),
  nombre_vet varchar(60) NOT NULL ,
  telefono varchar(15)  ,

  PRIMARY KEY (cedula)
);


CREATE TABLE  hmpet.mascota(
  id_mascota varchar(15),
  nombre varchar(20) NOT NULL ,
  fecha_nac TIMESTAMP NOT NULL ,
  sexo char NOT NULL CHECK (sexo = 'F' OR sexo = 'M')  ,
  edad int NOT NULL CHECK (edad>=0)  ,
  cantidad varchar(25) NOT NULL ,
  alimento varchar(25) NOT NULL ,
  nombre_especie varchar(15) NOT NULL references hmpet.animal(nombre_especie) ,
  nombre_raza varchar(15) NOT NULL,
  cedula_vet varchar(12) references hmpet.veterinario(cedula)  ,
  cedula_owner varchar(12) NOT NULL ,

  FOREIGN KEY (nombre_especie, nombre_raza) REFERENCES hmpet.raza (nombre_especie, nombre_raza),
  PRIMARY KEY (id_mascota)

);

CREATE TABLE  hmpet.accesos(
  id INT NOT NULL,
  nombre_rol varchar(15) NOT NULL ,

  PRIMARY KEY (id)
);

CREATE TABLE  hmpet.usuarios(
  cedula_id varchar(12),
  pass varchar(250) ,
  nombre varchar(60) NOT NULL ,
  direccion varchar(60) NOT NULL ,
  telefono varchar(15) NOT NULL ,
  fecha_reg TIMESTAMP NOT NULL DEFAULT NOW(),
  id_acceso INT NOT NULL DEFAULT 1 references hmpet.accesos(id) ,

  PRIMARY KEY(cedula_id)
);

CREATE TABLE  hmpet.empleados(
  cedula varchar(12) references hmpet.usuarios(cedula_id) ON DELETE RESTRICT ON UPDATE RESTRICT ,
  sueldo bigint NOT NULL CHECK (sueldo>=0)  ,

  PRIMARY KEY (cedula)
);

CREATE TABLE  hmpet.gerentes(
  cedula varchar(12) references hmpet.usuarios(cedula_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  sueldo bigint NOT NULL CHECK (sueldo>=0)  ,
  rif_homepet varchar(12) NOT NULL references hmpet.homepets(rif) ON DELETE CASCADE ON UPDATE RESTRICT  ,
  fecha_ini TIMESTAMP NOT NULL DEFAULT NOW(),

  PRIMARY KEY (cedula)
);

CREATE TABLE  hmpet.clientes(
  cedula varchar(12) references hmpet.usuarios(cedula_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  email varchar (25) NOT NULL ,

  PRIMARY KEY (cedula)
);


CREATE TABLE  hmpet.fichas_servicio(
  id_ficha varchar(10),
  fec_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
  nombreAuth varchar(60) NOT NULL ,
  tlfAuth varchar(15) NOT NULL ,
  cedulaAuth varchar(12) NOT NULL ,
  fec_entrada TIMESTAMP NOT NULL ,
  fec_salidaest TIMESTAMP NOT NULL ,
  fec_salidareal TIMESTAMP,
  rif_homepet varchar(12) NOT NULL references hmpet.homepets(rif),
  cedula_cliente varchar(12) NOT NULL references hmpet.clientes(cedula),
  id_mascota varchar(15) NOT NULL references hmpet.mascota(id_mascota),

  PRIMARY KEY (id_ficha)
);

CREATE TABLE  hmpet.reservas(
  id_reserva varchar(10) NOT NULL ,
  fec_entrada TIMESTAMP NOT NULL ,
  descripcion varchar(60) NOT NULL ,
  aplicada boolean NOT NULL ,
  id_fichaserv varchar(10) NOT NULL references hmpet.fichas_servicio(id_ficha),

  PRIMARY KEY (id_reserva)
);


CREATE TABLE  hmpet.facturas(
  id_factura varchar(10),
  monto int NOT NULL CHECK(monto >=0)  ,
  fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW() ,
  descuento int CHECK(descuento>=0),
  rif_homepet varchar(12) NOT NULL references hmpet.homepets(rif) ,
  cedula_client varchar(12) NOT NULL references hmpet.clientes(cedula) ,

  PRIMARY KEY (id_factura)
);

CREATE TABLE  hmpet.factura_serv(
  id_factura varchar(10) references hmpet.facturas(id_factura),
  pagada boolean NOT NULL ,
  fec_pagada TIMESTAMP NOT NULL ,
  fichaserv varchar(10) NOT NULL references hmpet.fichas_servicio(id_ficha),

  PRIMARY KEY (id_factura)
);

CREATE TABLE  hmpet.factura_tienda(
  id_factura varchar(10) references hmpet.facturas(id_factura),

  PRIMARY KEY (id_factura)
);


CREATE TABLE  hmpet.modos_pago(
  nombre_modo varchar(25),

  PRIMARY KEY (nombre_modo)
);

CREATE TABLE  hmpet.productos(
  id_producto varchar(10),
  nombre_prod varchar(35) NOT NULL UNIQUE ,
  descripcion varchar(200) NOT NULL , 
  precio int NOT NULL CHECK(precio>=0),
  instrucciones varchar(200)NOT NULL ,
  nombre_especie varchar(15) NOT NULL references hmpet.animal(nombre_especie),
  contenido varchar(25),

  PRIMARY KEY (id_producto)
);

CREATE TABLE  hmpet.comidas(
  id_comida varchar(10) references hmpet.productos(id_producto),
  talla varchar(10) NOT NULL CHECK (talla IN ('S','M','L', 'XL')),

  PRIMARY KEY(id_comida)
);

CREATE TABLE  hmpet.vacunas(
  id_vacuna varchar(10) references hmpet.productos(id_producto),
  edad_aplicacion varchar(10) NOT NULL ,

  PRIMARY KEY (id_vacuna)
);

CREATE TABLE  hmpet.proveedores(
  rif_proveedor varchar(12),
  nombre_prov varchar(45) NOT NULL ,
  direccion varchar(60) NOT NULL ,
  nombre_contacto varchar(60) NOT NULL ,
  telefono_local varchar(15) NOT NULL ,
  telefono_movil varchar(15) NOT NULL ,

  PRIMARY KEY (rif_proveedor)
);

CREATE TABLE  hmpet.ordenes_compra(
  id_ordencompra varchar(15),
  fec_creacion_orden TIMESTAMP NOT NULL DEFAULT NOW(),
  rif_prov varchar(12) NOT NULL references hmpet.proveedores(rif_proveedor),
  rif_homepet varchar(12) NOT NULL references hmpet.homepets(rif),

  PRIMARY KEY (id_ordencompra)
);

CREATE TABLE  hmpet.factura_proveedor(
  id_factura varchar(10) references hmpet.facturas(id_factura),
  id_ordenCompra varchar(15) NOT NULL references hmpet.ordenes_compra(id_ordencompra),
  rif_prov varchar(12) NOT NULL references hmpet.proveedores(rif_proveedor),

  PRIMARY KEY (id_factura)
);

CREATE TABLE  hmpet.e_trabaja_h(
  cedula_empleado varchar(12) references hmpet.empleados(cedula) ON DELETE CASCADE ON UPDATE RESTRICT,
  rif_homepet varchar(12) references hmpet.homepets(rif) ON DELETE CASCADE ON UPDATE RESTRICT ,
  fec_ini TIMESTAMP NOT NULL DEFAULT NOW() ,

  PRIMARY KEY (cedula_empleado,rif_homepet,fec_ini)
);

CREATE TABLE  hmpet.E_realiza_serv(
  cedula_empleado varchar(12) references hmpet.empleados(cedula),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) NOT NULL,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES hmpet.servicios (rif,nombre),
  PRIMARY KEY (cedula_empleado,rif_homepet,nombre_serv)
);

CREATE TABLE  hmpet.ficha_x_serv(
  id_ficha varchar(10) references hmpet.fichas_servicio(id_ficha),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) NOT NULL,
  cedula_emp varchar(12) NOT NULL ,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES hmpet.servicios (rif,nombre),
  PRIMARY KEY (id_ficha,rif_homepet,nombre_serv)
);

CREATE TABLE  hmpet.e_x_actividad(
  cedula_emp varchar(12) references hmpet.empleados(cedula),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) NOT NULL,
  id_actividad int NOT NULL,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES hmpet.servicios (rif,nombre),
  FOREIGN KEY (rif_homepet, nombre_serv, id_actividad) REFERENCES hmpet.actividades (rif,nombre_serv, id_serial),

  PRIMARY KEY(cedula_emp,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE  hmpet.ficha_x_actividad(
  id_ficha varchar(10) references hmpet.fichas_servicio(id_ficha),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) NOT NULL,
  id_actividad int NOT NULL,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES hmpet.servicios (rif,nombre),
  FOREIGN KEY (rif_homepet, nombre_serv, id_actividad) REFERENCES hmpet.actividades (rif,nombre_serv, id_serial),

  cedula_emp varchar(12) NOT NULL references hmpet.empleados(cedula),

  PRIMARY KEY (id_ficha,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE  hmpet.actividad_x_producto(
  id_producto varchar(10) references hmpet.productos(id_producto),
  rif_homepet varchar(12) references hmpet.homepets(rif),
  nombre_serv varchar(20) NOT NULL,
  id_actividad int NOT NULL, 
  cantidad varchar(15) NOT NULL,

  FOREIGN KEY (rif_homepet, nombre_serv) REFERENCES hmpet.servicios (rif,nombre),
  FOREIGN KEY (rif_homepet, nombre_serv, id_actividad) REFERENCES hmpet.actividades (rif,nombre_serv, id_serial),
  PRIMARY KEY (id_producto,rif_homepet,nombre_serv,id_actividad)
);

CREATE TABLE  hmpet.facturatienda_x_prod(
  id_factura varchar(10) references hmpet.factura_tienda(id_factura),
  id_prod varchar(10) references hmpet.productos(id_producto),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_factura,id_prod)
);

CREATE TABLE  hmpet.factura_x_modopago(
  id_factura varchar(10) references hmpet.facturas(id_factura),
  nombre_modopago varchar(25) references hmpet.modos_pago(nombre_modo),
  fecha date ,
  dato_modalidad varchar(20) NOT NULL ,
  monto_pago int NOT NULL CHECK (monto_pago>=0),

  PRIMARY KEY(id_factura,nombre_modopago,fecha)
);

CREATE TABLE  hmpet.producto_x_almacen(
  id_prod varchar(10) references hmpet.productos(id_producto),
  id_almacen varchar(10) references hmpet.almacen(id),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_prod,id_almacen)
);

CREATE TABLE  hmpet.homepet_x_proveedor(
  rif_homepet varchar(12) references hmpet.homepets(rif),
  rif_proveedor varchar(12) references hmpet.proveedores(rif_proveedor),

  PRIMARY KEY (rif_homepet,rif_proveedor)
);

CREATE TABLE  hmpet.proveedor_x_prod(
  rif_prov varchar(12) references hmpet.proveedores(rif_proveedor),
  id_prod varchar(10) references hmpet.productos(id_producto),
  fecha date,
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY (rif_prov,id_prod,fecha)
);

CREATE TABLE  hmpet.ordencompra_x_producto(
  id_orden varchar(15) references hmpet.ordenes_compra(id_ordencompra),
  id_prod varchar(10) references hmpet.productos(id_producto),
  cantidad varchar(15) NOT NULL ,

  PRIMARY KEY(id_orden,id_prod)
);

CREATE TABLE  hmpet.historia(
  rif_homepet varchar(12) references hmpet.homepets(rif),
  cedula_cliente varchar(12) references hmpet.clientes(cedula),
  id_mascota varchar(15) references hmpet.mascota(id_mascota),
  fecha date,

  PRIMARY KEY (rif_homepet,cedula_cliente,id_mascota,fecha)
);

CREATE TABLE  hmpet.enfermedades_mascota(
  id_mascota varchar(15) references hmpet.mascota(id_mascota),
  nombre_enfermedad varchar(20),

  PRIMARY KEY (id_mascota,nombre_enfermedad)
);

CREATE TABLE  hmpet.vacunas_mascota(
  id_mascota varchar(15) references hmpet.mascota(id_mascota),
  nombre_vacuna varchar(40),
  fecha  date,

  PRIMARY KEY(id_mascota,nombre_vacuna,fecha)
);

CREATE TABLE  hmpet.comida_porciondiaria_peso(
  id_comida varchar(10) references hmpet.comidas(id_comida),
  porcion_g varchar(15),
  peso_kg varchar(15),

  PRIMARY KEY (id_comida,porcion_g,peso_kg)
);


-- Típos de usuario
INSERT INTO hmpet.accesos VALUES ('1', 'usuario');
INSERT INTO hmpet.accesos VALUES ('2', 'cliente');
INSERT INTO hmpet.accesos VALUES ('3', 'empleado');
INSERT INTO hmpet.accesos VALUES ('4', 'gerente');

-- Animales
INSERT INTO hmpet.animal VALUES ('perro', 'Animal de cuatro patas amigable y confiable');
INSERT INTO hmpet.animal VALUES ('gato', 'Animal de cuatro patas un poco mas odioso');
INSERT INTO hmpet.animal VALUES ('hamster', 'Pequeño peludo y muy jugueton');
INSERT INTO hmpet.animal VALUES ('delfin', 'Animal acuatico muy inteligente');

-- Modos de pago
INSERT INTO hmpet.modos_pago VALUES ('efectivo');
INSERT INTO hmpet.modos_pago VALUES ('cheque');
INSERT INTO hmpet.modos_pago VALUES ('tarjeta debito');
INSERT INTO hmpet.modos_pago VALUES ('tarjeta credito');
INSERT INTO hmpet.modos_pago VALUES ('transferencia');

-- Razas
-- Perros
INSERT INTO hmpet.raza VALUES ('perro', 'mastin español', 
  'Un perro de gran talla, muy potente y robusto, pero a la vez es flexible y ágil. Le caracteriza su cabeza grande (pero proporcionada) y su papada. De ojos pequeños (en relación al craneo) y orejas medianas y caidas.',
  'españa', 'gran inteligencia' , 'XL' , 'color hay una gran variedad, amarillos, negros, leonados, cervatos... pueden ser uniformes (suelen ser los más apreciados) o combinados.' , 'Entre 72 y 88 cm', 'Entre 50 a 120 kg' , 
  'https://www.terranea.es/assets/images/razas/mastin_espanol2.jpg'
);

INSERT INTO hmpet.raza VALUES ('perro', 'san bernardo', 
  'Un perro de gran talla, muy potente y robusto, pero a la vez es flexible y ágil.',
  'suiza', 'gran inteligencia' , 'XL' , 'Blanco con grandes manchas de color marrón-rojizo.' , 'Entre 70 y 90 cm', 'Entre 55 a 90 Kg', 'http://www.todoperro.es/wallpapers/p-bernardo.jpg'
);


INSERT INTO hmpet.raza VALUES ('perro', 'gran danes', 
  'El Gran Danes es un excelente perro de guardia a la vez que perro de compañia. Muy cariñoso y fiel con sus dueños, especialmente si se trata de niños',
  'alemania', 'gran inteligencia' , 'XL' , 'leonado (desde colores pálidos hasta dorados intensos), atigrado, arlequín (parches negros y blancos), negro azabache y azul acero oscuro.' , 'Entre 72 y 80 cm', 'Entre 55 a 80 Kg',
  'http://www.todoperro.es/wallpapers/p-grandanes.jpg'
);

INSERT INTO hmpet.raza VALUES ('perro', 'rottweiler', 
  'Es una raza grande, de aspecto robusto, fuerte, bien proporcionado y compacto. De hocico profundo y amplio, con la trufa negra. Orejas caidas, pequeñas y con forma triangular.',
  'alemania', 'gran inteligencia' , 'L' , 'Son de negros con marcas pardo-rojizas bien delimitadas y situadas bajo la cola, en hocico, mejillas, garganta, pecho y extremidades principalmente.' , 'Entre 56 y 68 cm', 'Entre 55 a 80 Kg'
  'http://www.todoperro.es/fotos/originales/p8840.jpg'
);

INSERT INTO hmpet.raza VALUES ('perro', 'pastor aleman', 
  'El Pastor Alemán es una de las razas más populares, excelente trabajador, guardián, afectuoso y paciente con los más pequeños de la familia.',
  'alemania', 'gran inteligencia' , 'L' , 'Negro con marcas de colores marrón, amarillo, gris claro o café-rojizo. Pelaje doble con lanilla interna.' , 'Entre 55 y 65 cm', 'Entre 22 a 40 Kg',
  'http://www.todoperro.es/fotos/originales/p27162.jpg'
);

INSERT INTO hmpet.raza VALUES ('perro', 'bulldog ingles', 
  'Son perros que destacan por su valentía y su habilidad como guardiantes, siempre alerta. Su feroz apariencia esconde en realidad a un perro afectivo, leal y muy dependiente.',
  'gran bretaña', 'gran inteligencia' , 'M' , 'Pueden ser de un solo color, atigrados, leonados, con distintos tonos de rojo... Son bastante comunes los blancos combinados con otro color.' , 'Entre 30 y 40 cm', 'Entre 20 a 25 Kg',
  'http://www.todoperro.es/fotos/originales/p12820.jpg'
);


INSERT INTO hmpet.raza VALUES ('perro', 'dalmata', 
  'Se trata de perros amistosos y muy sensibles que necesitan la compañía del ser humano. Es necesario una buena socialización para evitar que se conviertan en timidos y reservados',
  'croacia', 'gran inteligencia' , 'M' , 'Blanco con manchas de color negro o hígado-marrón (son dos variedades, no mezcladas).' , 'Entre 54 y 60 cm', 'Entre 24 a 27 Kg',
  'https://www.curiosfera.com/wp-content/uploads/2018/04/dalmata.jpg'
);

INSERT INTO hmpet.raza VALUES ('perro', 'bulldog frances', 
  'Un perro de tamaño pequeño, musculoso y muy robusto, de aspecto regorderte. Destaca su hocico corto, las orejas ergidas y su nariz ancha muy corta y negra.',
  'francia', 'promedio' , 'S' , 'son de tono leonado uniforme con o sin parches blancos. Las manchas blancas pueden ser desde poco extendidas hasta completamente blancos.' , 'Entre 20 y 30 cm', 'Entre 8 a 14 Kg',
  'https://www.purina.es/sites/g/files/mcldtz1656/files/2019-06/frenchbull_400x378_0.jpg'
);

INSERT INTO hmpet.raza VALUES ('perro', 'chihuahua', 
  ' son mejor conocidos por su tamaño pequeño y sus largas y rectas orejas y su pelaje corto.',
  'mexico', 'promedio' , 'S' , 'negro sólido hasta blanco sólido, manchados, o en una variedad de colores como cervatillo (café), chocolate, azul (gris), plata, tricolores (chocolate, azul, o negro y blanco con marcas cafés y blancas), con líneas, y moteados. ' , 'Entre 16 y 20 cm', 'Entre 500g a 3 Kg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOitnc2F7uyE72eaxORqISdYhHo7y6Dit2YBS4q1AKqhRl2yKcRw'
);
