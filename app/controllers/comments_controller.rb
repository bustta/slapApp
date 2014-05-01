class CommentsController < ApplicationController
  before_action :login_required, :only => [:new, :create, :edit,:update,:destroy]

  def index
    @topic = Topic.find(params[:topic_id])
    @comments = @topic.comments
  end
  # def show
  #   @topic = Topics.find(params[:topic_id])
  #   @comments = @topic.comments

  # end
  def new
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.build
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.new(comment_params)

    if @comment.save
      redirect_to topic_path(@topic)
    else
      render :new

    end
  end

  def edit
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.find(params[:id])

  end

  def update
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.find(params[:id])

    if @comment.update(comment_params)
      redirect_to topic_path(@topic)
    else
      render :edit

    end


  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.find(params[:id])

    @comment.destroy

    redirect_to topic_path(@topic)

  end



  private
  def comment_params
    params.require(:comment).permit(:content)

  end
end
