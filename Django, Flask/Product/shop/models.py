from django.db import models

class Product(models.Model):
    product_code = models.AutoField(primary_key=True)
    product_name = models.CharField(null=False, max_length=100)
    price = models.IntegerField(default=0)
    description = models.TextField(null=False)
    filename = models.CharField(null=True, blank=True, default="", max_length=500)