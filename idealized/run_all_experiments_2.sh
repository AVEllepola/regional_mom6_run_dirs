#!/bin/bash
# ============================================================
# run_all_experiments.sh
# Runs "payu run -n 2" for each experiment folder listed in EXPERIMENTS.
# Must be placed in the same directory as the test folders.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EXPERIMENTS=(test173 test176 test177 test178 test179 test183 test184 test185 test186 test187 test188 test189 test205 test206 test207 test220 test221 test222 test223 test224 test225 test226 test227 test231)

for name in "${EXPERIMENTS[@]}"; do
    FOLDER="$SCRIPT_DIR/$name"

    echo "------------------------------------------------------------"

    if [ ! -d "$FOLDER" ]; then
        echo "$name: folder not found — skipping"
        continue
    fi

    echo "$name: starting payu run ..."
    cd "$FOLDER"
    #git init # needs to run the first time.
    #git add .
    #git commit -m "Initialize MOM6 run log directory"
    payu run -n 1 #--new-uuid

    if [ $? -eq 0 ]; then
        echo "$name: submitted successfully"
    else
        echo "$name: WARNING — payu run returned an error"
    fi

    # Return to script directory before next iteration
    cd "$SCRIPT_DIR"
done

echo "============================================================"
echo "All experiments submitted."
echo "============================================================"
