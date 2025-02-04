#!/bin/bash

# Debug log helper
log() {
    echo "[import_listings.sh] $1"
}

# Set working directory to script location
cd "$(dirname "$0")"
log "Changed to script directory"

# Build the package
log "Building package..."
swift build
if [ $? -ne 0 ]; then
    log "Build failed"
    exit 1
fi

# Get the path to the CSV file
CSV_PATH="../Sources/RealTokCore/Resources/sample_listings.csv"
if [ ! -f "$CSV_PATH" ]; then
    log "Error: CSV file not found at $CSV_PATH"
    exit 1
fi

# Run the import tool
log "Running import tool..."
.build/debug/ImportTool "$CSV_PATH"
if [ $? -ne 0 ]; then
    log "Import failed"
    exit 1
fi

log "Import completed successfully" 