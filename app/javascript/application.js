// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
import "./turbo_actions"
import jquery from "jquery"
window.$ = window.jQuery = jquery
window.bootstrap = require("bootstrap")
