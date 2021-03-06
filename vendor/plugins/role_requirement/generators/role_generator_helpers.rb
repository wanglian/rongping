module RoleGeneratorHelpers
  def insert_content_after(filename, regexp, content_for_insertion, options = {})
    content = File.read(filename)
    options[:unless] ||= lambda {false }
    # already have the function?  Don't generate it twice
    unless options[:unless].call(content)
      # find the line that has the model declaration
      lines = content.split("\n")
      found_line = nil
      
      0.upto(lines.length-1) {|line_number| 
        found_line = line_number if regexp.match(lines[line_number])
      }
      if found_line
        # insert the rest of these lines after the found line
        lines.insert(found_line+1, content_for_insertion)
        content = lines * "\n"
        
        File.open(filename, "w") {|f| f.puts content }
        return true
      end
    else
      return false
    end
  end
  
  def add_dependencies_to_application_rb
    app_filename = "#{RAILS_ROOT}/app/controllers/application.rb"
    
    auth_system_content = <<EOF
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
EOF
    
    role_requirement_content = <<EOF
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirement
EOF

    insert_content_after(
      app_filename, 
      /class +ApplicationController/, 
      auth_system_content,
      :unless => lambda {|content| /include +AuthenticatedSystem/.match(content) }
    ) && puts("Added ApplicationController include to #{app_filename}")
    
    insert_content_after(
      app_filename, 
      /include +AuthenticatedSystem/, 
      role_requirement_content,
      :unless => lambda {|content| /include +RoleRequirement/.match(content) }
    ) && puts("Added RoleRequirement include to #{app_filename}")
    
  end
  
end