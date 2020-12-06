This project is a web application skeleton made up of [roda](https://github.com/jeremyevans/roda) as the web framework and [sequel](https://github.com/jeremyevans/sequel) as the database layer with [webpack](https://github.com/webpack/webpack) for the front-end.

It is based on Jeremy Evan's [roda-sequel-stack](https://github.com/jeremyevans/roda-sequel-stack) and Tania Rascia's [webpack-boilerplate](https://github.com/taniarascia/webpack-boilerplate).

The webpack helper, that provides the `webpack_tag`, was lifted directly from [here](https://github.com/choonggg/fusrodah/) with very little changes.

# Development

To start up the backend: `$ bundle exec rerun -b --no-notify --ignore 'frontend/*' -- rackup --port=3000`.

To start up the webpack-dev-server: `$ npm run start`.
