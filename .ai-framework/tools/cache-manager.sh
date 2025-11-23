#!/bin/bash

# Cache Manager - Response Caching System for Subscription Value Optimization
# Manages cached responses, TTL, invalidation, and performance tracking

set -e

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CACHE_DIR="$FRAMEWORK_ROOT/.ai-framework/cache"
CONFIG_FILE="$CACHE_DIR/config/cache-config.json"
INDEX_FILE="$CACHE_DIR/metadata/cache-index.json"
STATS_FILE="$CACHE_DIR/metadata/usage-stats.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Ensure cache directories exist
init_cache() {
    mkdir -p "$CACHE_DIR/responses/"{board-status,explanations,code-patterns,templates}
    mkdir -p "$CACHE_DIR/metadata"
    mkdir -p "$CACHE_DIR/config"

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Error: Cache configuration not found"
        return 1
    fi
}

# Generate cache key from input
generate_cache_key() {
    local category="$1"
    local identifier="$2"
    echo "${category}_$(echo -n "$identifier" | md5sum | cut -d' ' -f1)"
}

# Check if cache entry exists and is valid
check_cache() {
    local category="$1"
    local key="$2"

    local cache_file="$CACHE_DIR/responses/$category/$key.cache"

    if [ ! -f "$cache_file" ]; then
        echo "MISS"
        return 1
    fi

    # Check TTL
    if command -v jq >/dev/null 2>&1 && [ -f "$INDEX_FILE" ]; then
        local created_at=$(jq -r ".entries[\"$key\"].created_at" "$INDEX_FILE" 2>/dev/null || echo "0")
        local ttl=$(jq -r ".cache_categories[\"$category\"].ttl_seconds" "$CONFIG_FILE" 2>/dev/null || echo "300")
        local current_time=$(date +%s)
        local created_time=$(date -d "$created_at" +%s 2>/dev/null || echo "0")
        local age=$((current_time - created_time))

        if [ "$age" -gt "$ttl" ]; then
            echo "EXPIRED"
            rm -f "$cache_file"
            return 1
        fi
    fi

    echo "HIT"
    return 0
}

# Store content in cache
cache_set() {
    local category="$1"
    local key="$2"
    local content="$3"

    init_cache

    local cache_file="$CACHE_DIR/responses/$category/$key.cache"

    # Store content
    echo "$content" > "$cache_file"

    # Update index
    if command -v jq >/dev/null 2>&1; then
        local size=$(stat -f%z "$cache_file" 2>/dev/null || stat -c%s "$cache_file" 2>/dev/null || echo "0")
        local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

        local temp_file=$(mktemp)
        jq --arg key "$key" \
           --arg cat "$category" \
           --arg ts "$timestamp" \
           --arg size "$size" \
           ".entries[\"$key\"] = {category: \$cat, created_at: \$ts, size_bytes: (\$size | tonumber)} |
            .total_entries += 1 |
            .total_size_bytes += (\$size | tonumber)" \
           "$INDEX_FILE" > "$temp_file" 2>/dev/null || echo '{"entries":{}}' > "$temp_file"
        mv "$temp_file" "$INDEX_FILE"
    fi

    echo -e "${GREEN}✅ Cached: $category/$key${NC}"
}

# Retrieve content from cache
cache_get() {
    local category="$1"
    local key="$2"

    local result=$(check_cache "$category" "$key")

    if [ "$result" = "HIT" ]; then
        cat "$CACHE_DIR/responses/$category/$key.cache"

        # Update stats
        update_stats "$category" "HIT"
        return 0
    else
        update_stats "$category" "MISS"
        return 1
    fi
}

# Invalidate cache entry or category
cache_invalidate() {
    local target="$1"

    if [ -z "$target" ]; then
        # Clear all cache
        echo -e "${YELLOW}Clearing all cache...${NC}"
        rm -rf "$CACHE_DIR/responses/"*/*.cache
        echo -e "${GREEN}✅ All cache cleared${NC}"
    elif [ -d "$CACHE_DIR/responses/$target" ]; then
        # Clear category
        echo -e "${YELLOW}Clearing $target cache...${NC}"
        rm -f "$CACHE_DIR/responses/$target"/*.cache
        echo -e "${GREEN}✅ $target cache cleared${NC}"
    else
        echo -e "${RED}Invalid cache target${NC}"
        return 1
    fi

    # Reset index
    if command -v jq >/dev/null 2>&1; then
        local temp_file=$(mktemp)
        jq '.total_entries = 0 | .total_size_bytes = 0 | .entries = {}' "$INDEX_FILE" > "$temp_file"
        mv "$temp_file" "$INDEX_FILE"
    fi
}

# Update usage statistics
update_stats() {
    local category="$1"
    local result="$2"  # HIT or MISS

    if [ ! -f "$STATS_FILE" ] || ! command -v jq >/dev/null 2>&1; then
        return
    fi

    local temp_file=$(mktemp)

    if [ "$result" = "HIT" ]; then
        jq ".global_stats.cache_hits += 1 |
            .global_stats.total_requests += 1 |
            .category_stats[\"$category\"].hits += 1 |
            .category_stats[\"$category\"].requests += 1 |
            .last_updated = now | strftime(\"%Y-%m-%dT%H:%M:%SZ\")" \
            "$STATS_FILE" > "$temp_file"
    else
        jq ".global_stats.cache_misses += 1 |
            .global_stats.total_requests += 1 |
            .category_stats[\"$category\"].misses += 1 |
            .category_stats[\"$category\"].requests += 1 |
            .last_updated = now | strftime(\"%Y-%m-%dT%H:%M:%SZ\")" \
            "$STATS_FILE" > "$temp_file"
    fi

    mv "$temp_file" "$STATS_FILE"
}

# Show cache statistics
show_stats() {
    echo -e "${CYAN}📊 CACHE PERFORMANCE STATISTICS${NC}"
    echo ""

    if [ -f "$STATS_FILE" ] && command -v jq >/dev/null 2>&1; then
        local total_requests=$(jq -r '.global_stats.total_requests' "$STATS_FILE")
        local cache_hits=$(jq -r '.global_stats.cache_hits' "$STATS_FILE")
        local cache_misses=$(jq -r '.global_stats.cache_misses' "$STATS_FILE")

        local hit_rate=0
        if [ "$total_requests" -gt 0 ]; then
            hit_rate=$((cache_hits * 100 / total_requests))
        fi

        echo -e "${BLUE}Global Statistics:${NC}"
        echo -e "  Total Requests: $total_requests"
        echo -e "  Cache Hits: ${GREEN}$cache_hits${NC}"
        echo -e "  Cache Misses: ${YELLOW}$cache_misses${NC}"
        echo -e "  Hit Rate: ${GREEN}${hit_rate}%${NC}"
        echo ""

        echo -e "${BLUE}Category Breakdown:${NC}"
        for cat in board-status explanations code-patterns templates; do
            local cat_requests=$(jq -r ".category_stats[\"$cat\"].requests" "$STATS_FILE")
            local cat_hits=$(jq -r ".category_stats[\"$cat\"].hits" "$STATS_FILE")

            if [ "$cat_requests" -gt 0 ]; then
                local cat_rate=$((cat_hits * 100 / cat_requests))
                echo -e "  $cat: $cat_hits/$cat_requests (${cat_rate}%)"
            fi
        done
    else
        echo -e "${YELLOW}Statistics not available${NC}"
    fi

    echo ""

    # Show cache size
    if [ -f "$INDEX_FILE" ] && command -v jq >/dev/null 2>&1; then
        local total_entries=$(jq -r '.total_entries' "$INDEX_FILE")
        local total_size=$(jq -r '.total_size_bytes' "$INDEX_FILE")
        local size_mb=$((total_size / 1024 / 1024))

        echo -e "${BLUE}Cache Storage:${NC}"
        echo -e "  Total Entries: $total_entries"
        echo -e "  Total Size: ${size_mb}MB"
    fi
}

# Cleanup expired entries
cleanup_cache() {
    echo -e "${YELLOW}🧹 Cleaning up expired cache entries...${NC}"

    local cleaned=0

    for category in board-status explanations code-patterns templates; do
        local cache_dir="$CACHE_DIR/responses/$category"

        if [ -d "$cache_dir" ]; then
            for cache_file in "$cache_dir"/*.cache; do
                [ -f "$cache_file" ] || continue

                local key=$(basename "$cache_file" .cache)
                if [ "$(check_cache "$category" "$key")" = "EXPIRED" ]; then
                    ((cleaned++))
                fi
            done
        fi
    done

    echo -e "${GREEN}✅ Cleaned $cleaned expired entries${NC}"
}

# Main command handler
case "${1:-}" in
    --init)
        init_cache
        echo -e "${GREEN}✅ Cache system initialized${NC}"
        ;;
    --set)
        cache_set "$2" "$3" "$4"
        ;;
    --get)
        cache_get "$2" "$3"
        ;;
    --invalidate)
        cache_invalidate "$2"
        ;;
    --stats)
        show_stats
        ;;
    --cleanup)
        cleanup_cache
        ;;
    --help|*)
        echo "Cache Manager - Response Caching System"
        echo ""
        echo "Usage:"
        echo "  $0 --init                              Initialize cache system"
        echo "  $0 --set <category> <key> <content>    Store content in cache"
        echo "  $0 --get <category> <key>              Retrieve content from cache"
        echo "  $0 --invalidate [category]             Clear cache (all or specific category)"
        echo "  $0 --stats                             Show cache performance statistics"
        echo "  $0 --cleanup                           Remove expired cache entries"
        echo ""
        echo "Categories:"
        echo "  board-status     - Board check results and status reports"
        echo "  explanations     - Framework explanations and documentation"
        echo "  code-patterns    - Reusable code snippets and patterns"
        echo "  templates        - Response templates"
        ;;
esac
