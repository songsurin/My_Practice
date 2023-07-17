from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.contrib.auth import login as dlogin, logout as dlogout
from mymember.models import Member
import hashlib

def home(request):
    if 'userid' not in request.session.keys():
        return render(request, 'mymember/login.html')
    else:
        return render(request, 'mymember/main.html')

def login(request):
    if request.method == 'POST': #post 방식 접속
        userid = request.POST['userid']
        passwd = request.POST['passwd']
        passwd = hashlib.sha256(passwd.encode()).hexdigest()
        row = Member.objects.filter(userid=userid, passwd=passwd)[0]
        if row is not None: #레코드가 있으면 세션 변수 생성, 저장
            request.session['userid'] = userid
            request.session['name'] = row.name
            return render(request, 'mymember/main.html')
        else:
            return render(request, 'mymember/login.html', {'msg': '아이디 또는 비밀번호가 일치하지 않습니다.'})
    else: #get 방식 접속
        return render(request, 'mymember/login.html')

def join(request):
    if request.method == 'POST':
        userid = request.POST['userid']
        passwd = request.POST['passwd']
        passwd = hashlib.sha256(passwd.encode()).hexdigest() #pw암호화
        name = request.POST['name']
        address = request.POST['address']
        tel = request.POST['tel']
        Member(userid=userid, passwd=passwd, name=name,
        address=address, tel=tel).save()
        request.session['userid'] = userid
        request.session['name'] = name
        return render(request, 'mymember/main.html')
    else:
        return render(request, 'mymember/join.html')

def logout(request):
    request.session.clear()
    return redirect('/mymember')