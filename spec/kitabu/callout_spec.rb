# -*- encoding: utf-8 -*-
require "spec_helper"

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

describe Kitabu::Callout do
  SOURCE_TEXT = <<-TEXT
    This is one fancy paragraph.

    &&&
    This is a callout section
    &&&

    This is the last paragraph.
  TEXT

  it "renders the callout in its own div" do
    content = Kitabu::Callout.render(SOURCE_TEXT)
    content.should have_tag("div", 1)
    Nokogiri::HTML(content).text.should match(/callout section/)
  end

  it "renders with class=callout by default" do
    content = Kitabu::Callout.render(SOURCE_TEXT)
    content.should have_tag("div.callout", 1)
    Nokogiri::HTML(content).text.should match(/callout section/)
  end

  it "renders with a custom class name if given" do
    content = Kitabu::Callout.render("&&& warning\nThis is the warning &&&")
    content.should have_tag("div.warning", 1)
  end
end

