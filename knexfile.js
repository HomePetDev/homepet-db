module.exports = {

  development: {
    client: 'pg',
    connection: {
      host : 'localhost',
      user : 'postgres',
      password : 'postgres',
      database : 'homepet-db'
    }
  },
  production: {
    client: 'pg',
    connection: process.env.DATABASE_URL
  },
};