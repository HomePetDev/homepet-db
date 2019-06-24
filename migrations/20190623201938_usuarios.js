
exports.up = function(knex, Promise) {
  return knex.schema.raw(`
    CREATE TABLE usuarios (
      ci VARCHAR(50) NOT NULL PRIMARY KEY,
      password VARCHAR (250) NOT NULL,
      nombre VARCHAR (250) NOT NULL,   
      direccion VARCHAR (250) NOT NULL,   
      telefono VARCHAR (250) NOT NULL,   
      fecha_registro TIMESTAMP NOT NULL DEFAULT NOW(),
      foto_url VARCHAR(250)
    );
  `);
};

exports.down = function(knex, Promise) {
  return knex.schema.raw(`
    DROP TABLE usuarios;
  `);
};
