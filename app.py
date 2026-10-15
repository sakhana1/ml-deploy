from fastapi import FastAPI
import joblib

app = FastAPI()
model = joblib.load("model.pkl")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict")
def predict(features: list[float]):
    return {"prediction": model.predict([features]).tolist()}
