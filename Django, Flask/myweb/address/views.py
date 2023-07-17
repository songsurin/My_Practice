from django.shortcuts import redirect, render
#                     다른 기능으로 전환, 템플릿 생성
from address.models import Address

# Create your views here.

def home(request):
    items = Address.objects.order_by("name")
    #       테이블의 모든 레코드 가져와서 name순 오름차순 정렬
    return render(request, 'address/list.html', {'items': items,
                                                 'address_count': len(items)})
#              화면생성작업       출력 페이지         전달할 데이터
def write(request):
    return render(request, "address/write.html")

def insert(request):
    addr = Address(name=request.POST['name'],
                   tel=request.POST['tel'], email=request.POST['email'],
                   address=request.POST['address'])
    addr.save()
    return redirect("/address")

def detail(request):
    id = request.GET['idx']
    addr = Address.objects.get(idx=id)
    #       테이블.   전체.   조건
    # select * from address_address where idx=id 와 같음
    return render(request, 'address/detail.html', {'addr': addr})

def update(request):
    d = request.POST['idx']
    addr = Address(idx=id, name=request.POST['name'],
                   tel=request.POST['tel'], email=request.POST['email'],
                   address=request.POST['address'])
    addr.save() # insert into address_address values(~)와 같음
    return redirect("/address") # 쓰기 완효 후 목록으로 이동

def delete(request):
    id = request.POST['idx']
    Address.objects.get(idx=id).delete()
    return redirect("/address")