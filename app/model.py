import os
import json
from pathlib import Path
from ultralytics import YOLO

# Load the YOLO model
model_path = 'yolov8n.pt'
if not os.path.exists(model_path):
    raise FileNotFoundError(f"YOLO model file not found: {model_path}")
model = YOLO(model_path)

# Get the absolute path to the parent directory of the script
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '.'))


input_dir = os.path.join(base_dir, 'images')
output_dir = os.path.join(base_dir, 'results')

if not os.path.exists(input_dir):
    raise FileNotFoundError(f"Input directory does not exist: {input_dir}")

Path(output_dir).mkdir(parents=True, exist_ok=True)



# Process each image in the input directory
output_data = []
for image_name in os.listdir(input_dir):
    print(f"Processing: {image_name}")
    image_path = os.path.join(input_dir, image_name)

    # Run YOLOv8 on the image
    results = model(image_path)
    print(f"Detections for {image_name}: {len(results)} objects")

    # Extract results for JSON output
    image_results = {
        "image": image_name,
        "detections": []
    }

    for result in results:
        for box in result.boxes:
            bbox = box.xyxy[0].tolist()
            confidence = float(box.conf[0])
            label = model.names[int(box.cls[0])]
            image_results["detections"].append({
                "bounding_box": {
                    "x_min": bbox[0],
                    "y_min": bbox[1],
                    "x_max": bbox[2],
                    "y_max": bbox[3]
                },
                "confidence": confidence,
                "label": label
            })

    # Append image results to consolidated data
    output_data.append(image_results)

# Save the consolidated results as a JSON file
consolidated_json_path = os.path.join(output_dir, "consolidated_results.json")
try:
    with open(consolidated_json_path, 'w') as json_file:
        json.dump(output_data, json_file, indent=4)
    print(f"Consolidated results saved to: {consolidated_json_path}")
except Exception as e:
    print(f"Error saving consolidated results: {e}")
