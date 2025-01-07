# noinspection PyInterpreter
from fastapi import FastAPI, Request
from pydantic import BaseModel
from transformers import AutoModelForQuestionAnswering, AutoTokenizer
import torch

app = FastAPI()

# Load BioBERT model and tokenizer
model_name = "dmis-lab/biobert-base-cased-v1.1"
model = AutoModelForQuestionAnswering.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

class Query(BaseModel):
    question: str
    context: str

@app.post("/answer")
async def get_answer(query: Query):
    inputs = tokenizer.encode_plus(query.question, query.context, return_tensors="pt")
    answer_start_scores, answer_end_scores = model(**inputs)

    answer_start = torch.argmax(answer_start_scores)
    answer_end = torch.argmax(answer_end_scores) + 1

    answer = tokenizer.convert_tokens_to_string(tokenizer.convert_ids_to_tokens(inputs["input_ids"][0][answer_start:answer_end]))
    return {"answer": answer}
