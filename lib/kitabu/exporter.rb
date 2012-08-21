module Kitabu
  class Exporter
    def self.run(root_dir, options)
      exporter = new(root_dir, options)

      if options[:auto]
        exporter.export!
        exporter.auto! if options[:auto]
      else
        exporter.export!
      end
    end

    attr_accessor :root_dir
    attr_accessor :options

    def initialize(root_dir, options)
      @root_dir = root_dir
      @options = options
    end

    def ui
      @ui ||= Thor::Base.shell.new
    end

    def export!
      helper = root_dir.join("config/helper.rb")
      require(helper) if helper.exist?

      export_pdf = [nil, "pdf"].include?(options[:only])
      export_epub = [nil, "mobi", "epub"].include?(options[:only])
      export_mobi = [nil, "mobi"].include?(options[:only])
      export_txt = [nil, "txt"].include?(options[:only])

      exported = []
      exported << Parser::HTML.parse(root_dir)
      exported << Parser::PDF.parse(root_dir) if export_pdf && Dependency.prince?
      exported << Parser::Epub.parse(root_dir) if export_epub
      exported << Parser::Mobi.parse(root_dir) if export_mobi && Dependency.kindlegen?
      exported << Parser::Txt.parse(root_dir) if export_txt && Dependency.html2text?

      if exported.all?
        color = :green
        message = options[:auto] ? "exported!" : "** e-book has been exported"

        if options[:open] && export_pdf && RUBY_PLATFORM =~ /darwin/
          filepath = root_dir.join("output/#{File.basename(root_dir)}.pdf")
          IO.popen("open -a Preview.app '#{filepath}'").close
        end

        Notifier.notify(
          :image   => Kitabu::ROOT.join("templates/ebook.png"),
          :title   => "Kitabu",
          :message => "Your \"#{config[:title]}\" e-book has been exported!"
        )
      else
        color = :red
        message = options[:auto] ? "could not be exported!" : "** e-book couldn't be exported"
      end

      ui.say message, color
    end

    def config
      Kitabu.config(root_dir)
    end

    def auto!
      script = Watchr::Script.new

      script.watch(%r[(code|config|images|templates|text)/.*]) do |match|
        ui.say "* #{match[0]}... ", :yellow, false
        export!
      end

      contrl = Watchr::Controller.new(script, Watchr.handler.new)
      contrl.run
    end
  end
end
