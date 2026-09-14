#!/bin/bash
# ============================================================
# create_test_folders.sh
# For test41–test51:
#   - If the folder does NOT exist: copy from test_example and set
#     all fields (jobname, INPUT path, diag_table heading).
#   - If the folder ALREADY exists: only update the walltime.
#   - Walltime is updated for ALL folders (new and existing).
#
# New folders are created in the same directory as this script.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/test_example"
WALLTIME="5:00:00"
NCPU="96"
if [ ! -d "$SOURCE" ]; then
    echo "ERROR: Source folder not found: $SOURCE"
    exit 1
fi

for i in $(seq 245 253); do
    DEST="$SCRIPT_DIR/test${i}"

    echo "------------------------------------------------------------"

    if [ -d "$DEST" ]; then
        # ── Folder already exists — only update walltime ──────
        echo "test${i}: folder exists — updating walltime and jobname only only"

        CONFIG="$DEST/config.yaml"
        if [ -f "$CONFIG" ]; then
            sed -i "s/walltime: .*/walltime: $WALLTIME/" "$CONFIG"
            echo "  Updated walltime → $WALLTIME in config.yaml"
            sed -i "s/jobname: .*/jobname: test${i}/" "$CONFIG"
            echo "  Updated jobname → test${i} in config.yaml"

          
            sed -i "s/ncpus: .*/ncpus: $NCPU/" "$CONFIG"
            echo "  Updated ncpu → $NCPU in config.yaml"

            sed -i "s/test_example/test${i}/g" "$CONFIG"
            echo "  Updated all fields containing test_example (job name and input path) → $NCPU in config.yaml"
            
        else
            echo "  WARNING: config.yaml not found in $DEST"

        fi

        DIAG="$DEST/diag_table"
        if [ -f "$DIAG" ]; then
            sed -i "1s/test_example/test${i}/" "$DIAG"
            echo "  Updated: diag_table (heading → test${i})"
        else
            echo "  WARNING: diag_table not found in $DEST"
        fi

        
        OVERRIDE_FILE="$DEST/MOM_override" 
        NEW_LAYOUT="12,8" 
        
        if [ -f "$OVERRIDE_FILE" ]; then
            # Matches "#override LAYOUT = X,Y" and replaces X,Y with your new variable
            sed -i "s/\(#override LAYOUT =\).*/\1 $NEW_LAYOUT/" "$OVERRIDE_FILE"
            echo "  Updated: Mom_override (LAYOUT set to $NEW_LAYOUT)"
        else
            echo "  WARNING: $OVERRIDE_FILE not found"
        fi
        

    else
        # ── Folder missing — create from test_example ───────────────
        echo "test${i}: folder not found — copying from test_example"
        cp -r "$SOURCE" "$DEST"

        CONFIG="$DEST/config.yaml"
        if [ -f "$CONFIG" ]; then
            sed -i "s/jobname: test_example/jobname: test${i}/"          "$CONFIG"
            sed -i "s|/idealized/test_example/INPUT|/idealized/test${i}/INPUT|g" "$CONFIG"
            sed -i "s/walltime: .*/walltime: $WALLTIME/"            "$CONFIG"
            echo "  Updated: config.yaml (jobname, INPUT path, walltime)"
        else
            echo "  WARNING: config.yaml not found in $DEST"
        fi

        DIAG="$DEST/diag_table"
        if [ -f "$DIAG" ]; then
            sed -i "1s/test_example/test${i}/" "$DIAG"
            echo "  Updated: diag_table (heading → test${i})"
        else
            echo "  WARNING: diag_table not found in $DEST"
        fi

    fi

    echo "  Done: test${i}"
done

echo "============================================================"
echo "Finished. Walltime set to $WALLTIME for all experiments."
echo "============================================================"
