module ActivityLogger

  # Add an activity to the feeds of a person's contacts.
  # Usually, we only add to the feeds of the contacts, not the person himself.
  # For example, if a person makes a forum post, the activity shows up in
  # his contacts' feeds but not his.
  # The :include_person option is to handle the case when add_activities
  # should include the person as well.  This happens when
  # someone comments on a person's blog post or wall.  In that case, when
  # adding activities to the contacts of the wall's or post's owner,
  # we should include the owner as well, so that he sees in his feed
  # that a comment has been made.
  def add_activities(options = {})
    Activity.create!(:item => options[:item], :user => options[:user])
  end
end