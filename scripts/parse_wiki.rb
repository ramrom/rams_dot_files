require 'nokogiri'

# Impetus was to parse software by criteria in https://en.wikipedia.org/wiki/Comparison_of_disk_encryption_software
class ParseWiki
  attr_reader :page

  def initialize(filename)
    r = File.read(filename)
    @page = Nokogiri::HTML(r)
  end

  def call
    t = tables_by_name("Operating systems").first
    linux_yes = software_with_prop(t, "Linux", "Yes")
    osx_yes = software_with_prop(t, "Mac OS X", "Yes")
    windows_yes = software_with_prop(t, "Windows NT", "Yes")
    os_sup = linux_yes & osx_yes & windows_yes
    puts "Supported by 3 major OSs: #{os_sup}\n\n"

    t = tables_by_name("Background").first
    maintained = software_with_prop(t, "Maintained?", "Yes")
    puts "maintained: #{maintained}\n\n"
   
    t = tables_by_name("Features").first
    hidden_cont = software_with_prop(t, "Hidden containers", "Yes")
    puts "has hidden cont: #{hidden_cont}\n\n"

    os_sup & maintained & hidden_cont
  end

  def tables_by_name(name)
    #res = @page.css('h2').select { |h| h.text =~ /.*#{regex}.*/ }
    @page.xpath("//h2[span[contains(text(),'#{name}')]]/following-sibling::table[1]")
  end

  # first row of table not including first column
  def table_headers(tnode)
    tnode.css('tr[1] th')[1..-1].map { |t| t.text.strip }
  end

  def table_prop_index(tnode, prop_name)
    headers = table_headers(tnode)
    headers.index(prop_name) # index returns nil if no exact match was found
  end

  def software_with_prop(tnode, prop_name, value)
    pindex = table_prop_index(tnode, prop_name)
    raise "#{prop_name} doesnt exist!" if pindex == nil

    ns = tnode.css('tr')[1..-2].select do |n|
      n.css('td')[pindex].text.strip.include?(value)
    end
    ns.map { |n| n.css('th').text.strip }
  end

  def softwares(tnode)
    tnode.css('tr')[1..-2].css('th[1]').map { |t| t.text.strip }
  end
end
