# ✅ Supabase Edge Functions - Status Report

## 📊 Tổng quan

Tất cả Edge Functions đã được deploy và cấu hình cho domain **hr.yhotel.vn**

---

## 🚀 Deployed Functions

### 1. send-otp-email
**Status:** ✅ ACTIVE (Version 3)  
**Purpose:** Gửi mã OTP qua email khi user đăng nhập  
**Endpoint:** `https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-otp-email`

**Features:**
- Gửi OTP 6 chữ số qua email
- Validation email format
- Validation OTP format
- Rate limiting protection
- CORS enabled

**Email Configuration:**
- From: `Y99 HR <noreply@yhotel.vn>`
- Subject: `Mã OTP đăng nhập - Y99 HR`
- Expiry: 5 phút

**Request Example:**
```bash
curl -X POST \
  'https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-otp-email' \
  -H 'Authorization: Bearer YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "user@example.com",
    "otpCode": "123456",
    "userName": "John Doe"
  }'
```

---

### 2. send-shift-change-notification
**Status:** ✅ ACTIVE (Version 2)  
**Purpose:** Gửi email thông báo đến admin khi nhân viên đổi ca đã được duyệt  
**Endpoint:** `https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-shift-change-notification`

**Features:**
- Tự động lấy danh sách admin từ database
- Gửi email đến tất cả admin
- HTML email template đẹp
- Link trực tiếp đến trang duyệt ca
- Rate limiting (600ms delay giữa các email)
- Bilingual (Vietnamese/English)

**Email Configuration:**
- From: `Y99 HR <noreply@yhotel.vn>`
- Subject: `⚠️ Yêu cầu đổi ca đã duyệt - [Employee Name]`
- Link: `https://hr.yhotel.vn/#/admin/shift`

**Request Example:**
```bash
curl -X POST \
  'https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-shift-change-notification' \
  -H 'Authorization: Bearer YOUR_ANON_KEY' \
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

---

## 🔐 Environment Variables (Secrets)

Tất cả secrets đã được cấu hình:

| Secret Name | Status | Purpose |
|------------|--------|---------|
| `RESEND_API_KEY` | ✅ Set | API key để gửi email qua Resend |
| `APP_URL` | ✅ Set | Domain của app (https://hr.yhotel.vn) |
| `SUPABASE_URL` | ✅ Auto | Supabase project URL |
| `SUPABASE_ANON_KEY` | ✅ Auto | Public anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | ✅ Auto | Service role key (admin access) |

**View secrets:**
```bash
npx supabase secrets list
```

**Update secret:**
```bash
npx supabase secrets set SECRET_NAME=value
```

---

## 📧 Email Service (Resend)

### Current Configuration
- Provider: Resend
- API Key: Configured ✅
- From Address: `noreply@yhotel.vn`
- Domain: `yhotel.vn`

### ⚠️ Action Required: Verify Domain

Để email hoạt động trên production, cần verify domain `yhotel.vn` trong Resend:

1. Vào Resend Dashboard: https://resend.com/domains
2. Add domain: `yhotel.vn`
3. Thêm DNS records:

```
Type: TXT
Name: @
Value: [Resend verification code]

Type: MX
Name: @
Value: feedback-smtp.us-east-1.amazonses.com
Priority: 10

Type: TXT
Name: _dmarc
Value: v=DMARC1; p=none; rua=mailto:dmarc@yhotel.vn
```

4. Verify domain
5. Test gửi email

**Current Status:** 
- ⚠️ Domain chưa verify (email sẽ gửi từ Resend sandbox)
- ✅ Functions đã sẵn sàng, chỉ cần verify domain

---

## 🔄 Database Triggers (Webhooks)

Các triggers đã được tạo trong database để tự động gọi functions:

### 1. trigger_shift_status_change
**Table:** `shift_registrations`  
**Event:** AFTER UPDATE  
**Condition:** Status thay đổi từ PENDING → APPROVED/REJECTED  
**Action:** Tạo notification trong database

### 2. trigger_payroll_notification
**Table:** `payroll_records`  
**Event:** AFTER INSERT OR UPDATE  
**Condition:** Payroll mới được tạo hoặc status → PAID  
**Action:** Tạo notification cho employee

### 3. trigger_broadcast_notification
**Table:** `notifications`  
**Event:** AFTER INSERT  
**Condition:** Title chứa `[Broadcast]`  
**Action:** Broadcast notification đến tất cả employees

**View triggers:**
```sql
-- Vào Supabase SQL Editor
SELECT * FROM pg_trigger WHERE tgname LIKE 'trigger_%';
```

---

## 🧪 Testing

### Test OTP Email Function

```bash
# Test với curl
curl -X POST \
  'https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-otp-email' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVramJ6eHRvZGZ4c3NpZ212a3lpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc0Mjc0NTQsImV4cCI6MjA5MzAwMzQ1NH0.yN3R6Vs2-zR5AEv1le0TAjttIMMDsYUv2nWQS_1G4RE' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "your-email@example.com",
    "otpCode": "123456",
    "userName": "Test User"
  }'
```

### Test Shift Notification Function

```bash
curl -X POST \
  'https://ekjbzxtodfxssigmvkyi.supabase.co/functions/v1/send-shift-change-notification' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVramJ6eHRvZGZ4c3NpZ212a3lpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc0Mjc0NTQsImV4cCI6MjA5MzAwMzQ1NH0.yN3R6Vs2-zR5AEv1le0TAjttIMMDsYUv2nWQS_1G4RE' \
  -H 'Content-Type: application/json' \
  -d '{
    "employeeName": "Nguyễn Văn A",
    "employeeEmail": "nva@example.com",
    "date": "29/04/2026",
    "oldShift": "Ca sáng",
    "newShift": "Ca chiều",
    "reason": "Test notification"
  }'
```

### View Function Logs

```bash
# View logs cho send-otp-email
npx supabase functions logs send-otp-email

# View logs cho send-shift-change-notification
npx supabase functions logs send-shift-change-notification

# Follow logs (real-time)
npx supabase functions logs send-otp-email --follow
```

---

## 📊 Monitoring

### Supabase Dashboard
View function metrics tại:
```
https://supabase.com/dashboard/project/ekjbzxtodfxssigmvkyi/functions
```

**Metrics available:**
- Invocations count
- Error rate
- Execution time
- Logs

### Resend Dashboard
View email delivery tại:
```
https://resend.com/emails
```

**Metrics available:**
- Emails sent
- Delivery rate
- Bounce rate
- Open rate (nếu enable tracking)

---

## 🔧 Maintenance

### Redeploy Functions

```bash
# Deploy single function
npx supabase functions deploy send-otp-email --no-verify-jwt
npx supabase functions deploy send-shift-change-notification

# Deploy all functions
npx supabase functions deploy
```

### Update Secrets

```bash
# Update RESEND_API_KEY
npx supabase secrets set RESEND_API_KEY=new_key

# Update APP_URL
npx supabase secrets set APP_URL=https://hr.yhotel.vn
```

### Delete Function (if needed)

```bash
npx supabase functions delete function-name
```

---

## ✅ Checklist

### Deployment
- [x] send-otp-email deployed
- [x] send-shift-change-notification deployed
- [x] RESEND_API_KEY configured
- [x] APP_URL configured
- [x] Email FROM address updated to @yhotel.vn
- [x] Database triggers created

### Testing
- [ ] Test OTP email delivery
- [ ] Test shift notification email
- [ ] Test with real email addresses
- [ ] Verify email formatting
- [ ] Test error handling

### Production Ready
- [ ] Verify domain yhotel.vn in Resend
- [ ] Test email delivery on production
- [ ] Monitor function logs
- [ ] Setup alerts for errors
- [ ] Document for team

---

## 🎯 Next Steps

1. **Verify Email Domain** (Priority: HIGH)
   - Vào Resend Dashboard
   - Verify domain `yhotel.vn`
   - Test email delivery

2. **Test Functions** (Priority: HIGH)
   - Test OTP flow với email thật
   - Test shift notification với admin email
   - Verify links trong email hoạt động

3. **Monitor** (Priority: MEDIUM)
   - Setup alerts cho function errors
   - Monitor email delivery rate
   - Check function execution time

4. **Documentation** (Priority: LOW)
   - Document cho team về cách test
   - Hướng dẫn troubleshooting
   - Update user guide

---

## 📞 Support

### View Function Details
```
https://supabase.com/dashboard/project/ekjbzxtodfxssigmvkyi/functions
```

### View Logs
```bash
npx supabase functions logs [function-name]
```

### Resend Support
```
https://resend.com/support
```

---

**Status:** ✅ All functions deployed and configured for hr.yhotel.vn  
**Last Updated:** 2026-04-29  
**Next Review:** After domain verification
