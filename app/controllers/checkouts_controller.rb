class CheckoutsController < ApplicationController
  TRANSACTION_SUCCESS_STATUSES = [
  Braintree::Transaction::Status::Authorizing,
  Braintree::Transaction::Status::Authorized,
  Braintree::Transaction::Status::Settled,
  Braintree::Transaction::Status::SettlementConfirmed,
  Braintree::Transaction::Status::SettlementPending,
  Braintree::Transaction::Status::Settling,
  Braintree::Transaction::Status::SubmittedForSettlement,
]

def new
  @customer = Customer.new
  @client_token = Braintree::ClientToken.generate
end

def show
  @transaction = Braintree::Transaction.find(params[:id])
  @result = _create_result_hash(@transaction)
end

def create
  amount = params["amount"] ||= 100
  nonce = params["payment_method_nonce"]
  result = Braintree::Transaction.sale(
    amount: amount,
    payment_method_nonce: nonce,
    customer: {
      first_name: customer_params[:first_name],
      last_name: customer_params[:last_name],
      email: customer_params[:email],
      phone: customer_params[:phone]
    },
    options: {
      store_in_vault: true
    }
  )

  if result.success? || result.transaction
    #  create our customer user
    @customer = Customer.create customer_params
    @customer.save
    redirect_to checkout_path(result.transaction.id)
  else
    error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
    flash[:error] = error_messages
    redirect_to new_checkout_path
  end
end

def _create_result_hash(transaction)
  status = transaction.status

  if TRANSACTION_SUCCESS_STATUSES.include? status
    result_hash = {
      :header => "Success!",
      :icon => "success",
      :message => "Your test transaction has been successfully processed. See the Braintree API response and try again."
    }
  else
    result_hash = {
      :header => "Transaction Failed",
      :icon => "fail",
      :message => "Your test transaction has a status of #{status}. See the Braintree API response and try again."
    }
  end
end

private

def customer_params
  params.require(:customer).permit(:first_name, :last_name, :address_1, :address_2, :city, :state, :zipcode, :email, :phone)
end

end