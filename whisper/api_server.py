from fastapi import FastAPI, File, UploadFile
from faster_whisper import WhisperModel
import uvicorn
import os

app = FastAPI()
model = WhisperModel("small", device="cpu", compute_type="int8")

@app.post("/transcribe")
async def transcribe(file: UploadFile = File(...)):
    contents = await file.read()
    temp_file_path = "temp_audio_file"
    with open(temp_file_path, "wb") as f:
        f.write(contents)
    
    segments, _ = model.transcribe(temp_file_path, beam_size=5)
    text = " ".join([segment.text for segment in segments])
    os.remove(temp_file_path)
    return {"text": text}