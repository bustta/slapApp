class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :login_required, :only => [:new, :create, :edit,:update,:destroy]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
    @topics_json = turn_topics_to_timeline_json(@topics)
    respond_to do |format|
      format.html
      format.json { render :json => @topics_json } #debug use
    end

  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = Topic.find(params[:id])
    @comments = @topic.comments
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit

    #@topic = current_user.topics.find(params[:id])
    @topic = Topic.find(params[:id])
    if @topic.owner != current_user
      flash[:notice] = "You are not OWNER. No Permission!"
      redirect_to root_path
    end

  end

  # POST /topics
  # POST /topics.json
  def create
    #@topic = Topic.new(topic_params)
    @topic = current_user.topics.build(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @topic }
      else
        format.html { render action: 'new' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update

    # @topic = current_user.topics.find(topic_params)
    @topic = current_user.topics.find(params[:id])
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
#    @topic = current_user.topics.find(params[:id])
    @topic = Topic.find(params[:id])

    if @topic.owner != current_user
      flash[:notice] = "You are not OWNER. No Permission!"
      redirect_to topics_path
    else
      @topic.destroy
      respond_to do |format|
        format.html { redirect_to topics_url }
        format.json { head :no_content }
      end
    end




  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :description, :user_id)
    end

    def turn_topics_to_timeline_json(topics)
      topics_json = topics.map do |topic|
        {
          :title => topic.title,
          :date => topic.created_at.to_formatted_s(:timelineDate),
          :displaydate => topic.created_at.to_formatted_s(:timelineDispDate),
          :body => topic.description,
          :user_id => topic.user_id,
          :readmoreurl => topic_path(topic)

  #         {
  #   "title": "This timeline uses JSON data directly",
  #   "date": "27 Mar 2008",
  #   "displaydate": "Mar 27",
  #   "photourl": "http://placekitten.com/600/400",
  #   "caption": "Mike Baird",
  #   "body": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu",
  #   "readmoreurl": "http://www.flickr.com/photos/mikebaird/2529507825/"
  # }
        }
      end
      topics_json.to_json
    end


end
