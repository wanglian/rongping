module ActivitiesHelper

  # Given an activity, return a message for the feed for the activity's class.
  def feed_message(activity)
    user = activity.user
    case activity_type(activity)
    when "Blog"
      "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "published"[], "a blog"[], blog_link(activity.item)]
    when "Comment"
      parent = activity.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "Topic"
        "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "replied to"[], "{user}'s {object}"[:whose_object, parent.user.name, "topic"[]], topic_link(parent)]
      when "Blog"
        "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "commented"[], "{user}'s {object}"[:whose_object, parent.user.name, "blog"[]], blog_link(parent)]
      when "user"
        %(#{user_link(activity.item.commenter)} commented on 
          #{wall(activity)}.)
      when "Event"
        "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "commented"[], "{user}'s {object}"[:whose_object, parent.user.name, "event"[]], event_link(parent)]
      end
    when "Connection"
      %(#{user_link(activity.item.user)} and
        #{user_link(activity.item.contact)}
        have connected.)
    when "Topic"
      "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "created"[], "a topic"[], topic_link(activity.item)]
    when "Photo"
      %(#{user_link(user)}'s profile picture has changed.)
    when "user"
      %(#{user_link(user)}'s description has changed.)
    when "Event"
      "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "created"[], "a event"[], event_link(activity.item)]
    when "EventAttendee"
      event = activity.item.event
      "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "attended"[], "{user}'s {object}"[:whose_object, event.user.name, "event"[]], event_link(event)]
    when "Document"
      "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "uploaded"[], "a document"[], document_link(activity.item)]
    when "Chatroom"
      "{user} {action} {object}: {object_link}"[:action_feed, user_link(user), "created"[], "a session"[], chatroom_link(activity.item)]
    else
      raise "Invalid activity type #{activity_type(activity).inspect}"
    end
  end
  
  def minifeed_message(activity)
    user = activity.user
    case activity_type(activity)
    when "Blog"
      "{user} {action} {blog}"[:action_mini_feed, user_link(user), "published"[], blog_link("a blog"[], activity.item)]
    when "Comment"
      parent = activity.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "Topic"
        "{user} {action} {topic}"[:action_mini_feed, user_link(activity.item.user), "replied to"[], topic_link("{user}'s {object}"[:whose_object, parent.user.name, "topic"[]], parent)]
      when "Event"
        "{user} {action} {commentable}"[:action_mini_feed, user_link(activity.user), "commented"[], event_link("{user}'s {object}"[:whose_object, parent.user.name, "event"[]], parent)]
      when "Blog"
        "{user} {action} {commentable}"[:action_mini_feed, user_link(activity.user), "commented"[], blog_link("{user}'s {object}"[:whose_object, parent.user.name, "blog"[]], parent)]
      when "user"
        %(#{user_link(activity.item.commenter)} commented on #{wall(activity)}.)
      end
    when "Connection"
      %(#{user_link(user)} and #{user_link(activity.item.contact)} have connected.)
    when "Topic"
      "{user} {action} {object}"[:action_mini_feed, user_link(user), "created"[], topic_link("a topic"[], activity.item)]
    when "Photo"
      %(#{user_link(user)}'s profile picture has changed.)
    when "user"
      %(#{user_link(user)}'s description has changed.)
    when "Event"
      "{user} {action} {object}"[:action_mini_feed, user_link(user), "created"[], event_link("a event"[], activity.item)]
    when "EventAttendee"
      event = activity.item.event
      "{user} {action} {object}"[:action_mini_feed, user_link(user), "attended"[], event_link("{user}'s {object}"[:whose_object, event.user.name, "event"[]], event)]
    when "Document"
      "{user} {action} {object}"[:action_mini_feed, user_link(user), "uploaded"[], document_link("a document"[], activity.item)]
    when "Chatroom"
      "{user} {action} {object}"[:action_mini_feed, user_link(user), "created"[], chatroom_link("a session"[], activity.item)]
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
            when "Document"
              "document.gif"
            when "Chatroom"
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
  
  def document_link(text, document = nil)
    if document.nil?
      document = text
      text = document.title
    end
    link_to text, document_path(document)
  end
  
  def chatroom_link(text, chatroom = nil)
    if chatroom.nil?
      chatroom = text
      text = chatroom.title
    end
    link_to text, chatroom_chats_path(chatroom)
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
