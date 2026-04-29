import { createClient } from '@supabase/supabase-js'
import { config } from 'dotenv'

config({ path: '.env.local' })

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY

console.log('URL:', supabaseUrl)
console.log('Key:', supabaseKey ? 'Found' : 'Missing')

const supabase = createClient(supabaseUrl, supabaseKey)

async function testConnection() {
  console.log('Testing Supabase connection...\n')
  
  // Test 1: List all tables
  const { data: tables, error: tablesError } = await supabase
    .from('users')
    .select('*')
    .limit(1)
  
  if (tablesError) {
    console.error('❌ Error connecting to users table:', tablesError.message)
  } else {
    console.log('✅ Successfully connected to users table')
    console.log('Sample data:', tables)
  }
  
  // Test 2: Check other tables
  const tablesToCheck = [
    'attendance_records',
    'leave_requests', 
    'shift_registrations',
    'payroll_records',
    'notifications',
    'departments',
    'holidays',
    'system_configs',
    'otp_codes',
    'branches',
    'allowed_locations'
  ]
  
  console.log('\n📋 Checking all tables:')
  for (const table of tablesToCheck) {
    const { error } = await supabase.from(table).select('id').limit(1)
    if (error) {
      console.log(`❌ ${table}: ${error.message}`)
    } else {
      console.log(`✅ ${table}: OK`)
    }
  }
}

testConnection()
