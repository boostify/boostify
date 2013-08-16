class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
  end

  def show
    redirect_to boostify.charities_path(donatable_id: params[:id])
  end
end
