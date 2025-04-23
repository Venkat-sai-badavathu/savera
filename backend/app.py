from flask import Flask, request, jsonify
from flask_cors import CORS
import ollama
import os
import cv2
import numpy as np
from werkzeug.utils import secure_filename
import tensorflow as tf
from tensorflow.keras.preprocessing import image
from tensorflow.keras.models import load_model

# Load your TensorFlow model and dependencies
model_path = r'C:\Users\HP\Desktop\App\savera2.0\backend\panic_detector_cnn.h5'
print("🔍 Looking for model at:", os.path.abspath(model_path))
model = load_model(model_path)
img_size = (48, 48)  # Example image size, update according to your model's input size
base_threshold = 0.5  # Set your base threshold
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')  # Haar Cascade for face detection

# Suggest safe places and message function (you can customize this)
def suggest_safe_places_and_message():
   return """
        It seems like you're in distress. Please stay calm. Here's what you can do right now:

        • Move to a safe and crowded place nearby.  
        Use the map to see directions and choose the nearest public or busy area. Avoid dark or isolated paths.

        • Press the Emergency Button 🆘  
        This will immediately send your live location to your emergency contacts so they can reach you faster.

        • Stay calm — you are not alone.  
        Take deep breaths. Help is on the way. Our chat assistant is here for emotional support. You can talk to us anytime.

        • If you feel unsafe, try calling a friend or trusted contact and keep them updated on your location and surroundings.

        • Keep your phone in your hand, stay visible, and make sure it’s charged. If you have a power bank, plug it in.

        Remember, you are strong, and you're doing the right thing. We're here with you every step of the way.
        """




app = Flask(__name__)
CORS(app)

chat_history = [
    {
        "role": "system",
        "content": (
            "You are a calming and supportive virtual assistant. "
            "You are talking to a panicked woman. Respond gently, help her calm down, "
            "ask supportive questions, and guide her toward safety if needed."
        )
    }
]

@app.route('/api/message', methods=['POST'])
def get_bot_reply():
    data = request.get_json()
    message = data.get('message', '')

    if not message:
        return jsonify({'reply': "Please enter a message."}), 400

    print(f"\n👩 User: {message}")
    chat_history.append({"role": "user", "content": message})

    try:
        response = ollama.chat(
            model="phi3",
            messages=chat_history
        )
        assistant_reply = response['message']['content']
        chat_history.append({"role": "assistant", "content": assistant_reply})
        print(f"🤖 Assistant: {assistant_reply}\n")
        return jsonify({'reply': assistant_reply})
    
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return jsonify({'reply': f"Error: {str(e)}"}), 500

@app.route('/api/reset', methods=['POST'])
def reset_chat():
    global chat_history
    chat_history = [
        {
            "role": "system",
            "content": (
                "You are a calming and supportive virtual assistant. "
                "You are talking to a panicked woman. Respond gently, help her calm down, "
                "ask supportive questions, and guide her toward safety if needed."
            )
        }
    ]
    print("🔄 Chat history has been reset.")
    return jsonify({'status': 'reset'})

@app.route('/api/panic-detect', methods=['POST'])
def detect_panic_endpoint():
    if 'image' not in request.files:
        return jsonify({'error': 'No image file provided'}), 400

    image = request.files['image']
    if image.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    filename = secure_filename(image.filename)
    upload_folder = 'uploads'
    os.makedirs(upload_folder, exist_ok=True)
    filepath = os.path.join(upload_folder, filename)
    image.save(filepath)

    try:
        result, suggestion = detect_panic(filepath)
        return jsonify({
            'panic_detected': result,
            'suggestion': suggestion if result else "No panic detected"
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

def detect_panic(image_path, is_cropped_face=False):
    print(f"\n📷 Processing image: {image_path}")
    img = cv2.imread(image_path)
    if img is None:
        raise ValueError("Invalid image file.")

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    panic_detected = False

    def predict_panic(face_img):
        # Resize image to fit model input and convert to tensor
        face_img = cv2.resize(face_img, img_size)
        face_img = np.expand_dims(face_img, axis=-1)  # (48, 48, 1)
        face_img = np.expand_dims(face_img, axis=0)   # (1, 48, 48, 1)

        # Normalize the image
        face_img = face_img.astype("float32") / 255.0
        if face_img.ndim == 2:  # Grayscale
            face_img = np.expand_dims(face_img, axis=-1)
        # Make prediction
        prediction = model.predict(face_img)
        score = prediction[0][0]
        return score
    
    

    if is_cropped_face:
        score = predict_panic(gray)
        dynamic_threshold = base_threshold + (0.1 if score < 0.5 else -0.1 if score > 0.7 else 0)
        label = "😨 Panic" if score > dynamic_threshold else "🙂 Not Panic"
        print(f"🧠 Prediction: {label} (score={score:.4f})")
        panic_detected = score > dynamic_threshold
    else:
        faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)
        if len(faces) == 0:
            print("❌ No face detected.")
            return False, "No face detected"

        print(f"👤 Detected {len(faces)} face(s).")
        for i, (x, y, w, h) in enumerate(faces):
            roi_gray = gray[y:y+h, x:x+w]
            score = predict_panic(roi_gray)
            dynamic_threshold = base_threshold + (0.1 if score < 0.5 else -0.1 if score > 0.7 else 0)
            is_panic = score > dynamic_threshold
            label = "😨 Panic" if is_panic else "🙂 Not Panic"
            print(f"🧠 Face {i+1} - Prediction: {label} (score={score:.4f})")
            if is_panic:
                panic_detected = True

    if panic_detected:
        print("\n🛑 Panic detected! Getting calming suggestion...")
        suggestion = suggest_safe_places_and_message()
        print(f"💬 Suggestion: {suggestion}")
        return True, suggestion
    else:
        return False, None

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
