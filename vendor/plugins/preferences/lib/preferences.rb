module Preferences
  module MacroMethods
    
    def preference(attribute, *args)    
      options = args.extract_options!
      class_inheritable_hash :stored_preferences
      
      self.stored_preferences ||= { }
      self.stored_preferences[:sys_attrs] ||= {
        :edit_attrs => [],
        :protected_attrs => []
      }
      self.stored_preferences[:user_attrs] ||= []
      
      

      class << self
        define_method :protected_attrs do 
          self.stored_preferences[:sys_attrs][:protected_attrs]
        end unless method_defined? :protected_attrs
        
        define_method :edit_attrs do 
          self.stored_preferences[:sys_attrs][:edit_attrs]
        end unless method_defined? :edit_attrs
        
        define_method :user_attrs do
          self.stored_preferences[:user_attrs]          
        end unless method_defined? :user_attrs
        
      end

      
      case options[:access_level].to_s
      when /protected/
        self.stored_preferences[:sys_attrs][:protected_attrs] << attribute
      when /user/
        self.stored_preferences[:user_attrs] << attribute     
      else
        self.stored_preferences[:sys_attrs][:edit_attrs] << attribute
      end
      
        
      define_method(attribute.to_s) do |*args|
        self.preferences ||= { }
        self.preferences[attribute.to_s] || options[:default]
      end
      
      define_method("#{attribute.to_s}=") do |value|
        self.preferences ||= { }
        self.preferences[attribute.to_s] = value unless options[:access_level].to_s == "protected"
      end
      
    end
  end
end

ActiveRecord::Base.class_eval do
  extend Preferences::MacroMethods
end

