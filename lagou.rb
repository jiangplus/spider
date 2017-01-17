require 'watir'
require 'oga'
require 'json'
require 'rest-client'

def extract_data(html)
  doc = Oga.parse_html(html)
  items = doc.css('li.con_list_item')
  item = items.map { |item|

    {
      position_name: item.attribute('data-positionname').value,
      company_full_name: item.attribute('data-company').value,
      salary: item.attribute('data-salary').value,
      create_time: item.css('.format-time').first.text,
      position_advantage: item.css('.li_b_r').first.text,
      position_id: item.attribute('data-positionid').value,
      company_id: item.attribute('data-companyid').value,
    }
  }
end

def save_json(filename, data)
  JSON.dump(data)
  open(filename, 'w+') do |f|
    f.write(data)
  end
end

browser = Watir::Browser.new :chrome
browser.driver.manage.timeouts.implicit_wait = 3
browser.goto 'https://www.lagou.com/'
s = browser.link :text => '北京站'
s.click if s.exist?
sleep(8)

$result = []

home_url = 'https://www.lagou.com/jobs/list_%E7%88%AC%E8%99%AB?px=default&city=%E5%85%A8%E5%9B%BD#filterBox'
browser.goto home_url
data = extract_data(browser.body.html)
$result += data
(2..21).map { |page|
  sleep(0.2)
  link = browser.span :text => page.to_s
  link.click
  sleep(0.4)
  data = extract_data(browser.body.html)
  $result += data
}

save_json('data.json', $result)
p $result


company_info_list = $result.map do |i|
  sleep(1)
  url = 'https://www.lagou.com/gongsi/%s.html' % i[:company_id]
  html = RestClient.get(url)
  Oga.parse_html(page.body).css('.company_intro_text').text
end

job_info_list = $result.map do |i|
  sleep(1)
  url = 'https://www.lagou.com/jobs/%s.html' % i[:position_id]
  html = RestClient.get(url)
  Oga.parse_html(page.body).css('.work_addr').text.gsub(/\s/, '').gsub('查看地图', '')
end

data = $result.zip(company_info_list).zip(job_info_list)
result_data = data.map do |item|
  item[0][:company_info] = item[1]
  item[0][:address] = item[2]
  item[0]
end
save_json('result.json', result_data)





