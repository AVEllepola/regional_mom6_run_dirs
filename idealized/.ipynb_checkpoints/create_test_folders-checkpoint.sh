#!/bin/bash
# ============================================================
# create_test_folders.sh
# For test41–test51:
#   - If the folder does NOT exist: copy from test41 and set
#     all fields (jobname, INPUT path, diag_table heading).
#   - If the folder ALREADY exists: only update the walltime.
#   - Walltime is updated for ALL folders (new and existing).
#
# New folders are created in the same directory as this script.
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/test41"
WALLTIME="8:00:00"

if [ ! -d "$SOURCE" ]; then
    echo "ERROR: Source folder not found: $SOURCE"
    exit 1
fi

for i in $(seq 41 51); do
    DEST="$SCRIPT_DIR/test${i}"

    echo "------------------------------------------------------------"

    if [ -d "$DEST" ]; then
        # ── Folder already exists — only update walltime ──────
        echo "test${i}: folder exists — updating walltime only"

        CONFIG="$DEST/config.yaml"
        if [ -f "$CONFIG" ]; then
            sed -i "s/walltime: .*/walltime: $WALLTIME/" "$CONFIG"
            echo "  Updated walltime → $WALLTIME in config.yaml"
        else
            echo "  WARNING: config.yaml not found in $DEST"
        fi

    else
        # ── Folder missing — create from test41 ───────────────
        echo "test${i}: folder not found — copying from test41"
        cp -r "$SOURCE" "$DEST"

        CONFIG="$DEST/config.yaml"
        if [ -f "$CONFIG" ]; then
            sed -i "s/jobname: test41/jobname: test${i}/"          "$CONFIG"
            sed -i "s|/idealized/test41/INPUT|/idealized/test${i}/INPUT|g" "$CONFIG"
            sed -i "s/walltime: .*/walltime: $WALLTIME/"            "$CONFIG"
            echo "  Updated: config.yaml (jobname, INPUT path, walltime)"
        else
            echo "  WARNING: config.yaml not found in $DEST"
        fi

        DIAG="$DEST/diag_table"
        if [ -f "$DIAG" ]; then
            sed -i "1s/test41/test${i}/" "$DIAG"
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
