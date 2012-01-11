# -*- encoding : utf-8 -*-
require 'json'
index = File.new("search_index.js").gets
index.gsub!("var search_data = ","")
json = JSON.load(index)

class Array
  def chunk(pieces=2)
    len = self.length;
    mid = (len/pieces)
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << self[start..last] || []
      start = last+1
    end
    chunks
  end
end

File.open("search_index_searchindex.js", "w") do |f|
  data = json["index"]["searchIndex"]
  out = ["var search_data = search_data || {\"index\":{}};"]
  out << "search_data[\"index\"][\"searchIndex\"] = #{data.to_json};"
  f.write(out.join("\n"))
end


data = json["index"]["info"].chunk(6)
data.each_with_index do |chunk, index|
  File.open("search_index_info_#{index}.js", "w") do |f|
    out = ["var search_data = search_data || {'index':{}};"]
    out << "search_data['index'] = search_data['index'] || {};"
    out << "search_data['index']['info'] = search_data['index']['info'] || [];"
    out << "search_data[\"index\"][\"info\"] = search_data[\"index\"][\"info\"].concat(#{chunk.to_json});"
    f.write(out.join("\n"))
  end
end

data = json["index"]["longSearchIndex"].chunk(2)
data.each_with_index do |chunk, index|
  File.open("search_index_long_search_index_#{index}.js", "w") do |f|
    out = ["var search_data = search_data || {\"index\":{}};"]
    out << "search_data['index']['longSearchIndex'] = search_data['index']['longSearchIndex'] || [];"
    out << "search_data['index']['longSearchIndex'] = search_data[\"index\"][\"longSearchIndex\"].concat(#{chunk.to_json});"
    f.write(out.join("\n"))
  end
end
