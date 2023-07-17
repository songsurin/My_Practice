# *변수
#여러개의 매개변수를 하나의 튜플로 저장함
def test(*a):
    print(a)

test('hello')
test('hello','good')
test('hello','good','morning')

# **변수
# 여러개의 key와 value들을 하나의 딕셔너리로 저장함
def test(**a):
    print(a)

test(name='김철수')
test(name='김철수',age=20)
test(name='김철수',age=20,height=180)

from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.contrib.auth import login as dlogin, logout as dlogout
from member.models import UserForm, LoginForm

# 시작 페이지
def home(request):
    if not request.user.is_authenticated: # 로그인하지 않은 상태
        data = {"username": request.user, "is_authenticated": request.user.is_authenticated}
    else: # 로그인 한 상태
        data = {"last_login": request.user.last_login,
                "username": request.user.username,
                "password": request.user.password,
                "is_authenticated": request.user.is_authenticated}
    return render(request, "member/index.html", {"data": data})

# 회원가입 처리
def join(request):
    if request.method == "POST":
        form = UserForm(request.POST)
        # 입력값에 문제가 없으면(모든 유효성 검증 규칙을 통과할 때)
        if form.is_valid():
            # form.cleaned_data(검증에 성공한 값들을 딕셔너리 타입으로 저장하고 있는 데이터)
            # ** keyword argument, 키워드 인자
            # 새로운 사용자가 생성됨
            new_user = User.objects.create_user(**form.cleaned_data)
            # 로그인 처리
            dlogin(request, new_user)
            # 시작 페이지로 이동
            return redirect("/member")
        else:
            return render(request, "member/index.html",
                          {"msg": "회원가입 실패... 다시 시도해 보세요."})
    else:
        # post 방식이 아닌 경우 회원가입페이지로 이동
        form = UserForm()
        return render(request, "member/join.html", {"form": form})

def login_check(request):
    if request.method == "POST":
        name = request.POST["username"]
        pwd = request.POST["password"]
        # 인증
        user = authenticate(username=name, password=pwd)
        if user is not None: # 로그인 성공
            dlogin(request, user)
            #session에 저장
            request.session["userid"] = name
            return redirect("/member")
        else: # 로그인 실패
            return render(request, "member/index.html", {"msg": "로그인 실패... 다시 시도해 보세요."})
    else: # get 방식인 경우 - 로그인 페이지로 이동
        form = LoginForm()
        return render(request, "member/login.html", {"form": form})

def logout(request):
    # 로그아웃 처리
    dlogout(request)
    return redirect("/member")