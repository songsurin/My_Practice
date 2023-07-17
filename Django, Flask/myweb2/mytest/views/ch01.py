from django.shortcuts import render
import datetime

def home(request):
    msg = 'welcome'
    return render(request, 'index.html', {'msg': msg})

def hello(request):
    msg = 'hello django'
    return render(request, 'ch01/hello.html', {'msg': msg})

def now(request):
    date = datetime.datetime.now()
    today = f'{date.year}-{str(date.month).zfill(2)}-{str(date.day).zfill(2)} ' \
            f'{str(date.hour).zfill(2)}:{str(date.minute).zfill(2)}:{str(date.second).zfill(2)}'
    return render(request, "ch01/now.html", {"today": today})
#zfill 자리수 맞추어 0으로 채우기

def array(request):
    items = ["apple", "peach", "grapes", "orange"]
    return render(request, "ch01/array.html", {"items": items})