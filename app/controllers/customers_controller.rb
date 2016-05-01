class CustomersController < ApplicationController
  def index
    @customers = if params[:keywords].present?
      Customer.where(search.where_clause, search.where_args).order(search.order)
    else
      []
    end
  end

  private

  def search
    @_search ||= CustomerSearchTerm.new(params[:keywords])
  end
end
