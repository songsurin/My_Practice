from django.shortcuts import render, redirect
from mytest.models import Salary

def age(request):
    try:
        name = request.POST['name']
        year = request.POST['year']
    except:
        return render(request, 'ch02/age.html')

    age = 2023 - int(year) + 1
    return render(request, 'ch02/age_result.html',
                  {'name': name, 'year': year, 'age': age})

def mysum(request):
    try:
        num = int(request.POST['num'])
    except:
        return render(request, 'ch02/mysum.html')

    result = sum(range(1, num + 1))
    result_e = 0  # 짝수합계
    result_o = 0  # 홀수합계
    for i in range(1, num+1):
        if i % 2 == 0:
            result_e += i
        else:
            result_o += i
    return render(request, 'ch02/mysum_result.html',
                  {'num': num, 'result': result,
                   'result_e': result_e, 'result_o': result_o})


def salary(request):
    try:
        name = request.POST['name']
        sal = int(request.POST['sal'])
        bonus = int(request.POST['bonus'])
    except:
        return render(request, 'ch02/salary.html')

    total = sal * 12 + bonus
    tax = total * 5 / 100
    money = total - tax

    salary = Salary(name=name, sal=sal, bonus=bonus, total=total, tax=tax, money=money)
    salary.save()

    return render(request, 'ch02/salary_result.html',
                  {'name': name, 'sal': sal, 'bonus': bonus,
                   'total': total, 'tax': tax, 'money': money})

def salary_list(request):
   items=Salary.objects.order_by('name')
   return render(request, 'ch02/salary_list.html', {'items':items})


def salary_detail(request):
   item=Salary.objects.get(id=request.GET['id'])
   return render(request, 'ch02/salary_detail.html', {'item':item})

def salary_update(request):
    id = request.POST['id']
    sal = int(request.POST['sal'])
    bonus = int(request.POST['bonus'])
    total = sal * 12 + bonus
    tax = total * 5 / 100
    money = total - tax

    item = Salary(id=id, name=request.POST['name'], sal=sal, bonus=bonus,
                  total=total, tax=tax, money=money)
    item.save()
    return redirect("/salary_list")


def salary_delete(request):
    Salary.objects.get(id=request.POST['id']).delete()
    return redirect('/salary_list')

def radio(request):
    try:
        name = request.POST['name']
        gender = request.POST['gender']
    except:
        return render(request, 'ch02/radio.html')

    if gender == 'male':
        gender = '남성'
    elif gender == 'female':
        gender = '여성'

    return render(request, 'ch02/radio_result.html',
                  {'name': name, 'gender': gender})

def checkbox(request):
    fruits = request.POST.getlist('fruits')
    if len(fruits) == 0:
        return render(request, 'ch02/checkbox.html')

    return render(request, 'ch02/checkbox_result.html',
                  {'fruits': fruits})
                   # 변수명

def button(request):
    try:
        price = request.POST['price']
        amount = request.POST['amount']
    except:
        return render(request, 'ch02/button.html')

    money = int(price) * int(amount)
    return render(request, 'ch02/button_result.html',
                  {'price': price, 'amount': amount, 'money': money})

def textarea(request):
    try:
        opinion = request.POST['opinion']
    except:
        return render(request, 'ch02/textarea.html')

    opinion = opinion.replace('<', '&lt;') # 왼쪽 화살 괄호
    opinion = opinion.replace('>', '&gt;') # 오른쪽 화살 괄호
    opinion = opinion.replace('\n', '<br>') # 엔터 치면 br태그로 바꿔줌
    opinion = opinion.replace(' ', '&nbsp;&nbsp;') #스페이스
    return render(request, 'ch02/textarea_result.html',
                  {'opinion': opinion})


def select(request):
    if request.method == 'GET':
        return render(request, 'ch02/select.html')
    elif request.method == 'POST':
        #car = request.POST['car'] #값 1개일 때
        car = request.POST.getlist('car') #값 여러개일 때
        return render(request, 'ch02/select_result.html', {'car': car})

def select2(request):
    try:
        name = request.POST['name']
        color = request.POST['color']
    except:
        return render(request, 'ch02/select2.html')

    if color == 'blue':
        color = '파랑'
    elif color == 'green':
        color = '초록'
    elif color == 'red':
        color = '빨강'
    return render(request, 'ch02/select2_result.html',
                  {'name': name, 'color': color})

def point(request):
    try:
        name = request.POST['name']
        kor = request.POST['kor']
        eng = request.POST['eng']
        mat = request.POST['mat']
    except:
        return render(request, 'ch02/point.html')

    total = float(kor) + float(eng) + float(mat)
    average = f'{total / 3:.2f}'
    return render(request, 'ch02/point_result.html',
                  {'name': name, 'kor': kor, 'eng': eng,
                   'mat': mat, 'total': total, 'average': average})

def gugu(request):
    return render(request, 'ch02/gugu.html')

def gugu_result(request):
    dan = int(request.POST['dan'])
    result = ''
    for i in range(1, 10):
        result += f'{dan} x {i} = {dan * i}<br>'
    return render(request, 'ch02/gugu_result.html', {'result': result})