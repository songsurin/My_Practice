from django.shortcuts import render
def error404(request, exception):
    return render(request, "error/404.html", status=404)

def error500(request, *args, **argv):
    return render(request, "error/500.html", status=500)