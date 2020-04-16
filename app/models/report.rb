class Report < ApplicationRecord
    belongs_to :task, optional: true
    belongs_to :work, optional: true
    belongs_to :user

    after_create :notify_by_mail

    def notify_by_mail
        if !self.work_id.blank?
            Notification.create(notifiable_id: self.work.id, notifiable_type: 'Work', notification_type: 'Report', source_user_id: self.user_id, target_user_ids: self.owners , seen: false)
        else 
            Notification.create(notifiable_id: self.task.id, notifiable_type: 'Task', notification_type: 'Report', source_user_id: self.user_id, target_user_ids: self.owners , seen: false)
        end
    end

    def owners
        if !self.work_id.blank?
            self.work.owners
        else 
            self.task.owners
        end
    end

    def profile
        self.user.profile if self.user
    end

    def uploads
        Upload.where(uuid: self.uuid)
    end

    def self.reports_since(user, obj)
        flag = false
        last_visit = Visit.where(visitable_type: obj.class.name, user_id: user.id, visitable_id: obj.id).order('created_at DESC').first
        last_report = self.where(task_id: obj.id).order('updated_at DESC').first if  obj.class.name == 'Task'
        last_report = self.where(work_id: obj.id).order('updated_at DESC').first if  obj.class.name == 'Work'
        if !last_visit.blank? && !last_report.blank?
           if last_visit.created_at < last_report.updated_at
             flag = true
           end
        end
        if last_visit.blank? && !last_report.blank?
            flag = true
        end
        return flag
    end
end