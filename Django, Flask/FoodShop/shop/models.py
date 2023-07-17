from django.db import models

class Member(models.Model):
    userid = models.CharField(max_length=50, null=False, primary_key=True)
    passwd = models.CharField(max_length=500, null=False)
    name = models.CharField(max_length=20, null=False)
    address = models.CharField(max_length=20, null=False)
    tel = models.CharField(max_length=20, null=True)

class Chat(models.Model):
    idx = models.AutoField(primary_key=True) #일련번호(자동증가)
    userid = models.CharField(max_length=50, null=False)
    query = models.CharField(max_length=500, null=False) #질문내용
    answer = models.CharField(max_length=1000, null=False)
    intent = models.CharField(max_length=50, null=False) #의도