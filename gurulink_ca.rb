require './base_crawler'

class GurulinkCa < BaseCrawler
  def initialize
    super
  end

  def main
    crawler_jobs(read_page)
  end

  def define_constants
    @base_url = 'http://gurulink.ca'.freeze
    @list_url = '/jobsearch.asp'
  end

  def print_csv_header
   puts '"TITLE"; "LOCATION"; "TYPE"; "URL"'
  end

  def read_page
    Nokogiri::HTML(open(@base_url + @list_url))
  end

  def crawler_jobs(page)
    rows = page.css("table.persist-area")

    rows.css("tr").each do |row|
      next if row.css("td").empty?

        job_title    = row.css("td")[0].text
        job_location = row.css("td")[1].text
        job_type     = row.css("td")[2].text
        job_url      = row.css("a").first['href']

        puts format(
          '"%s"; "%s"; "%s"; "%s"',
            job_title,
            job_location,
            job_type,
            @base_url + '/' + job_url
        )
    end

    if next_page?(page)
      @list_url = '/jobsearch.asp' + page.css("div.internalcontent a")[-2]['href']
      page = crawler_jobs(read_page)
    end
  end

  def next_page?(page)
    return false if page.css("div.internalcontent a")[-2].nil?
    !!page.css("div.internalcontent a")[-2].text.match(/Next/)
  end
end

GurulinkCa.new
