from django.contrib import admin
from address.models import Address

# Register your models here.

class AddressAdmin(admin.ModelAdmin):
    #화면에 출력할 필드 목록을 튜플로 지정
    list_display = ('name', 'tel', 'email', 'address')
                    # 관리자 페이지에 표시할 항목
admin.site.register(Address, AddressAdmin)
                #   모델클래스   관리자클래스