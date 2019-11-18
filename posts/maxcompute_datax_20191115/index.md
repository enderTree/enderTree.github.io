---

title: 阿里云maxcompute数据同步问题
slug: maxcompute_datax_20191115
date: 2019-11-18 10:04:35 UTC+08:00
tags: markdown
category: markdown
author: ender

---
# 阿里云maxcompute数据同步问题
## 
```log
上周五快要下班时，客服反馈了个问题，表示前端展示有问题，经过一番排查，定位到问题是阿里云数据同步组件报错：错误如下：
	2019-11-15 18:29:01.882 [176031158-0-1-writer] WARN  CommonRdbmsWriter$Task - 回滚此次写入, 采用每次写入一行方式提交. 因为:java.sql.BatchUpdateException: Duplicate entry '*******' for key 'uk_'*******''
	Caused by: com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException: Duplicate entry ''*******'' for key 'uk_'*******''
		
但是数据同步组件我们设置的是：主键冲突时：on duplicate key update(当主键/约束冲突update数据)
```
​	![https://endertree.github.io/galleries/TIM_20191118100942.thumbnail.png]()
​	并且看日志中的sql也是对的：

    ```sql
    INSERT INTO %s (is_delete,product_version,total_period,current_period,ackamt,realrepay_dt,subamt,repay_dt,category,`subject`,productname,productid,main_productid,custno,apdt) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE is_delete=VALUES(is_delete),product_version=VALUES(product_version),total_period=VALUES(total_period),current_period=VALUES(current_period),ackamt=VALUES(ackamt),realrepay_dt=VALUES(realrepay_dt),subamt=VALUES(subamt),repay_dt=VALUES(repay_dt),category=VALUES(category),`subject`=VALUES(`subject`),productname=VALUES(productname),productid=VALUES(productid),main_productid=VALUES(main_productid),custno=VALUES(custno),apdt=VALUES(apdt)
    ```
    按照这种语法是不会出现主键约束冲突的，但事实就摆在眼前，很奇怪的报错，我们仔细对比了数据同步任务的各个字段，也查询了表中的数据，最后我们把上面sql拼接好，放到数据库中运行，发现还是报错，错误是一样的。
    接下来，我们复制了一次目标表，里面放置一条报错的数据，再次使用sql进行插入，发现不报错了，这个时候我们突发奇想这张表的自增长主键会不会出问题了，一看发现已达int 11的最大值：AUTO_INCREMENT=2147483647
    不得已我们把字段类型变为bigint。
    以上。



