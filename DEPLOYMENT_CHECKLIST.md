# ✅ Checklist Triển Khai Dự Án HR System

## 🎯 Trạng thái hiện tại

### ✅ Đã hoàn thành:

#### 1. Database Setup
- ✅ Kết nối Supabase thành công
- ✅ 25 migrations đã được push lên remote
- ✅ 12 tables đã được tạo:
  - users, attendance_records, leave_requests
  - shift_registrations, payroll_records, notifications
  - departments, holidays, system_configs
  - otp_codes, branches, allowed_locations
- ✅ RLS (Row Level Security) đã được enable
- ✅ Policies đã được tạo
- ✅ Indexes đã được tạo để tối ưu performance
- ✅ Triggers đã được tạo (auto update timestamps)

#### 2. Environment Variables
- ✅ `.env.local` đã có đầy đủ:
  - VITE_SUPABASE_URL
  - VITE_SUPABASE_ANON_KEY
  - VITE_RESEND_API_KEY (cho email OTP)
  - RESEND_API_KEY

#### 3. Build & Development
- ✅ Build thành công (npm run build)
- ✅ Dev server chạy được (http://localhost:3001)
- ✅ PWA service worker được generate
- ✅ Không có lỗi TypeScript

#### 4. Dữ liệu mẫu
- ✅ Admin user mặc định: `admin@congty.com`
- ✅ 2 chi nhánh mặc định (CN1, CN2)
- ✅ 10 system configs (giờ làm việc, vị trí văn phòng, v.v.)

---

## 🔍 Cần kiểm tra thêm:

### 1. Authentication Flow
- [ ] Đăng nhập bằng OTP qua email
- [ ] Verify OTP code
- [ ] Session persistence
- [ ] Logout

**Test:**
```bash
# Mở browser: http://localhost:3001
# Thử đăng nhập với email: admin@congty.com
# Kiểm tra có nhận được OTP email không
```

### 2. Storage (Upload ảnh chấm công)
- [ ] Bucket "chamcong" đã được tạo
- [ ] Upload ảnh thành công
- [ ] Public access hoạt động
- [ ] RLS policies cho storage

**Test:**
```bash
# Vào Supabase Dashboard > Storage
# Kiểm tra bucket "chamcong" có tồn tại không
# Thử upload ảnh test
```

### 3. Realtime Subscriptions
- [ ] Realtime đã được enable cho các tables
- [ ] Notifications realtime hoạt động
- [ ] Shift updates realtime hoạt động

**Test:**
```bash
# Mở 2 browser tabs
# Tạo notification ở tab 1
# Kiểm tra tab 2 có nhận được realtime update không
```

### 4. Edge Functions (Supabase Functions)
- [ ] `send-otp-email` function hoạt động
- [ ] `send-shift-change-notification` function hoạt động

**Deploy functions:**
```bash
npx supabase functions deploy send-otp-email
npx supabase functions deploy send-shift-change-notification
```

### 5. Mobile PWA Features
- [ ] Install prompt hiển thị
- [ ] Offline mode hoạt động
- [ ] Service worker cache
- [ ] Push notifications (nếu có)

**Test:**
```bash
# Mở Chrome DevTools > Application > Service Workers
# Kiểm tra SW đã register
# Thử offline mode
```

### 6. Permissions & RLS
- [ ] Admin có thể xem tất cả users
- [ ] Employee chỉ xem được data của mình
- [ ] Anonymous users không thể truy cập
- [ ] CRUD operations theo role

**Test:**
```bash
# Đăng nhập với role ADMIN
# Kiểm tra có thể xem/sửa tất cả data
# Đăng nhập với role EMPLOYEE
# Kiểm tra chỉ xem được data của mình
```

---

## 🚀 Các bước tiếp theo:

### 1. Tạo thêm test users
```sql
-- Vào Supabase SQL Editor và chạy:
INSERT INTO users (name, email, role, department, status, contract_type)
VALUES 
  ('Nguyễn Văn A', 'nva@congty.com', 'EMPLOYEE', 'IT', 'ACTIVE', 'OFFICIAL'),
  ('Trần Thị B', 'ttb@congty.com', 'MANAGER', 'HR', 'ACTIVE', 'OFFICIAL'),
  ('Lê Văn C', 'lvc@congty.com', 'EMPLOYEE', 'Sales', 'ACTIVE', 'TRIAL');
```

### 2. Deploy Supabase Edge Functions
```bash
# Deploy OTP email function
npx supabase functions deploy send-otp-email --no-verify-jwt

# Deploy shift notification function
npx supabase functions deploy send-shift-change-notification
```

### 3. Cấu hình Email (Resend)
- Verify domain trong Resend dashboard
- Test gửi email OTP
- Kiểm tra email templates

### 4. Test toàn bộ flows:

#### Flow 1: Chấm công
1. Employee đăng nhập
2. Vào trang Check-in
3. Cho phép location access
4. Chụp ảnh
5. Check-in thành công
6. Kiểm tra ảnh đã upload lên Storage

#### Flow 2: Đăng ký ca
1. Employee đăng nhập
2. Vào trang Shift Register
3. Chọn ngày và ca làm việc
4. Submit đăng ký
5. Admin nhận notification
6. Admin approve/reject

#### Flow 3: Tính lương
1. Admin đăng nhập
2. Vào Payroll Management
3. Chọn tháng
4. Generate payroll
5. Kiểm tra tính toán đúng
6. Export Excel

### 5. Deploy lên Production (Vercel)
```bash
# Cài Vercel CLI
npm i -g vercel

# Deploy
vercel

# Set environment variables trên Vercel Dashboard:
# - VITE_SUPABASE_URL
# - VITE_SUPABASE_ANON_KEY
# - VITE_RESEND_API_KEY
# - RESEND_API_KEY
```

---

## 📝 Notes quan trọng:

### Security
- ⚠️ RLS policies hiện tại cho phép tất cả authenticated users (cần tighten)
- ⚠️ Cần review lại policies theo role (ADMIN, MANAGER, EMPLOYEE)
- ⚠️ Storage bucket "chamcong" đang public (cần review)

### Performance
- ✅ Indexes đã được tạo cho các queries thường dùng
- ✅ Lazy loading cho routes
- ✅ PWA caching

### Monitoring
- [ ] Setup Sentry hoặc error tracking
- [ ] Setup analytics (Google Analytics, Plausible, v.v.)
- [ ] Setup uptime monitoring

---

## 🎉 Kết luận:

**Dự án CÓ THỂ DÙNG ĐƯỢC** nhưng cần:
1. ✅ Database đã sẵn sàng
2. ✅ Build & dev server chạy tốt
3. ⚠️ Cần test authentication flow (OTP email)
4. ⚠️ Cần deploy Edge Functions
5. ⚠️ Cần test các features chính
6. ⚠️ Cần tighten security policies

**Recommended:** Test kỹ trên local trước khi deploy production!
