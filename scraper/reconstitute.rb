#! /usr/bin/env ruby

require 'mustache'
require 'yaml'
require 'tzinfo'

tz = TZInfo::Timezone.get('Australia/Sydney')
date_string = tz.now.strftime("%F")

in_edited =  "stories/#{date_string}-butnotshit.yaml"
stories = File.open(in_edited, "r").read

class ABCTemplate < Mustache
  self.template_file = './template.html'
end

rendered = ABCTemplate.render(YAML.load stories)
out_index = "./public/index.html"
File.open(out_index, "w"){ |file| file.write(rendered) }
