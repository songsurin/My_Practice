from flask import Flask,render_template,request
from keras.models import load_model
import numpy as np
app = Flask(__name__)
@app.route('/',methods=['GET'])
def main():
    return render_template('iris/input.html')
@app.route('/iris_result',methods=['POST'])
def iris_result():
    flowers = ['setosa', 'versicolor', 'virginica']
    #기계학습 모형이 저장된 디렉토리
    model = load_model('c:/data/iris')
    a = float(request.form['a'])
    b = float(request.form['b'])
    c = float(request.form['c'])
    d = float(request.form['d'])
    test_set = [[a, b, c, d]]
    pred=model.predict(test_set)
    n=np.argmax(pred,axis=1)
    result=flowers[n[0]]
    return render_template('iris/iris_result.html', result=result,a=a,b=b,c=c,d=d)
if __name__ == '__main__':
    #웹브라우저에서 실행할 때 http://localhost:8000 으로 하면 속도가 매우 느려지므로 http://127.0.0.1:8000으로 실행
    app.run(port=8000, threaded=False)