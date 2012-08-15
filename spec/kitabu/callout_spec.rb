# -*- encoding: utf-8 -*-
require "spec_helper"

describe Kitabu::Callout do
  SOURCE_TEXT = <<-TEXT
This is one fancy paragraph.

&&&
This is a callout section.

**This is a strong point**.
&&&

This is the last paragraph.
  TEXT

  it "renders the callout in its own div" do
    content = Kitabu::Callout.render(SOURCE_TEXT, :markdown)
    content.should have_tag("div", 1)
    Nokogiri::HTML(content).text.should match(/callout section/)
  end

  it "renders with class=callout by default" do
    content = Kitabu::Callout.render(SOURCE_TEXT, :markdown)
    content.should have_tag("div.callout", 1)
    Nokogiri::HTML(content).text.should match(/callout section/)
  end

  it "renders with a custom class name if given" do
    content = Kitabu::Callout.render("&&& warning\nThis is the warning &&&", :markdown)
    content.should have_tag("div.warning", 1)
  end

  it "renders inner content as markdown" do
    content = Kitabu::Callout.render(SOURCE_TEXT, :markdown)
    content.should have_tag("strong", 1)
  end
end

