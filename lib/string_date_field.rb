# stringify_time.rb
module StringDateField

  class << self
    def validate_date(date)
      begin
        date_str = date.to_s.gsub(/[^0-9]/,'')
        Date.strptime(date_str, I18n.t('date.formats.compact', :default => '%d%m%Y'))
      rescue ArgumentError
        false
      end
    end
  end

  def define_string_date_field(*names)
    names.each do |name|
      define_method "#{name}_str" do
        attr_val = read_attribute(name)
        I18n.l(attr_val.to_date) unless attr_val.nil?
      end

      define_method "#{name}_str=" do |time_str|
        date = StringDateField::validate_date(time_str)
        if date.nil? || !date
          instance_variable_set("@#{name}_str_invalid", true)
        else
          write_attribute(name, date) unless date.nil?
        end
      end

      define_method "#{name}_str_invalid?" do
        instance_variable_get("@#{name}_str_invalid")
      end
    end
  end
end

