class CustomersController < ApplicationController
  PAGE_SIZE = 10

  def index
    @customers = if params[:keywords].present?
      Customer.where(search.where_clause, search.where_args)
        .order(search.order)
        .offset(PAGE_SIZE * page)
        .limit(PAGE_SIZE)
    else
      []
    end
  end

  private

  def search
    @_search ||= CustomerSearchTerm.new(params[:keywords])
  end

  def page
    @page ||= (params[:page] || 0).to_i
  end
end
