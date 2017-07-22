require './base_crawler'

class JobsLannickgroupCom < BaseCrawler
  def initialize
    super
  end

  def main
    crawler_jobs(read_page)
  end

  def define_constants
    @base_url = 'http://jobs.lannickgroup.com'.freeze
    @list_url = '/search_results.aspx?section=1&key=&loc=0&spec=0&empl=0'
  end

  def print_csv_header
   puts '"TITLE"; "LOCATION"; "TYPE"; "URL"; "SALARY"'
  end

  def read_page
    Nokogiri::HTML(open(@base_url + @list_url))
  end

  def crawler_jobs(page)
    rows = page.css("table#BasicContent_mainContentlevel2_gvSearchResults")

    rows.css("tr").each do |row|
      next if row.css("td").empty?

      job_title    = row.css("td")[0].text.strip
      job_location = row.css("td")[2].text
      job_type     = ''
      job_salary   = row.css("td")[1].text
      job_url      = row.css("a").first['href']

      puts format(
        '"%s"; "%s"; "%s"; "%s"; "%s"',
          job_title,
          job_location,
          job_type,
          @base_url + '/' + job_url,
          job_salary
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

JobsLannickgroupCom.new
