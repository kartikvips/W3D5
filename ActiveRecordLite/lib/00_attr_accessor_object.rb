class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|

      magic = <<-MAGIC
        def #{name}
          @#{name}
        end

        def #{name}=(value)
          @#{name} = value
        end

      MAGIC

      class_eval(magic)
    end
  end
end
