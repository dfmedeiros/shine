class CustomerSearchTerm
  attr_reader :where_clause, :where_args, :order

  def initialize(search_term)
    @where_clause = ""
    @where_args = {}
    @search_term = search_term.downcase

    if @search_term =~ /@/
      build_for_email_search
    else
      build_for_name_search
    end
  end

  private

  attr_reader :search_term

  def build_for_email_search
    @where_clause << case_insensitive_search(:first_name)
    @where_args[:first_name] = starts_with(extracted_name)

    @where_clause << " OR #{case_insensitive_search(:last_name)}"
    @where_args[:last_name] = starts_with(extracted_name)

    @where_clause << " OR #{case_insensitive_search(:email)}"
    @where_args[:email] = search_term

    @order = "LOWER(email) = #{quoted_term} DESC, last_name ASC"
  end

  def build_for_name_search
    @where_clause << case_insensitive_search(:first_name)
    @where_args[:first_name] = starts_with

    @where_clause << " OR #{case_insensitive_search(:last_name)}"
    @where_args[:last_name] = starts_with

    @order = "last_name ASC"
  end

  def case_insensitive_search(field_name)
    "LOWER(#{field_name}) LIKE :#{field_name}"
  end

  def starts_with(term = search_term)
    "#{term}%"
  end

  def extracted_name
    @_extracted_name ||= search_term.gsub(/@.*$/, '').gsub(/[0-9]+/, '')
  end

  def quoted_term
    @_quoted_term ||= ActiveRecord::Base.connection.quote(search_term)
  end
end
