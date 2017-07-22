require './base_crawler'

class ElutaCa < BaseCrawler
  def initialize
    super
  end

  def main
    crawler_jobs(read_page)
  end

  def define_constants
    @base_url = 'http://www.eluta.ca'.freeze
    @list_url = '/search?q=*&l=Toronto&qc='
  end

  def print_csv_header
    puts '"TITLE"; "LOCATION"; "TYPE"; "URL"'
  end

  def read_page
    Nokogiri::HTML(open(@base_url + @list_url))
  end

  def crawler_jobs(page)
    rows = page.css('#organic-jobs')

    rows.css("h2").each do |row|
      job_title    = row.css("span")[0].values[2]
      job_url      = row.css("span")[0].values[1]

      next if job_url.nil?

      puts format(
        '"%s"; "%s"; "Toronto";',
          job_title,
          @base_url + extract_link(job_url)
      )
    end

    if next_page?(page)
      @list_url = next_link(page)
      page = crawler_jobs(read_page)
    end
  end

  def next_page?(page)
    return false if page.css("#pager-next").nil?
    true
  end

  def next_link(page)
    /'(.*)'/.match(page.css("#pager-next")[0].values[1])[1]
  end

  def extract_link(link)
    /'(.*)'/.match(link)[1][1..-1]
  end
end

ElutaCa.new

