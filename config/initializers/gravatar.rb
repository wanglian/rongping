module GravatarHelper
  DEFAULT_OPTIONS = {
    # The URL of a default image to display if the given email address does
    # not have a gravatar.
    :default => '',
    
    # The default size in pixels for the gravatar image (they're square).
    :size => 80,
    
    # The maximum allowed MPAA rating for gravatars. This allows you to 
    # exclude gravatars that may be out of character for your site.
    :rating => 'R',
    
    # The alt text to use in the img tag for the gravatar.
    :alt => 'avatar',
    
    # The class to assign to the img tag for the gravatar.
    :class => 'gravatar',
  }
end