
拉勾网 Python 爬虫，使用 Scrapy 开发，运行：

```
scrapy runspider spider/spiders/lagou.py -o data.json
```

补充了使用浏览器进行抓取的ruby版本，在 `lagou.rb` 文件
数据文件在 `data/result.json` 文件，字段分别是：


  - position_name : 职位名称
  - company_full_name : 公司名称
  - salary : 薪酬水平
  - create_time : 发布日期
  - position_advantage : 职位诱惑
  - position_id : 职位id
  - company_id : 公司id
  - company_info : 公司简介
  - address : 工作地址

    
