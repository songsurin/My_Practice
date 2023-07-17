from django.db import models

class Keyword(models.Model):
    word = models.CharField(max_length=50, null=False)