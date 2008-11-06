module ApplicationHelper
  include TagsHelper
  
  # Yield the content for a given block. If the block yiels nothing, the optionally specified default text is shown. 
  #
  #   yield_or_default(:user_status)
  #
  #   yield_or_default(:sidebar, "Sorry, no sidebar")
  #
  # +target+ specifies the object to yield.
  # +default_message+ specifies the message to show when nothing is yielded. (Default: "")
  def yield_or_default(message, default_message = "")
    message.nil? ? default_message : message
  end

  # Create tab.
  # 
  # The tab will link to the first options hash in the all_options array,
  # and make it the current tab if the current url is any of the options
  # in the same array.
  # 
  # +name+ specifies the name of the tab
  # +all_options+ is an array of hashes, where the first hash of the array is the tab's link and all others will make the tab show up as current.
  # 
  # If now options are specified, the tab will point to '#', and will never have the 'active' state.
  def tab_to(name, all_options = nil)
    url = all_options.is_a?(Array) ? all_options[0].merge({:only_path => false}) : "#"

    current_url = url_for(:action => @current_action, :only_path => false)
    html_options = {}

    if all_options.is_a?(Array)
      all_options.each do |o|
        if url_for(o.merge({:only_path => false})) == current_url
          html_options = {:class => "current"}
          break
        end
      end  
    end

    link_to(name, url, html_options)
  end

  # Return true if the currently logged in user is an admin
  def admin?
    logged_in? && current_user.has_role?(:admin)
  end
  
  # Write a secure email adress
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end
  
  def cell(label, value)
    "<tr>
  		<td class='label' nowrap='nowrap'>#{label}</td>
  		<td class='value'>#{value}</td>
  	</tr>"
  end
  
  def cell_separator
    "<tr>
  		<td colspan='2' class='separator'></td>
  	</tr>"
  end
  
  # override 以汉化
  # def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
  #   from_time = from_time.to_time if from_time.respond_to?(:to_time)
  #   to_time = to_time.to_time if to_time.respond_to?(:to_time)
  #   distance_in_minutes = (((to_time - from_time).abs)/60).round
  #   distance_in_seconds = ((to_time - from_time).abs).round
  # 
  #   case distance_in_minutes
  #    when 0..1
  #      return (distance_in_minutes == 0) ? '不到1分钟' : '1分钟' unless include_seconds
  #      case distance_in_seconds
  #        when 0..4   then '不到5秒'
  #        when 5..9   then '不到10秒'
  #        when 10..19 then '不到20秒'
  #        when 20..39 then '半分钟'
  #        when 40..59 then '不到1分钟'
  #        else             '1分钟'
  #      end
  # 
  #    when 2..44           then "#{distance_in_minutes}分钟"
  #    when 45..89          then '约1小时'
  #    when 90..1439        then "约#{(distance_in_minutes.to_f / 60.0).round}小时"
  #    when 1440..2879      then '1天'
  #    when 2880..43199     then "#{(distance_in_minutes / 1440).round}天"
  #    when 43200..86399    then '约1月'
  #    when 86400..525599   then "#{(distance_in_minutes / 43200).round}月"
  #    when 525600..1051199 then '约1年'
  #    else                      "#{(distance_in_minutes / 525600).round}年"
  #   end
  # end
end
