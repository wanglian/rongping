module ActivitiesHelper

  # Given an activity, return a message for the feed for the activity's class.
  def feed_message(activity)
    user = activity.user
    case activity_type(activity)
    when "Blog"
      %(#{user_link(user)} 写了一篇日志: #{blog_link(activity.item)}.)
    when "Comment"
      parent = activity.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "Topic"
        %(#{user_link(activity.item.user)} 回复话题: #{topic_link(parent)}.)
      when "Blog"
        blog = activity.item.commentable
        %(#{user_link(user)} 评论#{someones(blog.user, user)}日志: #{blog_link(blog)}.)
      when "user"
        %(#{user_link(activity.item.commenter)} commented on 
          #{wall(activity)}.)
        when "Event"
          %(#{user_link(activity.user)} 评论活动: #{event_link(parent)}.)
      end
    when "Connection"
      %(#{user_link(activity.item.user)} and
        #{user_link(activity.item.contact)}
        have connected.)
    when "ForumPost"
      post = activity.item
      %(#{user_link(user)} made a post on the forum topic
        #{topic_link(post.topic)}.)
    when "Topic"
      %(#{user_link(user)} 创建话题: #{topic_link(activity.item)}.)
    when "Photo"
      %(#{user_link(user)}'s profile picture has changed.)
    when "user"
      %(#{user_link(user)}'s description has changed.)
    when "Event"
      event = activity.item
      %(#{user_link(user)} 创建了活动: #{event_link(event.title, event)}.)
    when "EventAttendee"
      event = activity.item.event
      %(#{user_link(user)} 参加#{someones(event.user, user)}活动: 
        #{event_link(event.title, event)}.) 
    when "OrderProgress"
      %(#{user_link(user)} 填写#{order_link("订单施工记录", activity.item)})
    else
      raise "Invalid activity type #{activity_type(activity).inspect}"
    end
  end
  
  def minifeed_message(activity)
    user = activity.user
    case activity_type(activity)
    when "Blog"
      %(#{user_link(user)} 写了#{blog_link("一篇日志", activity.item)}.)
    when "Comment"
      parent = activity.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "Topic"
        %(#{user_link(activity.item.user)} 回复#{topic_link("话题", parent)})
      when "Event"
        %(#{user_link(activity.user)} 评论#{event_link("活动", parent)})
      when "Blog"
        blog = activity.item.commentable
        %(#{user_link(user)} 评论#{someones(blog.user, user)}#{blog_link("日志", blog)}.)
      when "user"
        %(#{user_link(activity.item.commenter)} commented on 
          #{wall(activity)}.)
      end
    when "Connection"
      %(#{user_link(user)} and #{user_link(activity.item.contact)}
        have connected.)
    when "ForumPost"
      topic = activity.item.topic
      %(#{user_link(user)} made a #{topic_link("forum post", topic)}.)
    when "Topic"
      %(#{user_link(user)} 创建#{topic_link("话题", activity.item)}.)
    when "Photo"
      %(#{user_link(user)}'s profile picture has changed.)
    when "user"
      %(#{user_link(user)}'s description has changed.)
    when "Event"
      %(#{user_link(user)} 创建#{event_link("活动", activity.item)}.)
    when "EventAttendee"
      event = activity.item.event
      %(#{user_link(user)} 参加#{someones(event.user, user)}#{event_link("活动", event)}.)
    when "OrderProgress"
      %(#{user_link(user)} 填写#{order_link("订单施工记录", activity.item)}.)
    else
      raise "Invalid activity type #{activity_type(activity).inspect}"
    end
  end
  
  # Given an activity, return the right icon.
  def feed_icon(activity)
    img = case activity_type(activity)
            when "Blog"
              "blog.gif"
            when "Comment"
              parent_type = activity.item.commentable.class.to_s
              case parent_type
              when "Blog"
                "comment.gif"
              when "Event"
                "comment.gif"
              when "user"
                "signal.gif"
              when "Topic"
                "new.gif"
              end
            when "Connection"
              "switch.gif"
            when "ForumPost"
              "new.gif"
            when "Topic"
              "add.gif"
            when "Photo"
              "camera.gif"
            when "user"
              "edit.gif"
            when "Event"
              "time.gif"
            when "EventAttendee"
              "check.gif"
            when "OrderProgress"
              "reply.gif"
            else
              raise "Invalid activity type #{activity_type(activity).inspect}"
            end
    image_tag("icons/#{img}", :class => "icon")
  end
  
  def someones(user, commenter, link = true)
    link ? "#{user_link(user)}的" : "#{h user.name}的"
  end
  
  def blogs_link(text, user)
    link_to(text, blogs_path(:user => user.name))
  end
  
  def blog_link(text, blog = nil)
    if blog.nil?
      blog = text
      text = blog.title
    end
    link_to(text, blog_path(blog))
  end
  
  def topic_link(text, topic = nil)
    if topic.nil?
      topic = text
      text = topic.name
    end
    link_to(text, topic_path(topic))
  end

  def event_link(text, event = nil)
    if event.nil?
      event = text
      text = event.title
    end
    link_to(text, event_path(event))
  end

  def order_link(text, order)
    link_to(text, '/order_progresses')
  end
  

  # Return a link to the wall.
  def wall(activity)
    commenter = activity.user
    user = activity.item.commentable
    link_to("#{someones(user, commenter, false)} wall",
            user_path(user, :anchor => "wall"))
  end
  
  private
  
    # Return the type of activity.
    # We switch on the class.to_s because the class itself is quite long
    # (due to ActiveRecord).
    def activity_type(activity)
      activity.item.class.to_s      
    end
end
