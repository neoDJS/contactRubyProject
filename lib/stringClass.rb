class String
    def validate regex
      !self[regex].nil?
    end
    
    def new_capitalize
      self.split(" ").collect(&:capitalize).join(" ")
    end
  end
  