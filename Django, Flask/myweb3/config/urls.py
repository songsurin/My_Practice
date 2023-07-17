from django.contrib import admin
from django.urls import path
from board import views

urlpatterns = [
    #관리자용 사이트
    path('admin', admin.site.urls),
    #게시판 관련 url
    path('', views.list),
    path('write', views.write),
    path('insert', views.insert),
    path('detail', views.detail),
    path('update', views.update),
    path('delete', views.delete),
    path("download", views.download),
    path("reply_insert", views.reply_insert)
]
