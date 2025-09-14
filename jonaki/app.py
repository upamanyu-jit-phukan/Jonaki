from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import numpy as np
import joblib
import logging

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter frontend

# Set up logging
logging.basicConfig(
    filename='api.log',
    level=logging.INFO,
    format='%(asctime)s %(levelname)s: %(message)s'
)
logger = logging.getLogger(__name__)

# Load the model
try:
    model = joblib.load("xgboost_dropout_model.pkl")
    logger.info("Model loaded successfully")
except Exception as e:
    logger.error(f"Failed to load model: {str(e)}")
    raise

# Define suggestion function
def get_suggestions(student, predicted_prob):
    suggestions = []

    # Attendance risk
    if student["Attendance"] < 60:
        suggestions.append(
            "⚠️ Attendance is quite low, which could put the student at risk of being debarred from exams. "
            "Encourage setting up small daily routines and contacting faculty if there are valid reasons for missing classes."
        )

    # Academic risk
    if student["Current_GPA"] < 6:
        suggestions.append(
            "📚 The current GPA is on the lower side, which may increase academic pressure. "
            "Recommend remedial classes, peer study groups, or guidance from seniors/professors."
        )
    if student["GPA_Diff"] < -0.5:
        suggestions.append(
            "📉 GPA has dropped significantly compared to the previous semester. "
            "Consider academic counseling and exploring new study methods."
        )

    # Non-productive hours
    if student["NonProductive_Hrs"] > 4:
        suggestions.append(
            "🧠 High non-productive hours detected (e.g., social media or gaming). "
            "Encourage balancing screen time with offline activities, hobbies, or counseling to improve focus."
        )

    # Productive hours
    if student["Productive_Hrs"] < 1:
        suggestions.append(
            "⏰ Low productive study time detected. Promote focused study sessions, time management apps, or structured study schedules."
        )

    # Extracurricular involvement
    if student["Club_Score"] < 2:
        suggestions.append(
            "🎭 Limited extracurricular involvement. Encourage joining clubs or campus activities to build social support and skills."
        )

    # Internship risk
    if student["Internship_Status"] == 0:
        suggestions.append(
            "💼 No internship experience detected. Encourage participation in internships to gain practical exposure and improve employability."
        )

    # Financial risk
    if student["Family_Income"] in ['<1 LPA', '1-5 LPA']:
        suggestions.append(
            "💰 Family income is on the lower side. Suggest applying for scholarships, financial aid programs, or government-funded internships."
        )

    # Mental health risk
    if student["Sentiment_Score"] < 0:
        suggestions.append(
            "😔 Negative sentiment detected. Recommend counseling services, peer support groups, or mental health resources."
        )

    # High dropout risk
    if predicted_prob > 0.8:
        suggestions.append(
            "🚨 High dropout risk predicted. Schedule a meeting with an academic advisor to discuss personalized support options."
        )

    if not suggestions:
        suggestions.append(
            "✅ Student is managing academics, attendance, and personal life well. Continue monitoring progress and supporting consistent performance."
        )

    return suggestions

# API endpoint for predictions and suggestions
@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get JSON data from request
        data = request.get_json()
        logger.info(f"Received request with data: {data}")

        # Apply safe defaults for missing optional fields
        defaults = {
            "Sentiment_Score": 0,
            "Family_Income": "5-10 LPA",
            "SemiProductive_Hrs": 0
        }
        for key, val in defaults.items():
            if key not in data:
                data[key] = val

        # Required features for model
        required_features = [
            'Attendance', 'Current_GPA', 'Previous_GPA', 'GPA_Diff',
            'NonProductive_Hrs', 'Productive_Hrs', 'Club_Score',
            'Internship_Status', 'Family_Income', 'Sentiment_Score'
        ]
        missing = [f for f in required_features if f not in data]
        if missing:
            logger.warning(f"Missing features: {missing}")
            return jsonify({'error': f"Missing features: {', '.join(missing)}"}), 400

        # Keep original data for suggestions
        suggestion_data = data.copy()

        # Convert Family_Income to one-hot encoding
        student_df = pd.DataFrame([data])
        student_df = pd.get_dummies(student_df, columns=['Family_Income'])
        for col in model.feature_names_in_:
            if col not in student_df.columns:
                student_df[col] = 0
        student_df = student_df[model.feature_names_in_]

        # Predict
        pred_prob = model.predict(student_df)[0]
        pred_prob = np.clip(pred_prob, 0, 1)

        # Suggestions
        suggestions = get_suggestions(suggestion_data, pred_prob)

        logger.info(f"Prediction: {pred_prob}, Suggestions: {suggestions}")

        return jsonify({
            'dropout_probability': round(pred_prob * 100, 1),
            'suggestions': suggestions
        })

    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)
