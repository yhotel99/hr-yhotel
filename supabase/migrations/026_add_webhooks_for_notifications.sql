-- Migration: Add Database Webhooks for Notifications
-- Tạo function để gửi webhook khi có shift registration mới hoặc thay đổi

-- Function để gửi webhook khi shift registration được approve/reject
CREATE OR REPLACE FUNCTION notify_shift_status_change()
RETURNS TRIGGER AS $$
DECLARE
  user_email TEXT;
  user_name TEXT;
  webhook_url TEXT;
BEGIN
  -- Chỉ trigger khi status thay đổi từ PENDING sang APPROVED hoặc REJECTED
  IF (TG_OP = 'UPDATE' AND OLD.status = 'PENDING' AND NEW.status IN ('APPROVED', 'REJECTED')) THEN
    -- Lấy thông tin user
    SELECT email, name INTO user_email, user_name
    FROM users
    WHERE id = NEW.user_id;
    
    -- Webhook URL - có thể lấy từ system_configs hoặc hardcode
    webhook_url := 'https://hr.yhotel.vn/api/webhooks/shift-notification';
    
    -- Gọi Edge Function để gửi notification
    -- Note: Supabase không hỗ trợ HTTP request trực tiếp từ trigger
    -- Thay vào đó, ta sẽ insert vào notifications table
    -- và dùng Supabase Realtime hoặc Edge Function để xử lý
    
    INSERT INTO notifications (
      user_id,
      title,
      message,
      type,
      timestamp,
      read
    ) VALUES (
      NEW.user_id,
      CASE 
        WHEN NEW.status = 'APPROVED' THEN 'Đăng ký ca được chấp nhận'
        WHEN NEW.status = 'REJECTED' THEN 'Đăng ký ca bị từ chối'
      END,
      CASE 
        WHEN NEW.status = 'APPROVED' THEN 
          'Đăng ký ca làm việc ngày ' || to_char(to_timestamp(NEW.date / 1000), 'DD/MM/YYYY') || ' đã được chấp nhận.'
        WHEN NEW.status = 'REJECTED' THEN 
          'Đăng ký ca làm việc ngày ' || to_char(to_timestamp(NEW.date / 1000), 'DD/MM/YYYY') || ' đã bị từ chối.' ||
          CASE WHEN NEW.rejection_reason IS NOT NULL THEN ' Lý do: ' || NEW.rejection_reason ELSE '' END
      END,
      CASE 
        WHEN NEW.status = 'APPROVED' THEN 'success'
        WHEN NEW.status = 'REJECTED' THEN 'error'
      END,
      EXTRACT(EPOCH FROM NOW())::BIGINT * 1000,
      false
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger cho shift_registrations
DROP TRIGGER IF EXISTS trigger_shift_status_change ON shift_registrations;
CREATE TRIGGER trigger_shift_status_change
  AFTER UPDATE ON shift_registrations
  FOR EACH ROW
  EXECUTE FUNCTION notify_shift_status_change();

-- Function để gửi notification khi có payroll mới
CREATE OR REPLACE FUNCTION notify_payroll_created()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND OLD.status = 'PENDING' AND NEW.status = 'PAID')) THEN
    INSERT INTO notifications (
      user_id,
      title,
      message,
      type,
      timestamp,
      read
    ) VALUES (
      NEW.user_id,
      CASE 
        WHEN TG_OP = 'INSERT' THEN 'Bảng lương mới'
        WHEN NEW.status = 'PAID' THEN 'Lương đã được thanh toán'
      END,
      CASE 
        WHEN TG_OP = 'INSERT' THEN 
          'Bảng lương tháng ' || NEW.month || ' đã được tạo. Lương thực nhận: ' || 
          TO_CHAR(NEW.net_salary, 'FM999,999,999') || ' VNĐ'
        WHEN NEW.status = 'PAID' THEN 
          'Lương tháng ' || NEW.month || ' đã được thanh toán: ' || 
          TO_CHAR(NEW.net_salary, 'FM999,999,999') || ' VNĐ'
      END,
      'info',
      EXTRACT(EPOCH FROM NOW())::BIGINT * 1000,
      false
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger cho payroll_records
DROP TRIGGER IF EXISTS trigger_payroll_notification ON payroll_records;
CREATE TRIGGER trigger_payroll_notification
  AFTER INSERT OR UPDATE ON payroll_records
  FOR EACH ROW
  EXECUTE FUNCTION notify_payroll_created();

-- Function để gửi notification khi admin tạo thông báo broadcast
CREATE OR REPLACE FUNCTION broadcast_admin_notification()
RETURNS TRIGGER AS $$
DECLARE
  employee_record RECORD;
BEGIN
  -- Chỉ broadcast nếu notification được tạo bởi admin và không có user_id cụ thể
  -- (user_id = admin user id và message chứa keyword broadcast)
  IF (TG_OP = 'INSERT' AND NEW.title LIKE '%[Broadcast]%') THEN
    -- Tạo notification cho tất cả employees (trừ admin)
    FOR employee_record IN 
      SELECT id FROM users WHERE role IN ('EMPLOYEE', 'MANAGER') AND status = 'ACTIVE'
    LOOP
      INSERT INTO notifications (
        user_id,
        title,
        message,
        type,
        timestamp,
        read
      ) VALUES (
        employee_record.id,
        REPLACE(NEW.title, '[Broadcast]', ''),
        NEW.message,
        NEW.type,
        NEW.timestamp,
        false
      );
    END LOOP;
    
    -- Xóa notification gốc (đã broadcast)
    DELETE FROM notifications WHERE id = NEW.id;
    RETURN NULL;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger cho broadcast notifications
DROP TRIGGER IF EXISTS trigger_broadcast_notification ON notifications;
CREATE TRIGGER trigger_broadcast_notification
  AFTER INSERT ON notifications
  FOR EACH ROW
  EXECUTE FUNCTION broadcast_admin_notification();

-- Comment
COMMENT ON FUNCTION notify_shift_status_change() IS 'Tự động tạo notification khi shift registration được approve/reject';
COMMENT ON FUNCTION notify_payroll_created() IS 'Tự động tạo notification khi có payroll mới hoặc được thanh toán';
COMMENT ON FUNCTION broadcast_admin_notification() IS 'Broadcast notification từ admin đến tất cả employees';
