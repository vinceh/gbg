class AdminsController < ApplicationController

	protect_from_forgery

	before_filter :adminsession, :except => [:admin, :login]

	def admin
		if session[:admin]
			redirect_to :action => :controlpanel
		end
  end

  def login
    #admin = Admin.all.first

    #puts Admin.all.first.to_s + " ADAFIDAISADFSDJIA"
    if params[:admin][:password] == "donburichan"
      session[:admin] = true
      redirect_to :action => :controlpanel
    else
      flash[:error] = "Invalid Login"
      redirect_to :action => :admin
    end
  end

  def logout
    session[:admin] = nil
    redirect_to :action => :admin
  end

  def controlpanel
    @posts = Post.all
  end

  def new_post
    @post = Post.new
  end

  def create_post
    @post = Post.new(params[:post])
    @post.published = true
    @post.save!

    redirect_to :action => :controlpanel
  end

  def edit_post
    @post = Post.find(params[:id])
  end

  def update_post
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])

    redirect_to :action => :controlpanel
  end

  def delete_post
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to :action => :controlpanel
  end
end

