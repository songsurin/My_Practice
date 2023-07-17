from django.db import models

class Salary(models.Model):
    name = models.TextField(max_length=50, blank=True, null=True)
    sal = models.IntegerField()
    bonus = models.IntegerField()
    total = models.IntegerField()
    tax = models.IntegerField()
    money = models.IntegerField()

