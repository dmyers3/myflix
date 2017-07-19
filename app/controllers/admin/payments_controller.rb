class Admin::PaymentsController < AdminsController
  def index
    @payments = Payment.recent
  end
end