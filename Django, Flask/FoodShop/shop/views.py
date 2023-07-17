from django.shortcuts import render, redirect
from shop.models import Member,Chat
import hashlib
import json

def home(request):
    if 'userid' not in request.session.keys():
        return render(request, 'shop/login.html')
    else:
        return render(request, 'shop/main.html')

def login(request):
    if request.method == 'POST':
        userid = request.POST['userid']
        passwd = request.POST['passwd']
        passwd = hashlib.sha256(passwd.encode()).hexdigest()
        row = Member.objects.filter(userid=userid,passwd=passwd)[0]
        if row is not None:
            request.session['userid'] = userid
            request.session['name'] = row.name
            return render(request, 'shop/main.html')
        else:
            return render(request, 'shop/login.html',{'msg': '아이디 또는 비밀번호가 일치하지 않습니다.'})
    else:
        return render(request, 'shop/login.html')

def join(request):
    if request.method == 'POST':
        userid = request.POST['userid']
        passwd = request.POST['passwd']
        passwd = hashlib.sha256(passwd.encode()).hexdigest()
        name = request.POST['name']
        address = request.POST['address']
        tel = request.POST['tel']
        Member(userid=userid, passwd=passwd, name=name,
        address=address, tel=tel).save()
        request.session['userid'] = userid
        request.session['name'] = name
        return render(request, 'shop/main.html')
    else:
        return render(request, 'shop/join.html')

def logout(request):
    request.session.clear()
    return redirect('/')

#from flask import Flask, request, jsonify
import socket
import json
def get_answer(query):
    # 챗봇 엔진 서버 연결
    mySocket = socket.socket()
    mySocket.connect(("127.0.0.1", 5050))
     # 챗봇 엔진 질의 요청
    json_data = {
        'Query': query,
    }
    message = json.dumps(json_data)
    mySocket.send(message.encode())
    # 챗봇 엔진 답변 출력
    data = mySocket.recv(2048).decode()
    ret_data = json.loads(data)
    # 챗봇 엔진 서버 연결 소켓 닫기
    mySocket.close()
    return ret_data

def order(request):
    return render(request, 'shop/order.html')

from shop.mychatbot import getMessage
from django.http import JsonResponse
def query(request):
    print('111')
    question = request.GET["question"]
    print('222')
    #print(question)
    # message = json.dumps(json_data)
    # mySocket.send(message.encode())
    #
    # # 챗봇 엔진 답변 출력
    # data = mySocket.recv(2048).decode()
    # ret_data = json.loads(data)
    msg = getMessage(question)
    query=msg['Query']
    answer=msg['Answer']
    intent=msg['Intent']
    #레코드에 저장
    Chat(userid=request.session['userid'], query=query,intent=intent).save()
    Chat(userid=request.session['userid'], answer=answer,intent=intent).save()
    print('저장되었습니다.')
    items=Chat.objects.filter(userid=request.session['userid']).order_by('-idx')
    return render(request, 'shop/result.html',{'items':items})

def delete_chat(request):
    Chat.objects.filter(userid=request.session['userid']).delete()
    return redirect('/order')