require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'byebug'

class BaseCrawler
  def initialize
    define_constants
    print_csv_header
    read_page
    main
  end

  def main
    raise 'Must implement method: main'
  end

  def define_constants
    raise 'Must implement method: define_constants'
  end

  def print_csv_header
    raise 'Must implement print_csv_header'
  end

  def read_page
    raise 'Must implement read_page'
  end
end
