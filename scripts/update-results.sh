#!/bin/bash

set -e

echo "Extracting test history from results.json..."

testHistory=$(jq '[.testResults[0].assertionResults[] | {testName: .title, testStatus: .status}]' results.json)

echo "Formatted Test History: $testHistory"

resultSummary=$(jq -n --argjson history "$testHistory" '{ result_summary: $history }')

echo "Payload to PATCH: $resultSummary"

curl -X PATCH "$SUPABASE_URL/rest/v1/candidate_assessment?id=eq.${ASSESSMENT_ID}" \
  -H "apikey: $SUPABASE_API_KEY" \
  -H "Authorization: Bearer $SUPABASE_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d "$resultSummary"
