# Homepet App Base de datos

## Instalacion 
```sh
  npm install -g knex
  cd homepet-db
  npm install
```


Recordar configurar el archivo `knexfile.js` con su correspondiente configuracion

```sh
  module.exports = {
    development: {
      client: 'pg',
      connection: {
        host : 'localhost',
        user : 'tu-usuario',
        password : 'tu-contraseña',
        database : 'tu-base-de-datos' #nombre elegido homepet-db
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
  init [options]                         Create a fresh knexfile.
  migrate:make [options] <name>          Create a named migration file.
  migrate:latest [options]               Run all migrations that have not yet been run.
  migrate:rollback [options]             Rollback the last set of migrations performed.
  migrate:currentVersion                 View the current version for the migration.
  seed:make [options] <name>             Create a named seed file.
  seed:run [options]                     Run seed files.

```