#! /usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'yaml'
require 'tzinfo'

@frontpage = Nokogiri::HTML(open('http://www.abc.net.au/news/'))
# @frontpage = Nokogiri::HTML(open('frontpage.html'))
@result = {}

news_container = @frontpage.css "#newshome div.page_margins div.page.section"

### Main Stories:

main_stories = news_container.css ".subcolumns .c75l .subcolumns .c66l .show-for-national .module-body ol>li.doctype-article"
@result['main_stories'] = []
for story_element in main_stories
  story = {}

  # TODO: determine the size of the story on the front page -- small big huge

  header = story_element.css(">h3 a").first
  story['title'] = header.text.strip
  story['link'] = header['href']

  description = story_element.css(">p").first
  story['description'] = description.text.strip

  image_id = story_element['data-image-cmid']
  if not image_id.nil?
    story['image_id'] = image_id.to_i
  end

  # TODO: extract the followup text-only stories

  @result['main_stories'] << story
end

### Side Column:

side_column = news_container.css ".subcolumns .c75l .subcolumns .c33r .show-for-national .section.module-body ol>li.doctype-article"
@result['side_column'] = []
for story_element in side_column
  story = {}

  # TODO: extract "kicker", that says Analysis or Opinion

  link = story_element.css("a").first
  story['link'] = link['href']
  story['title'] = link.text.strip

  image_id = story_element['data-image-cmid']
  if not image_id.nil?
    story['image_id'] = image_id.to_i
  end

  @result['side_column'] << story
end


### Output:
tz = TZInfo::Timezone.get('Australia/Sydney')
date_string = tz.now.strftime("%F")
out_backup =  "stories/#{date_string}.yaml"
out_edited =  "stories/#{date_string}-butnotshit.yaml"
File.open(out_backup, "w"){ |file| file.write(@result.to_yaml) }
File.open(out_edited, "w"){ |file| file.write(@result.to_yaml) }
