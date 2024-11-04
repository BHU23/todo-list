class TaskMaiilerMailer < ApplicationMailer
    default from: 'b6419455@g.sut.ac.th'
    # default from: 'ttthisriton29@gmail.com'

    def status_toggle_sent_to_user_email(task)
        @task = task
        mail(to: @task.email, subject: 'Task Status Toggled')
    end
end

  