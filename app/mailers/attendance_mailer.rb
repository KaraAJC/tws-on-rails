class AttendanceMailer < ActionMailer::Base
  def registration(attendance_id)
    @attendance = Attendance.find(attendance_id)
    @tea_time = attendance.tea_time
    @user = attendance.user

    mail.attachments['event.ics'] = {mime_type: "text/calendar", 
                                     content: @tea_time.ical.to_ical}

    mail(to: attendance.user.email, 
         from: @tea_time.host.friendly_email,
         subject: "See you at tea time!",
         reply_to: @tea_time.host.email).deliver!
  end

  def reminder(attendance_id, type)
    @attendance = Attendance.find(attendance_id)
    @user = @attendance.user
    @type = type
    tt = @attendance.tea_time
    
    mail.attachments['event.ics'] = {mime_type: "text/calendar", 
                                     content: @attendance.tea_time.ical.to_ical}

    # We shouldn't send a reminder for a flake
    if @attendance.pending?
      mail(to: @user.email, 
           from: tt.host.friendly_email,
           subject: "See you at tea time soon!", 
           reply_to: tt.host.email).deliver!
    end
  end

  def flake(attendance_id)
    attendance = Attendance.find(attendance_id)
    @user = attendance.user
    @tea_time = attendance.tea_time
    mail(to: @user.email, 
         from: @tea_time.host.friendly_email,
         reply_to: @tea_time.host.email,
         subject: "Let's find another tea time that works!").deliver!
  end
end
