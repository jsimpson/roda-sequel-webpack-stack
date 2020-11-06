const paths = require("./paths");
const merge = require("webpack-merge");
const common = require("./webpack.common.js");

module.exports = merge(common, {
  mode: "production",
  devtool: false,
  output: {
    path: paths.build,
    publicPath: "/",
    filename: "js/[name].[contenthash].bundle.js",
  },
  plugins: [],
  module: {
    rules: [{}],
  },
  optimization: {
    minimize: false,
    runtimeChunk: {
      name: "runtime",
    },
  },
  performance: {
    hints: false,
    maxEntrypointSize: 512000,
    maxAssetSize: 512000,
  },
});
