module Kitabu
  class Callout
    def self.render(source_text)
      source_text.gsub(/&&&(.*?)&&&/m) do |match|
        new($1).process
      end
    end

    def initialize(content)
      @content = content
    end

    def process
      "<div class='#{class_name}'>#{@content}</div>"
    end

    def class_name
      first_line = @content.split("\n").first
      first_line.presence || 'callout'
    end
  end
end

