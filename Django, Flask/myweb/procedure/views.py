from django.shortcuts import render, redirect
from procedure.models import Emp
import cx_Oracle

def home(request):
    return render(request, 'procedure/index.html')

def list_emp(request):
    empList = Emp.objects.order_by('ename')
    return render(request, 'procedure/list_emp.html',
                  {'empList': empList, 'empCount': len(empList)})

def update_emp(request):
    emp = Emp.objects.get(empno=request.GET['empno'])
    sal = int(request.GET['sal']) * 1.1
    emp_new = Emp(empno=emp.empno, ename=emp.ename,
                  job=emp.job, hiredate=emp.hiredate,
                  sal=sal)
    emp_new.save()
    return redirect('/procedure/list_emp')

def update_emp_p(request):
    try:
        with cx_Oracle.connect("python/1234@localhost:1521/xe") as conn:
            with conn.cursor() as cursor:
                empno = request.GET['empno']
                cursor.callproc('mysal_p', [empno])
                conn.commit()
    except Exception as e:
        print(e)
    return redirect('/procedure/list_emp')

def write_emp(request):
    return render(request, 'procedure/write_emp.html')

def insert_emp(request):
    emp=Emp(empno=request.POST['empno'],
            ename=request.POST['ename'],
            job=request.POST['job'],
            hiredate=request.POST['hiredate'],
            sal=request.POST['sal'])
    emp.save()
    return redirect('/procedure/list_emp')

def list_memo_p(request):
    try:
        with cx_Oracle.connect("python/1234@localhost:1521/xe") as conn:
            with conn.cursor() as cursor:
                ref_cursor = conn.cursor()
                cursor.callproc('memo_list_p', [ref_cursor])
                rows = ref_cursor.fetchall()
    except Exception as e:
        print(e)
    return render(request, 'procedure/list_memo_p.html',
                  {'memoList': rows, 'cnt': len(rows)})

def insert_memo_p(request):
    try:
        with cx_Oracle.connect("python/1234@localhost:1521/xe") as conn:
            with conn.cursor() as cursor:
                writer = request.POST['writer']
                memo = request.POST['memo']
                cursor.callproc('memo_insert_p', [writer, memo])
            conn.commit()
    except Exception as e:
        print(e)
    return redirect('/procedure/list_memo_p')

def view_memo_p(request):
    try:
        with cx_Oracle.connect("python/1234@localhost:1521/xe") as conn:
            with conn.cursor() as cursor:
                idx = request.GET['idx']
                ref_cursor = conn.cursor()
                cursor.callproc('memo_view_p', [idx, ref_cursor])
                                                # 레코드셋 참조(커서)
                row = ref_cursor.fetchone()
    except Exception as e:
        print(e)
    return render(request, 'procedure/view_memo_p.html',
                  {'memo': row})

def delete_memo_p(request):
    try:
        with cx_Oracle.connect("python/1234@localhost:1521/xe") as conn:
            with conn.cursor() as cursor:
                idx = request.GET['idx']
                cursor.callproc('memo_delete_p', [idx])
                conn.commit()
    except Exception as e:
        print(e)
    return redirect('/procedure/list_memo_p')

def update_memo_p(request):
    try:
        with cx_Oracle.connect("python/1234@localhost:1521/xe") as conn:
            with conn.cursor() as cursor:
                idx = request.POST['idx']
                writer = request.POST['writer']
                memo = request.POST['memo']
                cursor.callproc('memo_update_p', [idx, writer, memo])
                #프로시저 호출    프로시저 이름         호출 변수
                conn.commit()
    except Exception as e:
        print(e)
    return redirect('/procedure/list_memo_p')

