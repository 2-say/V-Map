from krwordrank.word import KRWordRank
from krwordrank.sentence import keysentence
from krwordrank.sentence import make_vocab_score
from krwordrank.sentence import MaxScoreTokenizer
from krwordrank.hangle import normalize
import sys


def get_texts_scores(a):
    with open(a, encoding='utf-8') as f:
        docs = [doc.lower().replace('\n', '') for doc in f]
        if not docs:
            return []
        return docs

def main(argv):
    
    filename = argv[1]
    #filename = '../data/test.txt'

    texts = get_texts_scores(filename)

    wordrank_extractor = KRWordRank(
        min_count = 1, # 단어의 최소 출현 빈도수 (그래프 생성 시)
        max_length = 5, # 단어의 최대 길이
        verbose = False
        )

    beta = 0.85  # PageRank의 decaying factor beta
    max_iter = 10
    keywords, rank, graph = wordrank_extractor.extract(texts, beta, max_iter, num_keywords=10)

    print(keywords)

    stopwords = {'어', '네 ', '이제', '그런', '예', '또', '그',
                 '지금', '이렇게', '이제', '이런'}

    vocab_score = make_vocab_score(keywords, stopwords, scaling=lambda x:1)
    tokenizer = MaxScoreTokenizer(vocab_score)

    print(vocab_score)

    penalty = lambda x: 0 if 10 <= len(x) <= 50 else 1

    sents = keysentence(
        vocab_score, texts, tokenizer.tokenize,
        penalty=penalty,
        diversity=0.5,
        topk=5
    )
    


    # for local
    # with open('D:/users/GitHub/V-Map/data/result.txt', 'w', encoding='utf-8') as f:
    #     for sent in sents:
    #         f.write("%s\n" % sent)

    # for server
    with open('home/VMap/data/result.txt', 'w', encoding='utf-8') as f:
        for sent in sents:
            f.write("%s\n" % sent)

    for sent in sents:
        print(sent)



if __name__ == "__main__":
    main(sys.argv)