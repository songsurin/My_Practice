from django.db import models

class Emp(models.Model):
    empno = models.IntegerField(primary_key=True)
    ename = models.CharField(max_length=50, null=False)
    deptno = models.IntegerField(null=False)
# Create your models here.
