module ApplicationHelper

  # Tags json
  def tags
    array = []
    Tag.all.each do |tag|
      array << tag.name
    end
    array.inspect.html_safe
  end

  # Error message
  def error_messages_for(model)
    if model.errors.any?
      messages = ''
      model.errors.full_messages.each do |msg|
        messages << "<li>#{msg}</li>"
      end
      " <div class=\"alert alert-danger\"><ul>#{messages}</ul></div>".html_safe
    else
      ''
    end
  end
end
