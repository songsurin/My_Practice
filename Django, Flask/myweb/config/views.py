from django.shortcuts import render

def home(request):
    #installed_app에 작성한 첫번째 앱인 address의 index.html 페이지로 출력됨
    return render(request, 'index.html')
              # 전달할 데이터  화면 템플릿