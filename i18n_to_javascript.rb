module I18n
  module Backend
    class Simple  
      def translations_for_javascript
        send(:init_translations) unless initialized?
        default_locale = I18n.default_locale
        return nil unless translations[default_locale].has_key?(:javascript)
        javascript_translations = {}
        translations.keys.each do |locale|
          javascript_translations[locale] = if locale != default_locale && translations[locale].has_key?(:javascript)
            translations[default_locale][:javascript].merge(translations[locale][:javascript])
          else
            translations[default_locale][:javascript]
          end
        end
       javascript_translations
      end
  
      def write_javascripts
        translation_hash = translations_for_javascript || return
        unless FileTest::directory?("#{Rails.root}/public/javascripts/locales")
          Dir::mkdir(File.join("#{Rails.root}","public","javascripts","locales"))
        end
        translation_hash.keys.each do |locale|
          File.open(File.join("#{Rails.root}", "public","javascripts","locales","translate_#{locale}.js"), "w:utf-8") do |f|
            f.write "var translate = "
            f.write translation_hash[locale].to_json
            f.write ";"
          end
        end
      end
    end
  end
end