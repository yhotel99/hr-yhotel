#!/bin/bash

echo "🔍 Verifying Edge Functions Configuration for hr.yhotel.vn"
echo "============================================================"
echo ""

echo "1️⃣ Checking Functions Status..."
npx supabase functions list
echo ""

echo "2️⃣ Checking Secrets..."
npx supabase secrets list
echo ""

echo "3️⃣ Checking FROM address in send-otp-email..."
grep -n "from:" supabase/functions/send-otp-email/index.ts | grep "yhotel"
echo ""

echo "4️⃣ Checking FROM address in send-shift-change-notification..."
grep -n "from:" supabase/functions/send-shift-change-notification/index.ts | grep "yhotel"
echo ""

echo "5️⃣ Checking APP_URL in send-shift-change-notification..."
grep -n "APP_URL" supabase/functions/send-shift-change-notification/index.ts | head -1
echo ""

echo "✅ Verification Complete!"
echo ""
echo "Expected Results:"
echo "- Functions: send-otp-email (v4), send-shift-change-notification (v3)"
echo "- Secrets: APP_URL, RESEND_API_KEY should be present"
echo "- FROM: noreply@yhotel.vn"
echo "- APP_URL: https://hr.yhotel.vn"
echo ""
echo "⚠️  Next Step: Verify domain 'yhotel.vn' in Resend Dashboard"
echo "   https://resend.com/domains"
