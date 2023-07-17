from django.shortcuts import render
from urllib import parse
from datetime import datetime

def session_main(request):
    return render(request, 'ch04/main.html')

def set_session(request):
    request.session['id'] = 'kim'
    request.session['pwd'] = '1234'
    request.session['name'] = '김철수'
    return render(request, 'ch04/main.html')

def clear_session(request):
    # 세션 개별 삭제 방법
    # del request.session['pwd']
    # del request.session['name']
    request.session.clear() #세션 전체 초기화
    return render(request, 'ch04/clear_session.html')

def change_session(request):
    request.session['id'] = 'kim'
    request.session['pwd'] = '2222'
    request.session['name'] = 'Kim Chul'
    return render(request, 'ch04/change_session.html')

def session_counter(request):
    try:
        last_visit = request.session['last_visit']
        visits = request.session['visits']
        t1 = datetime.strptime(str(datetime.now()), '%Y-%m-%d %H:%M:%S.%f')
        t2 = datetime.strptime(last_visit, '%Y-%m-%d %H:%M:%S.%f')
        int_visit = int(visits) + 1
        if (t1 - t2).seconds > 3:
            request.session['visits'] = int_visit
            request.session['last_visit'] =str(datetime.now())
    except:
        visits = 1
        request.session['visits'] = 1
        request.session['last_visit'] = str(datetime.now())
    strVisits = str(visits)
    result = []
    for i in range(0, len(strVisits)):
        result.append(f'{strVisits[i]}.gif')
    return render(request, 'ch04/session_counter.html', {"result": result})