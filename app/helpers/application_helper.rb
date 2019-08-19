module ApplicationHelper
  def display_errors(field)
    return [] unless flash[:errors] && flash[:errors][field]

    flash[:errors][field].map { |error| field.capitalize + ' ' + error }
  end
end
