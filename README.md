# Homepet App Base de datos

## Instalacion 
```sh
  npm install -g knex
  cd  homepet-db
  npm install
```
Recordar configurar el archivo `knexfile.js` con su correspondiente configuracion y crear la base de datos correspondiente `createdb nombre-bd`

```sh
  module.exports = {
    development: {
      client: 'pg',
      connection: {
        host : 'localhost',
        user : 'tu-usuario',
        password : 'tu-contraseña',
        database : 'nombre-bd'
      }
    },
    production: {
      client: 'pg',
      connection: process.env.DATABASE_URL
    },
  };


```

## Comandos basicos de knex

Pueden visualizar mas comando escribiendo `knex --help `

```sh
  knex init [options]                         Create a fresh knexfile.
  knex migrate:make [options] <name>          Create a named migration file.
  knex migrate:latest [options]               Run all migrations that have not yet been run.
  knex migrate:rollback [options]             Rollback the last set of migrations performed.
  knex migrate:currentVersion                 View the current version for the migration.
  knex seed:make [options] <name>             Create a named seed file.
  knex seed:run [options]                     Run seed files.

```