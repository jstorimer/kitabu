# -*- encoding: utf-8 -*-
require "spec_helper"

describe Kitabu::Markup do
  MARKUP = <<-TEXT
This is a callout section.

**This is a strong point**.
  TEXT
 
  it "renders the content as markdown" do
    content = Kitabu::Markup.render(MARKUP, :markdown)
    content.should have_tag("strong", 1)
    Nokogiri::HTML(content).text.should match(/callout section/)
  end
end

