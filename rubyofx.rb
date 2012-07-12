#!/usr/bin/env ruby 
require 'rexml/document'

filter = /./
filter = /#{ARGV[0]}/ if ARGV.length == 1

total = 0
files = Dir[`echo $HOME`.chomp + '/Downloads/*.ofx']
xml = File.new(files[0]).read
xml = xml[/(<OFX>.*<\/OFX>)/m, 1]
if xml
    doc = REXML::Document.new xml
    doc.elements.each('OFX/BANKMSGSRSV1/STMTTRNRS/STMTRS/BANKTRANLIST/STMTTRN') do |transaction|
        date = ''
        name = ''
        amount = ''
        transaction.elements.each do |child|
            date = child.text if child.name == 'DTPOSTED' 
            name = child.text if child.name == 'NAME' 
            amount = child.text if child.name == 'TRNAMT'
        end
        amount_str = ' ' * (10 - amount.length) + amount
        if name[/#{filter}/]
            puts "#{date} #{amount_str} #{name}"
            total += amount.to_f
        end
    end
end
puts "Total #{total}"









