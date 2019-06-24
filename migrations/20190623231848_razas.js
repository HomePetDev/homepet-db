
exports.up = function(knex, Promise) {
  return knex.schema.raw(`
    CREATE TABLE razas (
      nombre_especie VARCHAR(50) NOT NULL,
      nombre_raza VARCHAR(50) NOT NULL,
      PRIMARY KEY (nombre_especie, nombre_raza),
      FOREIGN KEY (nombre_especie) REFERENCES animales(nombre_especie),
      id SERIAL NOT NULL,
      descripcion VARCHAR (250) NOT NULL,
      pais VARCHAR (250) NOT NULL,
      nivel_inteligencia VARCHAR (50) NOT NULL,
      contextura_fuerte CHAR(1) NOT NULL,
      talla CHAR(1) NOT NULL, 
      color_plaje VARCHAR(20) NOT NULL
    );
  `);
};

exports.down = function(knex, Promise) {
  
};
