from django.contrib import admin
from django.urls import path, include
#                       함수,  외부패키지 url 참조
from config import views
from django.conf import settings
from django.urls import re_path

urlpatterns = [
    # 관리자용 사이트
    path("admin/", admin.site.urls),
    path('', views.home),
    path('address/', include('address.urls')),
    path('memo/', include('memo.urls')),
    path('book/', include('book.urls')),
    path('transaction/', include('transaction.urls')),
    path('procedure/', include('procedure.urls')),
    path('mymember/', include('mymember.urls')),
    path('ajax/', include('ajax.urls')),
    path('survey/', include('survey.urls')),
    path('guestbook/', include('guestbook.urls')),
    path('member/', include('member.urls')),
    path('shop/', include('shop.urls')),
]

if settings.DEBUG:
    import debug_toolbar
    urlpatterns += [
        re_path(r'^__debug__/', include(debug_toolbar.urls)),
]
