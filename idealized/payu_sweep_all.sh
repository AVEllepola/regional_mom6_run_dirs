#!/bin/bash
# ============================================================
# run_all_experiments.sh
# Runs "payu run -n 4" for each experiment folder test41–test51.
# Must be placed in the same directory as the test folders.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXPERIMENTS=(161 162 173 174 176 177 178 179 180 181 182 183 184 185 186 187 188 189 200 201 202 203 204 205 206 207 219)

for  i in "${EXPERIMENTS[@]}"; do
    FOLDER="$SCRIPT_DIR/test${i}"

    echo "------------------------------------------------------------"

    if [ ! -d "$FOLDER" ]; then
        echo "test${i}: folder not found — skipping"
        continue
    fi

    echo "test${i}: starting payu sweep ..."
    cd "$FOLDER"
   
    payu sweep


    if [ $? -eq 0 ]; then
        echo "test${i}: swept successfully"
    else
        echo "test${i}: WARNING — payu sweep returned an error"
    fi

    # Return to script directory before next iteration
    cd "$SCRIPT_DIR"
done

echo "============================================================"
echo "All experiments submitted."
echo "============================================================"
