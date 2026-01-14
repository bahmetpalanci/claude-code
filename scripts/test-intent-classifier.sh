#!/bin/bash

# Intent Classifier Test Script
# Tests the intent classification agent with various prompts

set -euo pipefail

AGENT_CONFIG="/Users/bap/.claude/agents/intent-classifier.yaml"
TEST_RESULTS_DIR="/Users/bap/.claude/test-results"

mkdir -p "$TEST_RESULTS_DIR"

echo "🧪 Intent Classifier Agent Test Suite"
echo "======================================"
echo ""

# Test cases - Generic scenarios across different domains
declare -a TEST_PROMPTS=(
    "E-commerce: Product listing page shows 'out_of_stock' column missing error"
    "SaaS Dashboard: Login page console showing authentication token errors"
    "Banking API: Analyze the TransactionValidator class implementation"
    "Enterprise App: Analyze project architecture, understand microservices structure"
    "Healthcare Portal: Add two-factor authentication for patient records"
    "Open Source Library: How to use OAuth2 authentication framework?"
    "API Testing: Increase test coverage for REST endpoints"
    "Legacy System: Refactor and improve code quality in payment module"
)

# Test each prompt
for i in "${!TEST_PROMPTS[@]}"; do
    PROMPT="${TEST_PROMPTS[$i]}"
    TEST_NUM=$((i + 1))
    OUTPUT_FILE="$TEST_RESULTS_DIR/test-$TEST_NUM.json"

    echo "Test $TEST_NUM: \"$PROMPT\""
    echo "----------------------------------------"

    # Note: This is a conceptual test - actual claude-flow integration
    # would happen via MCP. For now, we document expected output.

    cat > "$OUTPUT_FILE" <<EOF
{
  "test_id": $TEST_NUM,
  "prompt": "$PROMPT",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "pending",
  "expected_analysis": {
    "note": "Manual verification needed - compare against CLAUDE.md Decision Tree"
  }
}
EOF

    echo "✓ Test case saved to $OUTPUT_FILE"
    echo ""
done

echo "======================================"
echo "✅ Test suite prepared"
echo "📁 Results directory: $TEST_RESULTS_DIR"
echo ""
echo "Next steps:"
echo "1. Integrate with claude-flow MCP"
echo "2. Run actual agent spawn + classification"
echo "3. Compare outputs against Decision Tree"
echo "4. Measure accuracy metrics"
