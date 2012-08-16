module Kitabu
  module Parser
    class Print < PDF
      def parse
        apply_print_stylesheet!
        spawn_command ["prince", with_print_styles_file.to_s, "-o", pdf_file.to_s, "--javascript"]
      end

      def apply_print_stylesheet!
        html = Nokogiri::HTML(with_footnotes_file.read)

        head = html.at_css('head')

        style = Nokogiri::XML::Node.new "link", html
        style['href'] = '../templates/html/print.css'
        style['rel'] = 'stylesheet'
        style['type'] = 'text/css'

        head.add_child style

        File.open(with_print_styles_file, "w") {|f| f << html.to_xhtml}
      end

      def with_print_styles_file
        root_dir.join("output/#{name}.print.html")
      end

      def pdf_file
        root_dir.join("output/#{name}.print.pdf")
      end
    end
  end
end

