module Kitabu
  class Callout
    def self.render(source_text, file_format)
      source_text.gsub(/&&&(.*?)&&&/m) do |match|
        new($1, file_format).process
      end
    end

    def initialize(content, file_format)
      @content = content
      @file_format = file_format
    end

    def process
      "<div class='#{class_name}'>#{rendered_content}</div>"
    end

    def rendered_content
      Markup.render(@content, @file_format)
    end

    def class_name
      first_line = @content.split("\n").first
      first_line.presence || 'callout'
    end
  end
end

