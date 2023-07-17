from django.contrib import admin
from memo.models import Memo
class MemoAdmin(admin.ModelAdmin):
    #관리자 화면에서 관리할 필드 목록 정의
    list_display = ("writer","memo")

admin.site.register(Memo, MemoAdmin)

# Register your models here.
