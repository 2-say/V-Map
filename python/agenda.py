import openai
import sys

openai.api_key = " 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" # 발급받은 API 키를 입력합니다.

def extract_agenda(text):
    model_engine = "text-davinci-002" # 사용할 GPT-3 모델 엔진의 이름을 입력합니다.
    prompt = f"다음 텍스트에서 회의 안건을 추출해주세요:\n{text}"
    completions = openai.Completion.create(
        engine=model_engine,
        prompt=prompt,
        max_tokens=1024,
        n=1,
        stop=None,
        temperature=0.5,
    )
    message = completions.choices[0].text.strip()
    return message

def main(argv):
    # file_path = "data2.txt"
    file_path = argv[1]
    result = extract_agenda(file_path)
    print(result)

if __name__ == "__main__":
    main(sys.argv)
