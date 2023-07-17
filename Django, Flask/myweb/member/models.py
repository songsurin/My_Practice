from django import forms
from django.contrib.auth.models import User

class UserForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ["username", "email", "password"]

# 로그인폼(아이디와 비밀번호만 입력받음)
class LoginForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ["username", "password"]