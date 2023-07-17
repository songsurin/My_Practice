from django.shortcuts import render
from urllib import parse
from datetime import datetime

def set_cookie(request):
    name = parse.quote('김철수') # url 인코딩(특수+한글 변환)
    response = render(request, 'ch03/set_cookie.html',
                      {'name': parse.unquote(name)})
    response.set_cookie('id', 'kim') # 쿠키 추가: 변수, 값
    response.set_cookie('pwd', '1234')
    response.set_cookie('name', name)
    return response

def del_cookie(request):
    response = render(request, 'ch03/del_cookie.html')
    response.delete_cookie('id')
    response.delete_cookie('pwd')
    response.delete_cookie('name')
    return response

def change_cookie(request):
    name = 'Kim Chul'
    response = render(request, 'ch03/change_cookie.html')
    response.set_cookie('id', 'kim')
    response.set_cookie('pwd', '2222')
    response.set_cookie('name', name)
    return response

def counter(request):
    try:
        last_visit = request.COOKIES['last_visit']
        visits = request.COOKIES['visits']
        t1 = datetime.strptime(str(datetime.now()), '%Y-%m-%d %H:%M:%S.%f')
        t2 = datetime.strptime(last_visit, '%Y-%m-%d %H:%M:%S.%f')

        int_visit = int(visits) + 1
        strVisits = str(int_visit)
        strLastVisit = str(datetime.now())

        # 시간제한
        # if (t1 - t2).seconds > 1:
        #     int_visit = int(visits) + 1
        #     strVisits = str(int_visit)
        #     strLastVisit = str(datetime.now())
        # else:
        #     strVisits = visits
        #     strLastVisit = last_visit
    except:
        strVisits = '1'
        strLastVisit = str(datetime.now())

    result = []
    for i in range(0, len(strVisits)):
        result.append(f'{strVisits[i]}.gif')
    response = render(request, 'ch03/counter.html', {"result": result})
    response.set_cookie('visits', strVisits)
    response.set_cookie('last_visit', strLastVisit)
    return response