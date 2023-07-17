from django.shortcuts import HttpResponse, render
from shop.models import Product
from shop import ProductSerializer as ps
import simplejson
import os.path

from django.views.decorators.csrf import csrf_exempt
UPLOAD_DIR = os.path.dirname(__file__) + '/static/images/'

def list(request):
    try:
        product_name = request.GET["product_name"]
    except:
        product_name = ""
    items =Product.objects.filter(product_name__contains=product_name).order_by("-product_name")
    serializer = ps.ProductSerializer(items, many=True)
    return HttpResponse(simplejson.dumps(serializer.data))

@csrf_exempt
def insert(request):
    if "img" in request.FILES:
        file = request.FILES["img"]
        file_name = file._name
        fp = open("%s%s" % (UPLOAD_DIR, file_name), "wb")
        for chunk in file.chunks():
            fp.write(chunk)
        fp.close()
    else:
        file_name = "-"
    row = Product(product_name=request.POST["product_name"],description=request.POST["description"],price=request.POST["price"],filename=file_name)
    row.save()

def detail(request, product_code):
    row = Product.objects.get(product_code=product_code)
    serializer = ps.ProductSerializer(row)
    return HttpResponse(simplejson.dumps(serializer.data))

@csrf_exempt
def update(request):
    product_code = request.POST['product_code']
    row_src = Product.objects.get(product_code=product_code)
    filename = row_src.filename
    if "img" in request.FILES:
        file = request.FILES["img"]
        filename = file._name
        fp = open("%s%s" % (UPLOAD_DIR, filename), "wb")
        for chunk in file.chunks():
            fp.write(chunk)
        fp.close()
    row_new = Product(product_code=product_code,product_name=request.POST["product_name"],description=request.POST["description"],price=request.POST["price"],filename=filename)
    row_new.save()

@csrf_exempt
def delete(request):
    Product.objects.get(product_code=request.GET["product_code"]).delete()

def home(request):
    return render(request, 'index.html')