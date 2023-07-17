import pickle
from chatbot.Preprocess1 import Preprocess1

# 단어 사전 불러오기
f = open("C:/python/FoodShop/chatbot/data/chatbot_dict.bin", "rb")
word_index = pickle.load(f)
f.close()
sent = "오늘 오후 10시에 짜장면 주문해요"

# 전처리 객체 생성
p = Preprocess1(userdic='C:/python/FoodShop/chatbot/data/user_dic.tsv')

# 형태소분석기 실행
pos = p.pos(sent)

# 품사 태그 없이 키워드 출력
keywords = p.get_keywords(pos, without_tag=True)
for word in keywords:
    try:
        print(word, word_index[word])
    except KeyError:
        # 해당 단어가 사전에 없는 경우, OOV 처리
        print(word, word_index['OOV'])