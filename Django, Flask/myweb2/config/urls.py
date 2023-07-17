from django.contrib import admin
from django.urls import path
from mytest.views import ch01, ch02, ch03, ch04

handler404 = "mytest.views.error.error404"
handler500 = "mytest.views.error.error500"

urlpatterns = [
    path("admin/", admin.site.urls),
    path('', ch01.home),
    path('hello/', ch01.hello),
    path('now/', ch01.now),
    path('array/', ch01.array),
    path('age/', ch02.age),
    path('mysum/', ch02.mysum),
    path('salary/', ch02.salary),
    path('salary_list/', ch02.salary_list),
    path('salary_detail/', ch02.salary_detail),
    path('salary_update/', ch02.salary_update),
    path('salary_delete/', ch02.salary_delete),
    path('radio/', ch02.radio),
    path('checkbox/', ch02.checkbox),
    path('button/', ch02.button),
    path('textarea/', ch02.textarea),
    path('select/', ch02.select),
    path('point/', ch02.point),
    path('gugu/', ch02.gugu),
    path('gugu_result/', ch02.gugu_result),
    path('select2/', ch02.select2),
    path('set_cookie/', ch03.set_cookie),
    path('del_cookie/', ch03.del_cookie),
    path('change_cookie/', ch03.change_cookie),
    path('counter/', ch03.counter),
    path('session_main/', ch04.session_main),
    path('set_session/', ch04.set_session),
    path('clear_session/', ch04.clear_session),
    path('change_session/', ch04.change_session),
    path('session_counter/', ch04.session_counter),
]
