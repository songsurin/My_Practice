from django.urls import path
from book import views
urlpatterns = [
    path('', views.list),
    #    url    function
    path('write', views.write),
    path('insert', views.insert),
    path('edit', views.edit),
    path('update', views.update),
    path('delete', views.delete),
]