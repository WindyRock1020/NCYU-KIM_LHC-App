from flask import Flask, request, jsonify, render_template, redirect, url_for
from flask_cors import CORS
from datetime import datetime
import os
import cv2
import warnings
from mediapipe.tasks.python.core.base_options import BaseOptions
from mediapipe.tasks.python.vision.core.vision_task_running_mode import VisionTaskRunningMode
from mediapipe.tasks.python.vision.pose_landmarker import PoseLandmarker, PoseLandmarkerOptions
import mediapipe as mp
from src.mediapipe_lib.base import PoseResult, ResultAnalyzer 
from collections import OrderedDict
import json
import time

app = Flask(__name__)
CORS(app) 
app.config['UPLOAD_FOLDER'] = 'uploads/'
app.config['ALLOWED_EXTENSIONS'] = {'mp4'} 
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'
warnings.filterwarnings("ignore")

MODEL = "./models/pose_landmarker_full.task"
# OUTPUT_DIR = "inOut/rst/"
# os.makedirs(OUTPUT_DIR, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400
    file = request.files['file']
    if file.filename == '':
        return redirect(request.url)
    if file and allowed_file(file.filename):
            timestamp = datetime.now().isoformat().replace(":", "-")
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], f"{timestamp}.mp4")
            file.save(file_path)
            result = process_video(file_path)
            response = app.response_class(
                response=json.dumps(result, ensure_ascii=False),
                mimetype='application/json'
            )
            return response

def process_video(video_path):
    checkPersonInScreen = False
    try:
        cap = cv2.VideoCapture(video_path)
        fps = int(cap.get(cv2.CAP_PROP_FPS))
        options = PoseLandmarkerOptions(base_options=BaseOptions(model_asset_path=MODEL), running_mode=VisionTaskRunningMode.VIDEO)
        landmarker = PoseLandmarker.create_from_options(options)

        is_3d = True
        frame_count = 0
        A_array = []
        B_array = []
        C_array = []
        D_array = []

        frame_counts = []
        labels = []

        pose_mapping = {
            'A1': 1,
            'A2': 2,
            'A3': 3,
            'A4': 4,
            'A5': 5,
        }

        pose_scores = {
            (1, 1): 0, (1, 2): 3, (1, 3): 3, (1, 4): 7, (1, 5): 9,
            (2, 2): 5, (2, 3): 5, (2, 4): 10, (2, 5): 13,
            (3, 3): 5, (3, 4): 10, (3, 5): 13,
            (4, 4): 15, (4, 5): 18,
            (5, 5): 20
        }

        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            mp_img = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
            result = landmarker.detect_for_video(mp_img, int(time.time() * 1000))

            pose_result = PoseResult(result)
            analyzer = ResultAnalyzer(pose_result)

            label = analyzer.get_lhc_label(is_3d)
            frame_counts.append(frame_count)
            labels.append(pose_mapping.get(label, 0))

            if len(result.pose_landmarks) > 0:
                A_array.append(analyzer.check_if_trunk_is_twisted(is_3d))
                B_array.append(analyzer.check_if_hands_at_a_distance(is_3d))
                C_array.append(analyzer.check_if_arms_raised(is_3d))
                D_array.append(analyzer.check_if_hands_above_shoulder(is_3d))

            frame_count += 1
        cap.release()

        total_frames = frame_count

        con = 5
        csv = 90
        consecutive_count = 0
        label_changes = []
        current_label = None
        previous_label = None
        previous_count = 0

        for i in range(len(labels)):
            if labels[i] == current_label:
                consecutive_count += 1
            elif consecutive_count < 5:
                current_label = labels[i]
                total_frames -= consecutive_count
                for j in range(1, consecutive_count + 1):
                    A_array[i - j] = 0
                    B_array[i - j] = 0
                    C_array[i - j] = 0
                    D_array[i - j] = 0
                    labels[i - j] = None
                if labels[i] == previous_label:
                    consecutive_count = previous_count + 1
                else:
                    consecutive_count = 1
            else:
                previous_count = consecutive_count
                previous_label = current_label
                consecutive_count = 1
                current_label = labels[i]

            if consecutive_count == con:
                label_changes.append(current_label)
            elif consecutive_count == csv:
                label_changes.append(current_label)

        A_ratio = sum(A_array) / total_frames
        B_ratio = sum(B_array) / total_frames
        C_ratio = sum(C_array) / total_frames
        D_ratio = sum(D_array) / total_frames

        max_score = 0
        best_pair = (None, None)
        for i in range(len(label_changes) - 1):
            pair = (label_changes[i], label_changes[i + 1])
            score = pose_scores.get(pair, pose_scores.get((pair[1], pair[0]), 0))
            if score > max_score:
                max_score = score
                best_pair = pair

        def get_frequency_score(ratio, none_score, occasional_score, frequent_score):
            if ratio < 1 / 9:
                return none_score
            elif ratio < 1 / 3:
                return occasional_score
            else:
                return frequent_score

        A_score = get_frequency_score(A_ratio, 0, 1, 3)
        B_score = get_frequency_score(B_ratio, 0, 1, 3)
        C_score = get_frequency_score(C_ratio, 0, 0.5, 1)
        D_score = get_frequency_score(D_ratio, 0, 1, 2)

        extra_score = A_score + B_score + C_score + D_score
        if extra_score > 6:
            extra_score = 6

        total_score = max_score + extra_score

        result = OrderedDict([
            ("BodyPosturePoint", max_score),
            ("Addition Point", extra_score),
            ("twist", A_score),
            ("above shoulder", D_score),
            ("arm raise", C_score),
            ("distance of body", B_score),
            ("total_score", total_score),
            ("start", best_pair[0] if best_pair[0] is not None else 0),
            ("end", best_pair[1] if best_pair[1] is not None else 0),
            ("checkPersonInScreen", checkPersonInScreen)
        ])

    except Exception as e:
        checkPersonInScreen = True
        result = OrderedDict([
            ("checkPersonInScreen", checkPersonInScreen),
            ("error", str(e))
        ])
    print("completed")
    return result

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)