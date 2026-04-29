# ✅ Edge Functions - Cấu hình cho hr.yhotel.vn

## 🎯 Tóm tắt

**TẤT CẢ ĐÃ ĐƯỢC CẤU HÌNH CHO DOMAIN hr.yhotel.vn** ✅

---

## 📊 Functions Status

| Function | Version | Status | Domain Config |
|----------|---------|--------|---------------|
| send-otp-email | v4 | ✅ ACTIVE | ✅ Configured |
| send-shift-change-notification | v3 | ✅ ACTIVE | ✅ Configured |

**Last Updated:** 2026-04-29 09:20 UTC

---

## 🔧 Cấu hình chi tiết

### 1. send-otp-email (v4)

**Email Configuration:**
```typescript
from: 'Y99 HR <noreply@yhotel.vn>'
subject: 'Mã OTP đăng nhập - Y99 HR'
```

**Features:**
- ✅ FROM address: `noreply@yhotel.vn`
- ✅ OTP validation (6 digits)
- ✅ Email format validation
- ✅ CORS enabled
- ✅ Rate limiting protection

**Endpoint:**
```
https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-otp-email
```

---

### 2. send-shift-change-notification (v3)

**Email Configuration:**
```typescript
from: 'Y99 HR <noreply@yhotel.vn>'
subject: '⚠️ Yêu cầu đổi ca đã duyệt - [Employee Name]'
```

**Domain Configuration:**
```typescript
const APP_URL = Deno.env.get('APP_URL') || 'https://hr.yhotel.vn'
// Link trong email: https://hr.yhotel.vn/#/admin/shift
```

**Features:**
- ✅ FROM address: `noreply@yhotel.vn`
- ✅ Link to: `https://hr.yhotel.vn/#/admin/shift`
- ✅ HTML email template (bilingual)
- ✅ Auto-fetch admin list
- ✅ Rate limiting (600ms delay)
- ✅ Batch email sending

**Endpoint:**
```
https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-shift-change-notification
```

---

## 🔐 Environment Variables (Secrets)

### ✅ Đã cấu hình:

```bash
APP_URL=https://hr.yhotel.vn
RESEND_API_KEY=[configured]
SUPABASE_URL=[auto-configured]
SUPABASE_ANON_KEY=[auto-configured]
SUPABASE_SERVICE_ROLE_KEY=[auto-configured]
```

**Verify:**
```bash
npx supabase secrets list
```

---

## 📧 Email Domain Configuration

### Current Setup:

**FROM Address:** `Y99 HR <noreply@yhotel.vn>`

**Domain:** `yhotel.vn`

### ⚠️ Action Required:

**Cần verify domain trong Resend Dashboard:**

1. Vào: https://resend.com/domains
2. Add domain: `yhotel.vn`
3. Thêm DNS records:

```dns
# Verification
Type: TXT
Name: @
Value: [Resend verification code]

# Email sending
Type: MX
Name: @
Value: feedback-smtp.us-east-1.amazonses.com
Priority: 10

# SPF
Type: TXT
Name: @
Value: v=spf1 include:amazonses.com ~all

# DKIM (sẽ được cung cấp sau khi add domain)
Type: TXT
Name: [resend-provided]
Value: [resend-provided]

# DMARC
Type: TXT
Name: _dmarc
Value: v=DMARC1; p=none; rua=mailto:dmarc@yhotel.vn
```

4. Verify domain
5. Test email delivery

**Status hiện tại:**
- ⚠️ Domain chưa verify
- ⚠️ Email sẽ gửi từ Resend sandbox (có thể bị spam filter)
- ✅ Functions đã sẵn sàng, chỉ cần verify domain

---

## 🧪 Testing

### Test send-otp-email:

```bash
curl -X POST \
  'https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-otp-email' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVramJ6eHRvZGZ4c3NpZ212a3lpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc0Mjc0NTQsImV4cCI6MjA5MzAwMzQ1NH0.yN3R6Vs2-zR5AEv1le0TAjttIMMDsYUv2nWQS_1G4RE' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "test@example.com",
    "otpCode": "123456",
    "userName": "Test User"
  }'
```

**Expected Response:**
```json
{
  "success": true,
  "messageId": "xxx-xxx-xxx"
}
```

### Test send-shift-change-notification:

```bash
curl -X POST \
  'https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-shift-change-notification' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVramJ6eHRvZGZ4c3NpZ212a3lpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc0Mjc0NTQsImV4cCI6MjA5MzAwMzQ1NH0.yN3R6Vs2-zR5AEv1le0TAjttIMMDsYUv2nWQS_1G4RE' \
  -H 'Content-Type: application/json' \
  -d '{
    "employeeName": "Nguyễn Văn A",
    "employeeEmail": "nva@example.com",
    "date": "29/04/2026",
    "oldShift": "Ca sáng (8:00-12:00)",
    "newShift": "Ca chiều (13:00-17:00)",
    "reason": "Có việc gia đình"
  }'
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Sent to 2/2 admin(s)",
  "details": [...]
}
```

---

## 📊 Verification Checklist

### ✅ Đã hoàn thành:

- [x] Functions deployed
- [x] FROM address updated to `noreply@yhotel.vn`
- [x] APP_URL set to `https://hr.yhotel.vn`
- [x] Links trong email point to `hr.yhotel.vn`
- [x] RESEND_API_KEY configured
- [x] CORS enabled
- [x] Error handling implemented

### ⚠️ Cần làm:

- [ ] Verify domain `yhotel.vn` trong Resend
- [ ] Test email delivery với email thật
- [ ] Verify links trong email hoạt động
- [ ] Test trên production (sau khi deploy)

---

## 🔍 How to Verify

### 1. Check Function Code:

```bash
# View send-otp-email
cat supabase/functions/send-otp-email/index.ts | grep "from:"

# View send-shift-change-notification
cat supabase/functions/send-shift-change-notification/index.ts | grep "from:"
cat supabase/functions/send-shift-change-notification/index.ts | grep "APP_URL"
```

**Expected Output:**
```typescript
from: 'Y99 HR <noreply@yhotel.vn>'
const APP_URL = Deno.env.get('APP_URL') || 'https://hr.yhotel.vn'
```

### 2. Check Secrets:

```bash
npx supabase secrets list
```

**Expected Output:**
```
APP_URL                   | [hash]
RESEND_API_KEY            | [hash]
```

### 3. Check Function Versions:

```bash
npx supabase functions list
```

**Expected Output:**
```
send-otp-email                 | ACTIVE | 4
send-shift-change-notification | ACTIVE | 3
```

### 4. View Function Logs:

```bash
# Real-time logs
npx supabase functions logs send-otp-email --follow
npx supabase functions logs send-shift-change-notification --follow
```

---

## 🎯 Email Flow

### OTP Email Flow:

```
User enters email
    ↓
Frontend calls send-otp-email function
    ↓
Function generates OTP & saves to DB
    ↓
Function sends email via Resend
    ↓
Email sent from: noreply@yhotel.vn
    ↓
User receives OTP
    ↓
User enters OTP to login
```

### Shift Notification Flow:

```
Employee changes approved shift
    ↓
Database trigger fires
    ↓
Frontend calls send-shift-change-notification
    ↓
Function fetches admin list from DB
    ↓
Function sends email to each admin
    ↓
Email sent from: noreply@yhotel.vn
    ↓
Email contains link: https://hr.yhotel.vn/#/admin/shift
    ↓
Admin clicks link → Opens shift approval page
```

---

## 📞 Support & Troubleshooting

### View Function Logs:

```bash
# Last 100 lines
npx supabase functions logs send-otp-email

# Follow real-time
npx supabase functions logs send-otp-email --follow

# With timestamp
npx supabase functions logs send-otp-email --follow --timestamp
```

### Common Issues:

**Issue 1: Email not received**
```bash
# Check Resend dashboard
https://resend.com/emails

# Check function logs
npx supabase functions logs send-otp-email

# Verify domain status
https://resend.com/domains
```

**Issue 2: Wrong link in email**
```bash
# Check APP_URL secret
npx supabase secrets list

# Should show APP_URL with hash
# If missing, set it:
npx supabase secrets set APP_URL=https://hr.yhotel.vn
```

**Issue 3: Function error**
```bash
# View detailed logs
npx supabase functions logs [function-name] --follow

# Check function status
npx supabase functions list

# Redeploy if needed
npx supabase functions deploy [function-name]
```

---

## 🔄 Update Instructions

### If you need to change domain:

```bash
# 1. Update APP_URL secret
npx supabase secrets set APP_URL=https://new-domain.com

# 2. Update code (if hardcoded)
# Edit: supabase/functions/send-shift-change-notification/index.ts
# Change: const APP_URL = Deno.env.get('APP_URL') || 'https://new-domain.com'

# 3. Redeploy
npx supabase functions deploy send-shift-change-notification
```

### If you need to change email FROM address:

```bash
# 1. Edit both functions
# supabase/functions/send-otp-email/index.ts
# supabase/functions/send-shift-change-notification/index.ts
# Change: from: 'Y99 HR <noreply@new-domain.com>'

# 2. Redeploy both
npx supabase functions deploy send-otp-email --no-verify-jwt
npx supabase functions deploy send-shift-change-notification

# 3. Verify new domain in Resend
https://resend.com/domains
```

---

## ✅ Final Confirmation

**Domain Configuration:** ✅ COMPLETE

- ✅ APP_URL: `https://hr.yhotel.vn`
- ✅ Email FROM: `noreply@yhotel.vn`
- ✅ Links point to: `hr.yhotel.vn`
- ✅ Functions deployed (v4, v3)
- ✅ Secrets configured

**Next Step:** Verify domain `yhotel.vn` trong Resend Dashboard

---

**Status:** ✅ Edge Functions đã được cấu hình hoàn chỉnh cho hr.yhotel.vn  
**Last Updated:** 2026-04-29  
**Functions Version:** send-otp-email v4, send-shift-change-notification v3
