class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    @posts = Post.order('created_at desc').all
  end
end
