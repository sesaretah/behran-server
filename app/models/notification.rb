class Notification < ApplicationRecord
    belongs_to :notifiable, :polymorphic => true
    #belongs_to :user
    after_create :notify_by_mail
    after_create :notify_by_fcm

    def self.seen_list(notifications)
        for notification in notifications
            notification.seen = true
            notification.save
        end
        return true
    end

    def notify_by_mail
        for target_user_id in self.target_user_ids
            NotificationsMailer.notify_email(target_user_id, self.notification_type, self.user.profile.fullname, self.notifiable.title, self.custom_text).deliver_later
        end
    end

    def notify_by_fcm
        for target_user_id in self.target_user_ids
            target_user = User.find_by_id(target_user_id)
            token = target_user.devices.last.token if target_user && target_user.devices && target_user.devices.last
            FcmJob.perform_later(self.notifiable.title, self.custom_text,token) if token
        end
    end

    def user
        User.find_by_id(self.source_user_id) if self.source_user_id
    end
end
