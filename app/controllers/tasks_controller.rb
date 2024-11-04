class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy toggle ]

  # GET /tasks or /tasks.json
  def index
    @task = Task.new
    @tasks = case params[:filter]
             when 'completed'
               Task.where(completed: true)
             when 'uncompleted'
               Task.where(completed: false)
             else
               Task.all
             end

    respond_to do |format|
      format.html # This renders the normal HTML page
      format.turbo_stream # This will respond with a Turbo Stream update
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.completed = false
  
    if @task.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end  
  

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle
    @task = Task.find(params[:id])
    @task.update(completed: !@task.completed)
    @tasks = case params[:filter]
              when 'completed'
                Task.where(completed: true)
              when 'uncompleted'
                Task.where(completed: false)
              else
                Task.all
              end

    TaskMaiilerMailer.status_toggle_sent_to_user_email(@task).deliver_later
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tasks_path(filter: params[:filter]), notice: 'Task updated successfully.' }
    end
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :email, :completed, :position, :todo_time)
    end
end
