#!/bin/bash
# ============================================================
# run_all_experiments.sh
# Runs "payu run -n 4" for each experiment folder test41–test51.
# Must be placed in the same directory as the test folders.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for i in $(seq 250 253); do
    FOLDER="$SCRIPT_DIR/test${i}"

    echo "------------------------------------------------------------"

    if [ ! -d "$FOLDER" ]; then
        echo "test${i}: folder not found — skipping"
        continue
    fi

    echo "test${i}: starting payu run ..."
    cd "$FOLDER"
    #git init # needs to run the first time. 
    #git add .
    #git commit -m "Initialize MOM6 run log directory"
    payu run -n 2 #--new-uuid

    if [ $? -eq 0 ]; then
        echo "test${i}: submitted successfully"
    else
        echo "test${i}: WARNING — payu run returned an error"
    fi

    # Return to script directory before next iteration
    cd "$SCRIPT_DIR"
done

echo "============================================================"
echo "All experiments submitted."
echo "============================================================"
