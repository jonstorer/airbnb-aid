module BootstrapIconHelper
  def icon(name)
    content_tag(:i, nil, :class => "icon-#{name.to_s.dasherize}").html_safe
  end
end
