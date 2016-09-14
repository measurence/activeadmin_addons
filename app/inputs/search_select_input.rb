class SearchSelectInput < Formtastic::Inputs::StringInput
  def input_html_options
    relation = @object.send(attributized_method_name)
    opts = {}
    opts[:class] = ['select2-ajax'].concat([@options[:class]] || []).join(' ')
    opts["data-fields"] = (@options[:fields] || []).to_json
    opts["data-url"] = @options[:url] || ""
    opts["data-response_root"] = @options[:response_root] || @options[:url].to_s.split('/').last
    opts["data-display_name"] = @options[:display_name] || "name"
    opts["data-minimum_input_length"] = @options[:minimum_input_length] || 1
    opts["data-selected"] = relation.try(opts["data-display_name"].to_sym)
    if @options[:multiple].present?
      opts["multiple"] = @options[:multiple]
      if attributized_method_name.to_s.include?('_ids')
        relation = @object.send(attributized_method_name.to_s.gsub('_ids', '').pluralize)
        opts["data-multiple-selected"] = relation.map{|item| {id: item.id, text: item.send(@options[:display_name]) }}.to_json
      end

    end

    super.merge opts
  end
end
