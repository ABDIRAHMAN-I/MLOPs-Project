async function fetchResults() {
    const resultsDiv = document.getElementById('results');
    resultsDiv.style.display = "block"; // Show the results box
    resultsDiv.innerHTML = "Running the model..."; // Show a loading message

    try {
        // Step 1: Trigger the model execution
        const runModelResponse = await fetch('/api/run-model', { method: 'POST' });
        const runModelResult = await runModelResponse.json();

        if (runModelResponse.ok) {
            resultsDiv.innerHTML = "Fetching updated results...";

            // Step 2: Fetch the results from /api/images
            const resultsResponse = await fetch('/api/images');
            
            // Check if the fetch was successful
            if (!resultsResponse.ok) {
                throw new Error(`HTTP error! status: ${resultsResponse.status}`);
            }

            const resultsData = await resultsResponse.json();

            // Debugging output
            console.log("Results Data:", resultsData);

            if (Array.isArray(resultsData)) {
                resultsDiv.innerHTML = ""; // Clear loading message
                const ul = document.createElement('ul');

                resultsData.forEach(image => {
                    const li = document.createElement('li');
                    li.innerHTML = `<strong>Image: ${image.image}</strong>`;
                    ul.appendChild(li);

                    const nestedUl = document.createElement('ul');
                    image.detections.forEach(detection => {
                        const nestedLi = document.createElement('li');
                        nestedLi.textContent = `Label: ${detection.label}, Confidence: ${detection.confidence.toFixed(2)}`;
                        nestedUl.appendChild(nestedLi);
                    });

                    ul.appendChild(nestedUl);
                });

                resultsDiv.appendChild(ul);
            } else {
                resultsDiv.innerHTML = "Error: API did not return an array.";
                console.error("Unexpected API response:", resultsData);
            }
        } else {
            resultsDiv.innerHTML = `Error: ${runModelResult.error}`;
        }
    } catch (error) {
        // Catch and log errors
        resultsDiv.innerHTML = "Error running the model or fetching results.";
        console.error("Error:", error);
    }
}

