#!/bin/bash

node <<'EOF'
const { createClient } = require('@supabase/supabase-js');
const { execSync } = require('child_process');

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

(async () => {
  const { data, error } = await supabase
    .from('assessments')           
    .select('*')                
    .eq('id', '1db1d95a-2600-4311-be3a-b5dcef26fb78');
  if (error) {
    console.error('Supabase error:', error);
    process.exit(1);
  }
  if (!data || data.length === 0) {
    console.error('No rows returned from Supabase.');
    process.exit(1);
  }

  const url = data[0]?.hidden_test_cases_link;
  if (!url) {
    console.error('No S3 URL found in record.');
    process.exit(1);
  }

  execSync(`curl -f -o tests/test-case-private.test.js "${url}"`, { stdio: 'inherit' });
})();
EOF
