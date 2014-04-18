class SessionsController < ApplicationController
  def index
    @sessions = Session.all
  end

  def new
  end

  def edit
  end

  def show
  end
end
