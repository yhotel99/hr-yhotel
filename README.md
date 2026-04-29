<div align="center">
<img width="1200" height="475" alt="Y99 HR Banner" src="https://github.com/user-attachments/assets/0aa67016-6eaf-458a-adb2-6e31a0763ed6" />
</div>

# Y99 HR Connect PWA

Hệ thống quản lý nhân sự 4.0 - Chốt công nhanh, Quản trị hiệu quả. Ứng dụng được xây dựng dưới dạng Progressive Web App (PWA) hỗ trợ làm việc offline và đa nền tảng.

🌐 **Production:** [hr.yhotel.vn](https://hr.yhotel.vn)

## 🚀 Tính năng chính

- **Chấm công GPS:** Check-in/out kèm ảnh chụp, xác thực vị trí văn phòng.
- **Quản lý lịch làm việc:** Đăng ký ca, xin nghỉ phép, phê duyệt trực tuyến.
- **Tính lương tự động:** Theo dõi bảng lương tháng, phụ cấp và các khoản khấu trừ.
- **Offline-first:** Hỗ trợ chấm công ngay cả khi không có mạng.

## 🛠 Công nghệ sử dụng

- **Frontend:** React 19, Vite, TypeScript, Tailwind CSS.
- **Backend/DB:** Supabase (PostgreSQL, Auth, Storage).
- **PWA:** Service Workers, Background Sync.

## 📖 Tài liệu hệ thống

Bạn có thể xem chi tiết tài liệu hệ thống tại:
👉 [**Tài liệu hệ thống Y99 HR**](./docs/SYSTEM_DOCUMENTATION.md)

## 💻 Cài đặt & Chạy ứng dụng

### Yêu cầu:
- Node.js >= 18.0.0

### Các bước:
1. Cài đặt dependencies:
   ```bash
   npm install
   ```
2. Cấu hình biến môi trường trong `.env.local`:
   ```env
   VITE_SUPABASE_URL=https://ekjbzxtodfxssigmvkyi.supabase.co
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   VITE_RESEND_API_KEY=your_resend_api_key
   RESEND_API_KEY=your_resend_api_key
   ```
3. Chạy ứng dụng:
   ```bash
   npm run dev
   ```
4. Build cho production:
   ```bash
   npm run build
   ```

## 🚀 Deployment

Xem hướng dẫn chi tiết tại: [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

### Quick Deploy với Vercel:
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

## 📚 Tài liệu

- [Tài liệu hệ thống](./docs/SYSTEM_DOCUMENTATION.md)
- [Hướng dẫn Deploy](./DEPLOYMENT_GUIDE.md)
- [Deployment Checklist](./DEPLOYMENT_CHECKLIST.md)
- [Ready to Use Guide](./READY_TO_USE.md)

---
Built with ❤️ for Y99 Team.