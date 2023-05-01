import openai
import sys

openai.api_key = " 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"

def summarize_meeting_notes(file_path):
    with open(file_path, "r") as f:
        text = f.read()
        model_engine = "text-davinci-002"
        prompt = (f"주어진 회의록을 요약해주세요.\n"
                  f"---\n"
                  f"{text}\n"
                  f"---\n"
                  f"요약:\n")

        response = openai.Completion.create(
            engine=model_engine,
            prompt=prompt,
            max_tokens=1024,
            n=1,
            stop=None,
            temperature=0.7,
        )

        summary = response.choices[0].text.strip()

    return summary

def main(argv):
    # file_path = "data2.txt"
    file_path = argv[1]
    result = summarize_meeting_notes(file_path)
    print(result)

if __name__ == "__main__":
    main(sys.argv)
