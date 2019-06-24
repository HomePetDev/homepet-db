
exports.up = function(knex, Promise) {
  return knex.schema.raw(`
    CREATE TABLE homepets (
      rif VARCHAR (20) PRIMARY KEY,
      capacidad INTEGER NOT NULL, 
      ciudad VARCHAR (60) NOT NULL,
      sector VARCHAR (60) NOT NULL,
      calle VARCHAR (60) NOT NULL,
      fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW()
    );
  `);
};

exports.down = function(knex, Promise) {
  return knex.schema.raw(`
    DROP TABLE homepets;
  `);
};
