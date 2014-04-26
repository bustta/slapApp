class CommentsController < ApplicationController
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



  private
  def comment_params
    params.require(:comment).permit(:content)

  end
end
