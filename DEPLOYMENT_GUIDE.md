# 🚀 Hướng dẫn Deploy lên hr.yhotel.vn

## 📋 Tổng quan

Dự án sẽ được deploy lên domain: **hr.yhotel.vn** sử dụng Vercel.

---

## ✅ Đã hoàn thành

### 1. Database & Backend
- ✅ 26 migrations đã được push lên Supabase
- ✅ Database triggers/webhooks đã được cấu hình:
  - Tự động gửi notification khi shift được approve/reject
  - Tự động gửi notification khi có payroll mới
  - Broadcast notifications từ admin đến tất cả employees
- ✅ Edge Functions đã deploy:
  - `send-otp-email` - Gửi OTP qua email
  - `send-shift-change-notification` - Thông báo thay đổi ca
- ✅ Realtime subscriptions đã enable

### 2. Frontend
- ✅ Build thành công
- ✅ PWA service worker
- ✅ Offline support
- ✅ Mobile responsive

---

## 🚀 Các bước Deploy

### Bước 1: Cài đặt Vercel CLI

```bash
npm install -g vercel
```

### Bước 2: Login vào Vercel

```bash
vercel login
```

### Bước 3: Deploy dự án

```bash
# Deploy lần đầu (sẽ tạo project mới)
vercel

# Hoặc deploy trực tiếp lên production
vercel --prod
```

### Bước 4: Cấu hình Domain

1. Vào Vercel Dashboard: https://vercel.com/dashboard
2. Chọn project vừa deploy
3. Vào **Settings** → **Domains**
4. Add domain: `hr.yhotel.vn`
5. Cấu hình DNS records:

```
Type: CNAME
Name: hr
Value: cname.vercel-dns.com
```

### Bước 5: Set Environment Variables

Vào **Settings** → **Environment Variables** và thêm:

```env
VITE_SUPABASE_URL=https://ekjbzxtodfxssigmvkyi.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVramJ6eHRvZGZ4c3NpZ212a3lpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc0Mjc0NTQsImV4cCI6MjA5MzAwMzQ1NH0.yN3R6Vs2-zR5AEv1le0TAjttIMMDsYUv2nWQS_1G4RE
VITE_RESEND_API_KEY=re_4EWrmr9B_8N48wgfgVePFqy5sBKMqJXCe
RESEND_API_KEY=re_eeU847iS_C1h9vq8unhBeK9oBkwVexr4v
```

**Lưu ý:** Set cho cả 3 environments:
- Production
- Preview
- Development

### Bước 6: Redeploy

```bash
vercel --prod
```

---

## 🔧 Cấu hình Supabase cho Production

### 1. Thêm Domain vào Allowed URLs

Vào Supabase Dashboard → **Authentication** → **URL Configuration**:

```
Site URL: https://hr.yhotel.vn
Redirect URLs:
  - https://hr.yhotel.vn
  - https://hr.yhotel.vn/**
```

### 2. Cấu hình CORS

Vào **Settings** → **API** → **CORS**:

```
Allowed Origins:
  - https://hr.yhotel.vn
  - http://localhost:3001 (cho development)
```

### 3. Update Edge Function URLs (nếu cần)

Nếu Edge Functions cần gọi về domain chính:

```typescript
// Trong supabase/functions/send-shift-change-notification/index.ts
const FRONTEND_URL = 'https://hr.yhotel.vn';
```

---

## 📧 Cấu hình Email (Resend)

### 1. Verify Domain

Vào Resend Dashboard → **Domains** → **Add Domain**:

```
Domain: yhotel.vn
```

Thêm DNS records:

```
Type: TXT
Name: @
Value: [Resend verification code]

Type: MX
Name: @
Value: feedback-smtp.us-east-1.amazonses.com
Priority: 10
```

### 2. Update FROM Address

Sau khi verify domain, update Edge Function:

```typescript
// supabase/functions/send-otp-email/index.ts
from: 'Y99 HR <noreply@yhotel.vn>'
```

Redeploy function:

```bash
npx supabase functions deploy send-otp-email --no-verify-jwt
```

---

## 🔐 Security Checklist

### 1. Review RLS Policies

```sql
-- Vào Supabase SQL Editor và review policies
-- Đảm bảo employees chỉ xem được data của mình
-- Chỉ admin/manager mới có full access
```

### 2. Enable MFA cho Admin

Vào Supabase Dashboard → **Authentication** → **Providers** → Enable MFA

### 3. Rate Limiting

Vercel tự động có rate limiting, nhưng có thể config thêm:

```json
// vercel.json
{
  "functions": {
    "api/**/*.ts": {
      "maxDuration": 10
    }
  }
}
```

### 4. Environment Variables

- ✅ Không commit `.env.local` vào git
- ✅ Dùng Vercel Environment Variables
- ✅ Rotate API keys định kỳ

---

## 📊 Monitoring & Analytics

### 1. Vercel Analytics

Enable trong Vercel Dashboard → **Analytics**

### 2. Supabase Monitoring

Vào Supabase Dashboard → **Reports** để xem:
- Database performance
- API usage
- Storage usage
- Edge Function logs

### 3. Error Tracking (Optional)

Cài đặt Sentry:

```bash
npm install @sentry/react @sentry/vite-plugin
```

```typescript
// src/main.tsx
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: "YOUR_SENTRY_DSN",
  environment: "production",
});
```

---

## 🧪 Testing trước khi Go Live

### 1. Test trên Vercel Preview

Mỗi commit sẽ tạo preview URL, test kỹ trước khi merge vào main:

```bash
# Deploy preview
vercel

# Test preview URL
# https://hr-yhotel-[random].vercel.app
```

### 2. Test Checklist

- [ ] Đăng nhập với OTP
- [ ] Chấm công (upload ảnh)
- [ ] Đăng ký ca làm việc
- [ ] Admin approve/reject shift
- [ ] Nhận notification realtime
- [ ] Tính lương
- [ ] Export Excel
- [ ] PWA install
- [ ] Offline mode
- [ ] Mobile responsive

### 3. Load Testing (Optional)

```bash
# Cài k6
brew install k6  # macOS
choco install k6  # Windows

# Chạy load test
k6 run load-test.js
```

---

## 🔄 CI/CD Setup (Optional)

### GitHub Actions

Tạo `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Install Vercel CLI
        run: npm install -g vercel
      
      - name: Deploy to Vercel
        run: vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}
```

---

## 📱 PWA Configuration

### 1. Update manifest.json

```json
{
  "name": "Y99 HR - YHotel",
  "short_name": "Y99 HR",
  "start_url": "https://hr.yhotel.vn",
  "scope": "https://hr.yhotel.vn/",
  "display": "standalone",
  "theme_color": "#4CAF50",
  "background_color": "#ffffff"
}
```

### 2. Update Service Worker

```javascript
// public/sw.js
const CACHE_NAME = 'y99-hr-v1';
const OFFLINE_URL = 'https://hr.yhotel.vn/offline.html';
```

---

## 🎯 Post-Deployment

### 1. Thông báo cho Users

- Gửi email thông báo hệ thống mới
- Hướng dẫn cài đặt PWA
- Hướng dẫn sử dụng cơ bản

### 2. Training

- Đào tạo admin sử dụng hệ thống
- Đào tạo employees chấm công
- Tài liệu hướng dẫn

### 3. Support

- Setup support channel (email, chat)
- Monitor errors trong 1-2 tuần đầu
- Thu thập feedback từ users

---

## 🔧 Troubleshooting

### Lỗi: "Failed to fetch"

```bash
# Kiểm tra CORS settings trong Supabase
# Kiểm tra environment variables
# Kiểm tra network tab trong DevTools
```

### Lỗi: "OTP not received"

```bash
# Kiểm tra Resend dashboard → Emails
# Kiểm tra spam folder
# Kiểm tra Edge Function logs
npx supabase functions logs send-otp-email
```

### Lỗi: "Image upload failed"

```bash
# Kiểm tra Storage bucket permissions
# Kiểm tra file size limits
# Kiểm tra RLS policies
```

---

## 📞 Support Resources

### Vercel
- Dashboard: https://vercel.com/dashboard
- Docs: https://vercel.com/docs
- Support: https://vercel.com/support

### Supabase
- Dashboard: https://supabase.com/dashboard/project/ekjbzxtodfxssigmvkyi
- Docs: https://supabase.com/docs
- Discord: https://discord.supabase.com

### Resend
- Dashboard: https://resend.com/emails
- Docs: https://resend.com/docs
- Support: support@resend.com

---

## ✅ Deployment Checklist

- [ ] Vercel project created
- [ ] Domain `hr.yhotel.vn` configured
- [ ] DNS records updated
- [ ] Environment variables set
- [ ] Supabase URLs updated
- [ ] Email domain verified
- [ ] RLS policies reviewed
- [ ] All features tested
- [ ] PWA working
- [ ] Mobile responsive
- [ ] Error tracking setup
- [ ] Monitoring enabled
- [ ] Users notified
- [ ] Documentation ready

---

## 🎉 Go Live!

Sau khi hoàn thành tất cả checklist:

```bash
# Final deployment
vercel --prod

# Verify
curl https://hr.yhotel.vn
```

**Chúc mừng! Hệ thống đã sẵn sàng! 🚀**
