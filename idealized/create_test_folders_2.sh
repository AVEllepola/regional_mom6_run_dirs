#!/bin/bash
# ============================================================
# create_test_folders.sh
#   - If the folder does NOT exist: copy from test_example and set
#     all fields (jobname, INPUT path, diag_table heading).
#   - If the folder ALREADY exists: update walltime, jobname, ncpus,
#     any leftover test_example references, and remove ua8 from gdata.
#   - MOM_override LAYOUT is updated for existing folders.
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

EXPERIMENTS=(161 162 173 174 176 177 178 179 180 181 182 183 184 185 186 187 188 189 200 201 202 203 204 205 206 207 219)

for name in "${EXPERIMENTS[@]}"; do
    DEST="$SCRIPT_DIR/${name}"

    echo "------------------------------------------------------------"

    if [ -d "$DEST" ]; then
        # ── Folder already exists — update fields ──────
        echo "${name}: folder exists — updating walltime, jobname, ncpus, gdata"

        CONFIG="$DEST/config.yaml"
        if [ -f "$CONFIG" ]; then
            sed -i "s/walltime: .*/walltime: $WALLTIME/" "$CONFIG"
            echo "  Updated walltime → $WALLTIME in config.yaml"
            sed -i "s/jobname: .*/jobname: ${name}/" "$CONFIG"
            echo "  Updated jobname → ${name} in config.yaml"

            sed -i "s/ncpus: .*/ncpus: $NCPU/" "$CONFIG"
            echo "  Updated ncpu → $NCPU in config.yaml"

            sed -i "s/test_example/${name}/g" "$CONFIG"
            echo "  Updated all fields containing test_example → ${name} in config.yaml"

            sed -i "/^\s*-\s*ua8\s*$/d" "$CONFIG"
            echo "  Removed: ua8 from gdata list (if present) in config.yaml"

        else
            echo "  WARNING: config.yaml not found in $DEST"
        fi

        DIAG="$DEST/diag_table"
        if [ -f "$DIAG" ]; then
            sed -i "1s/test_example/${name}/" "$DIAG"
            echo "  Updated: diag_table (heading → ${name})"
        else
            echo "  WARNING: diag_table not found in $DEST"
        fi

        OVERRIDE_FILE="$DEST/MOM_override"
        NEW_LAYOUT="12,8"

        if [ -f "$OVERRIDE_FILE" ]; then
            # Matches "#override LAYOUT = X,Y" and replaces X,Y with your new variable
            sed -i "s/\(#override LAYOUT =\).*/\1 $NEW_LAYOUT/" "$OVERRIDE_FILE"
            echo "  Updated: MOM_override (LAYOUT set to $NEW_LAYOUT)"
        else
            echo "  WARNING: $OVERRIDE_FILE not found"
        fi

    else
        # ── Folder missing — create from test_example ───────────────
        echo "${name}: folder not found — copying from test_example"
        cp -r "$SOURCE" "$DEST"

        CONFIG="$DEST/config.yaml"
        if [ -f "$CONFIG" ]; then
            sed -i "s/jobname: test_example/jobname: ${name}/"          "$CONFIG"
            sed -i "s|/idealized/test_example/INPUT|/idealized/${name}/INPUT|g" "$CONFIG"
            sed -i "s/walltime: .*/walltime: $WALLTIME/"            "$CONFIG"
            sed -i "/^\s*-\s*ua8\s*$/d" "$CONFIG"
            echo "  Updated: config.yaml (jobname, INPUT path, walltime, removed ua8 from gdata)"
        else
            echo "  WARNING: config.yaml not found in $DEST"
        fi

        DIAG="$DEST/diag_table"
        if [ -f "$DIAG" ]; then
            sed -i "1s/test_example/${name}/" "$DIAG"
            echo "  Updated: diag_table (heading → ${name})"
        else
            echo "  WARNING: diag_table not found in $DEST"
        fi

    fi

    echo "  Done: ${name}"
done

echo "============================================================"
echo "Finished. Walltime set to $WALLTIME for all experiments."
echo "============================================================"
