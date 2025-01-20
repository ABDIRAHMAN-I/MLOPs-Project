from flask import Flask, render_template, jsonify
import json
import os
import subprocess

app = Flask(__name__)

try:
    import ultralytics
except ImportError:
    os.system("pip install ultralytics")

# Function to load results from the JSON file
def load_results():
    file_path = os.path.join(os.path.dirname(__file__), './results/consolidated_results.json')
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            return json.load(file)
    else:
        return {"error": "Results not available. Please run the model first."}

# Function to clear the results folder (deletes only files, keeps the folder)
def clear_results_folder():
    results_folder = os.path.join(os.path.dirname(__file__), 'results')
    if os.path.exists(results_folder):
        for filename in os.listdir(results_folder):
            file_path = os.path.join(results_folder, filename)
            try:
                if os.path.isfile(file_path) or os.path.islink(file_path):
                    os.unlink(file_path)  # Delete the file or symlink
            except Exception as e:
                print(f"Failed to delete {file_path}. Reason: {e}")

# Route for the landing page
@app.route("/")
def index():
    return render_template("index.html")

# API endpoint to trigger the model
@app.route("/api/run-model", methods=["POST"])
def run_model():
    try:
        # Step 1: Clear the results folder
        clear_results_folder()

        # Step 2: Run the model.py script
        subprocess.run(["python", "model.py"], check=True)
        return jsonify({"message": "Model executed successfully."})
    except subprocess.CalledProcessError as e:
        return jsonify({"error": f"Error executing model: {str(e)}"}), 500

@app.route("/api/images", methods=["GET"])
def get_results():
    results = load_results()
    return jsonify(results)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=3000)

