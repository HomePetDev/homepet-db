module.exports = {

  development: {
    client: 'pg',
    connection: {
      host : 'localhost',
      user : 'FLX',
      password : 'flx',
      database : 'homepet-db'
    }
  },
  production: {
    client: 'pg',
    connection: process.env.DATABASE_URL
  },
};