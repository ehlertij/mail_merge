module MailMerge
  # Performs a mail merge based on the options hash that is passed in
  # Example: MailMerge.merge(content, {:site => @site, :user => @user}, ['::site.name::', '::user.full_name::'])
  # will search text_block.content and find all instances of ::user.[method]::
  # and ::site.[method]:: and send the [method] to the associated object
  # Chaining works as well (ex. ::site.organization.name:: yields 'TST Media')
  # Supports finding of objects with this syntax: ::[user-1].full_name:: (calls User.find(1).full_name)
  # - requires allow_dynamic flag to be true
  def self.merge(content, options = {}, merge_fields = [], delimeter = "::", allow_dynamic = false)
    merged = content
    options.keys.each do |key|
      obj = options[key]
      merged = merged.gsub(/#{delimeter}#{key.to_s}\.[\w|\.]*#{delimeter}/) do |s|
        if merge_fields.empty? or merge_fields.include?(s)
          begin
            call_methods(s, obj)
          rescue
            s
          end
        else
          s
        end
      end
    end
    if allow_dynamic
      objects = {}
      merged = merged.gsub(/#{delimeter}\[?\w*(-\d*)?\]?\.[\w|\.]*#{delimeter}/) do |s|
        x = s[/\[?\w*-\d*\]/].delete('[]')
        begin
        unless objects[x]
          class_name, id = x.split('-')
          objects[x] = class_name.camelize.constantize.find(id)
        end
        call_methods(s, objects[x])
        rescue
          s
        end
      end
    end
    merged
  end
  
  private
  def self.call_methods(s, obj)
    s[/\..*\w/][/\w.*/].split('.').collect{|m| obj = obj.send(m)}.last
  end
  
end