from flask import Flask, render_template, request
from PIL import Image
import numpy as np
from keras.models import load_model

app = Flask(__name__)

@app.route('/')
def main():
    return render_template('cifar/index.html')

@app.route('/uploader', methods = ['POST'])
def upload_image():
    model = load_model('c:/data/cifar/cifar.h5')
    img = Image.open(request.files['file'].stream)
    print(type(img))
    #업로드한 파일 사이즈가 원본 이미지 size와 같도록 처리
    img = img.resize((32,32))
    #넘파이 배열로 변환
    arr = np.array(img) / 255
    print(arr.shape)
    #keras 모형에서 읽을 수 있도록 32x32에서 1x32x32x3으로 차원 변경
    # 이미지개수x가로사이즈x세로사이즈x흑백(1)/컬러(3)
    arr = arr.reshape(1,32,32,3)

    import tensorflow as tf
    with tf.device('/CPU:0'):
        pred = model.predict(arr)
        pred = np.argmax(pred,axis=1)
        a=int(pred[0])
    names=['비행기','자동차','새','고양이','사슴','개','개구리','말','배','트럭']
    return '이미지 분류 결과: '+names[a]

if __name__ == '__main__':
    app.run(port=8000, threaded=False)