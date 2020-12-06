const paths = require("./paths");

const ManifestPlugin = require("webpack-manifest-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

module.exports = {
  entry: {
    main: paths.src + "/index.js",
  },
  output: {
    path: paths.build,
    filename: "[name].[hash].js",
    publicPath: "/",
  },
  module: {
    rules: [{ test: /\.js$/, exclude: /node_modules/, use: ["babel-loader"] }],
  },
  plugins: [new CleanWebpackPlugin(), new ManifestPlugin()],
};
