json.extract! task, :id, :title, :description, :completed, :position, :todo_time, :created_at, :updated_at
json.url task_url(task, format: :json)
bjhij