from flask import Flask,render_template,request
from keras.models import load_model
import numpy as np
import joblib

app = Flask(__name__)
@app.route('/',methods=['GET'])

def main():
    return render_template('rides/input.html')

@app.route('/result',methods=['POST'])

def result():
    model = load_model('c:/data/rides/rides_keras.model')
    model.load_weights('c:/data/rides/rides.weight')
    scaler = joblib.load('c:/data/rides/scaler.sav')
    week = request.form['week']
    if week=="1":
        weekend='주말'
    else:
        weekend='평일'

    child = int(request.form['child']) #폼데이터는 str
    distance = int(request.form['distance'])
    rides = int(request.form['rides'])
    games = int(request.form['games'])
    wait = int(request.form['wait'])
    clean = int(request.form['clean'])
    test_set = np.array([week, child, distance, rides, games, wait, clean]).reshape(1,7)
    test_set_scaled=scaler.transform(test_set)
    rate= model.predict(test_set_scaled)

    if rate>=0.5:
        result='만족'
    else:
        result='불만족'

    return render_template('rides/result.html', rate='{:.2f}%'.format(rate[0][0]*100),
                           result=result, weekend=weekend, child=child,
                           distance=distance, rides=rides, games=games,
                           wait=wait, clean=clean)

if __name__ == '__main__':
    #웹브라우저에서 실행할 때 http://localhost로 하면 느림
    #http://127.0.0.1로 할 것
    app.run(port=8080, threaded=False)