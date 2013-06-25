class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
  end

  def show
    session[:donatable_id] = params[:id]
    redirect_to boostify.charities_path
  end
end
