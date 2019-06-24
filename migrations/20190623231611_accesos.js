
exports.up = function(knex, Promise) {
  return knex.schema.raw(`
     CREATE TABLE accesos (
       id SERIAL PRIMARY KEY,
       descripcion VARCHAR(250) NOT NULL
    )
  `);  
};

exports.down = function(knex, Promise) {
  return knex.schema.raw(`
    DROP TABLE accesos;
  `);
};
