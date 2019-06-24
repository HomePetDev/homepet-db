
exports.up = function(knex, Promise) {
  return knex.schema.raw(`
    CREATE TABLE animales( 
      nombre_especie VARCHAR(50) PRIMARY KEY
    )
  `);
};

exports.down = function(knex, Promise) {
  return knex.schema.raw(`
    DROP TABLE animales;
  `);
};
