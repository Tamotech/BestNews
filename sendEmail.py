#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
import smtplib
from email.mime.text import MIMEText
from email.header import Header
 
# 第三方 SMTP 服务
mail_host="smtp.qq.com"  #设置服务器
mail_user="1134532311@qq.com"    #用户名
mail_pass="gzzdleendkbqjfed"   #口令 

sender = '1134532311@qq.com'
receivers = ['1134532311@qq.com', '619375143@qq.com', '2627049476@qq.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱
 
# 三个参数：第一个为文本内容，第二个 plain 设置文本格式，第三个 utf-8 设置编码
message = MIMEText('BestNews: iOS客户端打包上传完成! 详情请见 https://www.pgyer.com/manager/dashboard/app/8d846fc8729f93ec2dbdd26854a4f385', 'plain', 'utf-8')
message['From'] = "武淅"   # 发送者
message['To'] =  "测试"       # 接收者
 
subject = 'BestNews: iOS客户端打包上传完成 '
message['Subject'] = Header(subject, 'utf-8')
 
 
try:
    smtpObj = smtplib.SMTP_SSL('smtp.qq.com', 465)
    smtpObj.login(mail_user, mail_pass)
    smtpObj.sendmail(sender, receivers, message.as_string())
    print("邮件发送成功")
except smtplib.SMTPException as e:
	print(str(e))
    # print("Error: 无法发送邮件")