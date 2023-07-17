from flask import Flask, render_template, request
from PIL import Image
import numpy as np
from keras.models import load_model
import tensorflow as tf

app = Flask(__name__)
@app.route('/')
def main():
    return render_template('xray/input.html')

@app.route('/uploader', methods=['POST'])
def upload_image():
    gender = request.form['gender']
    if gender == 'M':
        model = load_model('d:/data/model/xray_m_best.h5')
    elif gender == 'F':
        model = load_model('d:/data/model/xray_f_best.h5')

    img = Image.open(request.files['file'].stream)
    img = img.resize((80, 100))
    arr = np.array(img) / 255
    arr = arr.reshape(1, 80, 100, 3)

    with tf.device('/CPU:0'):
        pred = model.predict(arr)
    return '연령:' + str(pred[0][0])

if __name__ == '__main__':
    app.run(port=8000, threaded=False)