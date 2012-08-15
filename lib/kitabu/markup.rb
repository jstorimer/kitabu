module Kitabu
  class Markup
    # Supported Markdown libraries
    #
    MARKDOWN_LIBRARIES = %w[Maruku BlueCloth PEGMarkdown Redcarpet RDiscount]

    def self.render(content, file_format)
      content = case file_format
                when :markdown
                  markdown.new(content).to_html
                when :textile
                  RedCloth.convert(content)
                else
                  content
                end

    end
    # Retrieve preferred Markdown processor.
    # You'll need one of the following libraries:
    #
    # # RDiscount: https://rubygems.org/gems/rdiscount
    # # Maruku: https://rubygems.org/gems/maruku
    # # PEGMarkdown: https://rubygems.org/gems/rpeg-markdown
    # # BlueCloth: https://rubygems.org/gems/bluecloth
    # # Redcarpet: https://rubygems.org/gems/redcarpet
    #
    # Note: RDiscount will always be installed as Kitabu's dependency but only used when no
    # alternative library is available.
    #
    def self.markdown
      Object.const_get(MARKDOWN_LIBRARIES.find {|lib| Object.const_defined?(lib)})
    end
  end
end

