from flask import Flask,render_template,request
import joblib

app = Flask(__name__)
@app.route('/',methods=['GET'])
def main():
    return render_template('heart/input.html')

@app.route('/result',methods=['POST'])
def result():
    print(1111)
    model = joblib.load('C:/Users/tjoeun/Desktop/health_data/heart_model.h5')
    scaler = joblib.load('C:/Users/tjoeun/Desktop/health_data/heart.sav')
    print(222)
    age = float(request.form['age'])
    trtbps = float(request.form['trtbps'])
    thalach = float(request.form['thalach'])
    oldspeak = float(request.form['oldspeak'])
    sex = request.form['sex']
    print(333)
    if sex == "f":
        female = 1
        male = 0
    else:
        female = 0
        male = 1
    cp = request.form['cp']
    if cp == "n":
        cp_n = 1
        cp_y = 0
    else:
        cp_n = 0
        cp_y = 1
    fbs = float(request.form['fbs'])
    if fbs <= 120:
        fbs_n = 1
        fbs_y = 0
    else:
        fbs_n = 0
        fbs_y = 1
    ecg = request.form['ecg']
    if ecg == "n":
        ecg_n = 1
        ecg_y = 0
    else:
        ecg_n = 0
        ecg_y = 1
    exang = request.form['exang']
    if exang == "n":
        exang_n = 1
        exang_y = 0
    else:
        exang_n = 0
        exang_y = 1
    sl = request.form['sl']
    if sl == "n":
        sl_n = 1
        sl_y = 0
    else:
        sl_n = 0
        sl_y = 1
    ca = request.form['ca']
    if ca == "n":
        ca_n = 1
        ca_y = 0
    else:
        ca_n = 0
        ca_y = 1
    test_set = [[age, trtbps, thalach, oldspeak,
                 female, male, cp_n, cp_y, fbs_n, fbs_y,
                 ecg_n, ecg_y, exang_n, exang_y, sl_n, sl_y,
                 ca_n, ca_y]]
    test_set = scaler.transform(test_set)
    pred = round(model.predict_proba(test_set)[0][1]*100,2)

    if pred >= 50:
        result = '심장마비 가능성 많음'
    else:
        result = '심장마비 가능성 적음'

    #pred=pred[0]*100

    return render_template('heart/result.html',
                           result=result,age=age, trtbps=trtbps,
                           thalach=thalach, oldspeak=oldspeak,
                           sex=sex, cp=cp, fbs=fbs, ecg=ecg, exang=exang,
                           sl=sl, ca=ca, pred=pred)
if __name__ == '__main__':
    #웹브라우저에서 실행할 때 http://localhost:8000 으로 하면 속도가 매우 느려지므로 http://127.0.0.1:8000으로 실행
    app.run(port=8000, threaded=False)