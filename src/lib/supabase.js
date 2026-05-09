import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://poehocswxxylwqvyeujj.supabase.co'
const supabaseAnonKey =
  import.meta.env.VITE_SUPABASE_ANON_KEY ||
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvZWhvY3N3eHh5bHdxdnlldWpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzODE5NDUsImV4cCI6MjA5MDk1Nzk0NX0.AIUm3Wq9U8L1gFjeMU0f-H7qwjiGqcefQ_RRJzT1EdE'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)