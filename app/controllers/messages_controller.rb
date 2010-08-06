class MessagesController < ApplicationController
  before_filter :current_convo

  def index
    @messages = @convo.messages
  end

  def new
  end

  def create
    @message = Message.new(:convo => @convo, :user => current_user, :body => params[:message], :uuid =>  params[:uuid])
    respond_to do |format|
      format.js do
        if @message.save
          Pusher["convos-#{@convo.id}"].trigger('message-create', { :message => params[:message], :uuid => params[:uuid] })
        end
        render :nothing => true
      end
    end
  end


  def show
  end


private

  def current_convo
    @convo = Convo.criteria.id(params[:convo_id])[0]
  end

end
