module MailMerge
  # Performs a mail merge based on the options hash that is passed in
  # Example: MailMerge.merge(content, {:site => @site, :user => @user}, ['::site.name::', '::user.full_name::'])
  # will search text_block.content and find all instances of ::user.[method]::
  # and ::site.[method]:: and send the [method] to the associated object
  # Chaining works as well (ex. ::site.organization.name:: yields 'TST Media')
  def self.merge(content, options = {}, merge_fields = [], delimeter = "::")
    options.keys.each do |key|
      obj = options[key]
      merged = content.gsub(/#{delimeter}#{key.to_s}\.[\w|\.]*#{delimeter}/) do |s|
        if merge_fields.empty? or merge_fields.include?(s)
          begin
            res = s[/\..*\w/][/\w.*/].split('.').collect{|m| obj = obj.send(m)}.last
            obj = options[key]
            res
          rescue
            s
          end
        else
          s
        end
      end
    end
    merged
  end
end
