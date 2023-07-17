from django.db import models

# Create your models here.

class Address(models.Model):
                # 상위
    idx = models.AutoField(primary_key=True)
    # 필드명   자동증가일련번호    PK
    name = models.CharField(max_length=50, blank=True, null=True)
    tel = models.CharField(max_length=50, blank=True, null=True)
    email = models.CharField(max_length=50, blank=True, null=True)
    address = models.CharField(max_length=500, blank=True, null=True)