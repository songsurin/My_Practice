import time
from django.db import transaction
from django.shortcuts import render
from transaction.models import Emp

def home(request):
    return render(request, 'transaction/index.html')
@transaction.atomic() #아래 코드가 한번에 모두 수행되어야 함
def insert(request):
    start = time.time()
    Emp.objects.all().delete()
    for i in range(1, 1001):
        emp = Emp(empno=i, ename='name' + str(i), deptno=i)
        emp.save()
    end = time.time()
    runtime = end - start #작업시간
    cnt = Emp.objects.count() #select count(*) from 테이블
    return render(request, 'transaction/index.html',
                  {'cnt': cnt, 'runtime': f'{runtime:.2f}초'})
def list(request):
    empList = Emp.objects.all()
    return render(request, 'transaction/list.html',
                  {'empList': empList, 'empCount': len(empList)})
