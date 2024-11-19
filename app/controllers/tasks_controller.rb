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
      format.html 
      format.turbo_stream 
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    respond_to do |format|
      format.html 
      format.turbo_stream 
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.completed = false
  
    if @task.save
      flash[:notice] = "Task was successfully created."
      flash[:status] = "success"
  
      respond_to do |format|
        format.turbo_stream 
        format.html { redirect_to tasks_path, notice: "Task was successfully created."  }
        format.json { render :show, status: :created, location: @task }
      end
    else
      flash[:notice] = "There was an error creating the task."
      flash[:status] = "error"
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end  
  

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:notice] = "Task was successfully updated."
      flash[:status] = "success"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tasks_path, notice: flash[:notice] }
        format.json { render :show, status: :ok, location: @task }
      end
    else
      flash[:notice] = "There was an error updating the task."
      flash[:status] = "error"
      respond_to do |format|
        format.turbo_stream
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!
    if @task.destroy
      flash[:notice] = "Task was successfully deleted."
      flash[:status] = "success"
    else
      flash[:notice] = "There was an error deleting the task."
      flash[:status] = "error"
    end
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @tasks_path, status: :see_other, notice: flash[:notice] }
      format.json { head :no_content }
    end
  end

  def toggle
    @task = Task.find(params[:id])
    
    # Toggle the task's completion status
    if @task.update(completed: !@task.completed)
      flash[:notice] = "Task updated successfully."
      flash[:status] = "success"
      
      if @task.completed?
        TaskMaiilerMailer.status_toggle_sent_to_user_email(Task.first).deliver_later
      end
    else
      flash[:notice] = "There was an error updating the task."
      flash[:status] = "error"
    end
  
    # Fetch tasks based on the current filter
    @tasks = case params[:filter]
              when 'completed'
                Task.where(completed: true)
              when 'uncompleted'
                Task.where(completed: false)
              else
                Task.all
              end
  
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tasks_path(filter: params[:filter]), notice: flash[:notice] }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :email, :completed, :position, :todo_time, :content)
    end
end
