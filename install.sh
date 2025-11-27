#!/usr/bin/env bash
set -euo pipefail

print_info() { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
print_success() { printf "\033[1;32m==>\033[0m %s\n" "$1"; }
print_error() { printf "\033[1;31m==>\033[0m %s\n" "$1"; }

install_bv() {
    local bin_name="bv"
    local repo="github.com/Dicklesworthstone/beads_viewer"

    print_info "Checking requirements..."
    if ! command -v go >/dev/null 2>&1; then
        print_error "Go is not installed. Please install Go (golang.org) first."
        exit 1
    fi

    # Check Go version is at least 1.21 for go install with @latest
    go_version=$(go version | grep -oP 'go\K[0-9]+\.[0-9]+' | head -1)
    major=$(echo "$go_version" | cut -d. -f1)
    minor=$(echo "$go_version" | cut -d. -f2)
    if [ "$major" -lt 1 ] || { [ "$major" -eq 1 ] && [ "$minor" -lt 21 ]; }; then
        print_error "Go 1.21 or later is required. Found: go$go_version"
        exit 1
    fi

    print_info "Installing bv via go install..."

    # Use go install to fetch and build the latest version
    if go install "$repo/cmd/bv@latest"; then
        # Find where Go installed it
        local gobin="${GOBIN:-$(go env GOPATH)/bin}"
        local installed_path="$gobin/$bin_name"

        if [ -f "$installed_path" ]; then
            print_success "Successfully installed $bin_name to $installed_path"

            # Check if it's in PATH
            if ! command -v "$bin_name" >/dev/null 2>&1; then
                print_info "Note: $gobin may not be in your PATH."
                print_info "Add this to your shell profile:"
                print_info "  export PATH=\"\$PATH:$gobin\""
            else
                print_info "Run '$bin_name' in any beads project to view issues."
            fi
        else
            print_error "Binary not found at expected location: $installed_path"
            exit 1
        fi
    else
        print_error "Installation failed."
        exit 1
    fi
}

install_bv
