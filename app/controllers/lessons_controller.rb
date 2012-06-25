class LessonsController < ApplicationController
  # GET /lessons
  def index
    @lessons = Lesson.all
    puts "@{lessons}"
  end

  # GET /lessons/1
  def show
    @lesson = Lesson.find(params[:id])
  end

  # GET /lessons/new
  def new
    return redirect_to :action => :index unless admin?

    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
    return redirect_to :action => :index unless admin?
    
    @lesson = Lesson.find(params[:id])
  end

  # POST /lessons
  def create
    return redirect_to :action => :index unless admin?
    
    @lesson = Lesson.new(params[:lesson])

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to @lesson, notice: 'Lesson was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /lessons/1
  def update
    return redirect_to :action => :index unless admin?
    
    @lesson = Lesson.find(params[:id])

    respond_to do |format|
      if @lesson.update_attributes(params[:lesson])
        format.html { redirect_to @lesson, notice: 'Lesson was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /lessons/1
  def destroy
    return redirect_to :action => :index unless admin?
    
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    
    redirect_to lessons_url
  end
    def caller
        "Classes"
    end
end
