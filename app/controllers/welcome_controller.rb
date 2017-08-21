class WelcomeController < ApplicationController
  def index
    flash[:notice] ="good guy~"
  end 
end
