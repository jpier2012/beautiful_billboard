module BeautifulBillboard
end

require 'colorize'
require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative './beautiful_billboard/version'
require_relative '../lib/beautiful_billboard/cli.rb'
require_relative '../lib/beautiful_billboard/scraper.rb'
require_relative '../lib/beautiful_billboard/star.rb'
require_relative '../lib/beautiful_billboard/hit.rb'
