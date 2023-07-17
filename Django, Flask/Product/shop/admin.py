from django.contrib import admin
from shop.models import Product

class ProductAdmin(admin.ModelAdmin):
    list_display = ("product_name", "price", "description")

admin.site.register(Product, ProductAdmin)