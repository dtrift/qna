const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

const handlebars = require('./loaders/handlebars')
const pug = require('./loaders/pug')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

environment.loaders.prepend('handlebars', handlebars)
environment.loaders.prepend('pug', pug)

module.exports = environment
