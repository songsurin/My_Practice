from chatbot.Preprocess2 import Preprocess2
from chatbot.NerModel import NerModel

p = Preprocess2(word2index_dic='C:/python/FoodShop/chatbot/data/chatbot_dict.bin',
               userdic='C:/python/FoodShop/chatbot/data/user_dic.tsv')
ner = NerModel(model_name='C:/python/FoodShop/chatbot/model/ner_model.h5', proprocess=p)
query = '오늘 오후 13시 2분에 탕수육 주문 하고 싶어요'
predicts = ner.predict(query)
tags = ner.predict_tags(query)
print(predicts)
print(tags)