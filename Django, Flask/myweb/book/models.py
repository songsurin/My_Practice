from datetime import datetime
from django.db import models

# Create your models here.

class Book(models.Model):
    #     상위클래스
    idx = models.AutoField(primary_key=True)
#  필드명  자료형  자동증가일련번호   pk
    title = models.CharField(max_length=50, blank=True, null=True)
            #가변사이즈문자열
    author = models.CharField(max_length=20, blank=True, null=True)
    price = models.IntegerField(default=0)
    amount = models.IntegerField(default=0)