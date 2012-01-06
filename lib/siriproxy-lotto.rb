# -*- encoding: utf-8 -*-
require 'cora'
require 'siri_objects'
require 'eat'
require 'nokogiri'
require 'timeout'


#######
#
# This is simple read the latest Lottery Numbers for Austria "6aus45" and Germany "6aus49" 
# and Euromillionen
#
#       Remember to put this plugins into the "./siriproxy/config.yml" file 
#######
#
# Das ist ein einfaches Siri liest die Lottozahlen vor - Plugin.
# Funktioniert derzeit mit 6aus45 (Österreich) und 6aus49 (Deutschland) und Euromillionen
# 
# den Code bitte nicht genauer ansehen, bin absoluter Ruby Neuling 
# ich weis, ich sollte ein "Ruby for Dummies"-Buch lesen
# 
#      ladet das Plugin in der "./siriproxy/config.yml" datei !
#
#######
## ##  WIE ES FUNKTIONIERT 
#
# sagt einfach einen Satz mit "Lotto" für die Österreichischen 6aus45 Zahlen,
# "Lotto" + "Deutschland" für Deutschlands 6aus49
# oder "Euromillionen" für die Euromillionen Ziehung
#
# bei Fragen Twitter: @muhkuh0815
# oder github.com/muhkuh0815/SiriProxy-Lotto
# Video http://www.youtube.com/watch?v=Q6sedYlee1Q
#
#
#### ToDo
#
# Gewinnabfrage
#
#######


class SiriProxy::Plugin::Lotto < SiriProxy::Plugin
    
    def initialize(config)
        #if you have custom configuration options, process them here!
    end
    def doc
    end
    def docs
    end
    
# german Looto numbers 4au49
    
listen_for /(Lotto|Lottozahlen|Ziehung|Lottoziehung|Lauter|Sechs aus 49|Sex aus 49).*(Deutschland)/i do
    
    shaf = ""
    begin
    doc = Nokogiri::XML(eat("http://rss.auto-scripting.com/rss_lotto_6aus49.php?count=1"))
    rescue Timeout::Error
    print "Timeout-Error beim Lesen der Seite"
    shaf ="timeout"
    next
    rescue
    print "Lesefehler !"
    shaf ="timeout"
    next
end

if shaf =="timeout" 
    say "Es gab ein Problem beim einlesen der Lotodaten!"
    else
    doc = doc.to_s
    doc = doc.gsub(/<\/?[^>]*>/, "")
    dat = doc.match(/(hr)/)
    dat2 = dat.post_match
    if dat = dat2.match(/(2011)/)
    datj = "2011" 
    elsif dat = dat2.match(/(2012)/)
    datj = "2012" 
    end
    dat2 = dat.pre_match
    dat = dat2.split('.')
    tag = dat[0].strip
    tag = tag.reverse
    tag = tag.chop
    tag = tag.reverse
    tag = tag.strip
    datt = dat[1].strip
    datm = dat[2].strip
    zal = doc.match(/(Ziehungzahlen: )/)
    zal2 = zal.post_match
    zal = zal2.match(/(Gewinnquoten)/)
    zal2 = zal.pre_match
    zal = zal2.split
    z1 = zal[0]
    z2 = zal[1]
    z3 = zal[2]
    z4 = zal[3]
    z5 = zal[4]
    z6 = zal[5]
    zz = zal[6]
    zz = zz.reverse
    zz = zz.chop.chop.chop
    zz = zz.reverse
    sz = zal[7]
    sz = sz.reverse
    sz = sz.chop.chop.chop
    sz = sz.reverse
    
    if tag == "Mo"
        saytag = "Montag"
        elsif tag == "Di"
        saytag = "Dienstag"
        elsif tag === "Mi"
        saytag = "Mittwoch"
        elsif tag == "Do"
        saytag = "Donnerstag"
        elsif tag == "Fr"
        saytag = "Freitag"
        elsif tag == "Sa"
        saytag = "Samstag"
        elsif tag == "So"
        saytag = "Sonntag"
        else
        saytag = "Fehler, Vorsicht!"
    end
    
    say "6 aus 49 - Ziehung vom: " + saytag + " den " + datt + "." + datm + "." + datj, spoken: "6 aus 49, Ziehung vom: " + saytag + " den " + datt + "ten " + datm + "ten " + datj
    say "GZ: " + z1 + " " + z2 + "  " + z3 + "  " +z4+ "  " + z5 + "  " +z6, spoken: "Gewinnzahlen: " + z1 + ", " + z2 + ",  " + z3 + ",  " + z4 + ",  " + z5 + ",  " + z6
    say "Zusatzzahl: " + zz + "  Superzahl: " + sz
    say "alle Angaben ohne Gewähr"
end    

request_completed
end

# Euromillionen

listen_for /(Euro Millionen|Euro Million)/i do
    
    shaf = ""
    begin
    doc = Nokogiri::XML(eat("http://www.lottoy.net/de/euromillionen/rss-feed/aktuelle-lottozahlen-gewinnzahlen-euromillionen.xml"))
    doc.encoding = 'utf-8'
    rescue Timeout::Error
    print "Timeout-Error beim Lesen der Seite"
    shaf ="timeout"
    next
    rescue
    print "Lesefehler !"
    shaf ="timeout"
    next
end

if shaf =="timeout" 
    say "Es gab ein Problem beim einlesen der Lotodaten!"
    else
    docs = doc.xpath('//description')
    doc = docs[1].text
    doc = doc.to_s
    doc = doc.gsub(/<\/?[^>]*>/, "")
	dat = doc.match(/(Euromillionen )/)
    dat2 = dat.post_match
    tag = dat2[0,2]
    dat = doc.match(/(sziehung )/)
    dat2 = dat.post_match
    datt = dat2[0,2]
    datm = dat2[3,2]
    datj = dat2[6,4]
	zal = doc.match(/(Gewinnzahlen: )/)
    zal2 = zal.post_match
    zal = zal2.match(/(alle Angaben)/)
    zal2 = zal.pre_match
    zal = zal2.split
    z1 = zal[0].chop
    z2 = zal[1].chop
    z3 = zal[2].chop
    z4 = zal[3].chop
    z5 = zal[4]
    s1 = zal[7]
    s2 = zal[10]
    
    if tag == "Mo"
        saytag = "Montag"
        elsif tag == "Di"
        saytag = "Dienstag"
        elsif tag === "Mi"
        saytag = "Mittwoch"
        elsif tag == "Do"
        saytag = "Donnerstag"
        elsif tag == "Fr"
        saytag = "Freitag"
        elsif tag == "Sa"
        saytag = "Samstag"
        elsif tag == "So"
        saytag = "Sonntag"
        else
        saytag = "Fehler, Vorsicht!"
    end
    
    say "Euromillionen - Ziehung vom: " + saytag + " den " + datt + "." + datm + "." + datj, spoken: "Euromillionen, Ziehung vom: " + saytag + " den " + datt + "ten " + datm + "ten " + datj
    say "GZ: " + z1 + "  " + z2 + "  " + z3 + "  " + z4 + "  " + z5, spoken: "Gewinnzahlen: " + z1 + ", " + z2 + ",  " + z3 + ",  " + z4 + ",  " + z5
    say "Stern 1: " + s1 + "  Stern 2: " + s2, spoken: "Stern 1, " + s1 + ",  Stern 2, " + s2 + ", "
    say "alle Angaben ohne Gewähr"
end    

request_completed
end


# Lotto numbers austria 6aus45

listen_for /(Lotto|Lottozahlen|Ziehung|Lottoziehung|Lauter|Sechs aus 49|Sex aus 49)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.lottoy.net/de/lotto-oesterreich/rss-feed/aktuelle-lottozahlen-gewinnzahlen-6aus45.xml"))
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        say "Es gab ein Problem beim einlesen der Lotodaten!"
        request_completed
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    docs = doc.xpath('//description')
    datss = docs[1]
    dats =datss.to_s.split
    tag = dats[6].to_s
    tag = tag.delete "&;"
    tag = tag.chop.chop.chop.chop.chop.chop.chop.chop
    tag = tag.reverse
    tag = tag.chop.chop.chop.chop.chop.chop.chop.chop.chop.chop.chop
    tag = tag.reverse
    dat = dats[7]
    dat = dat.chop.chop.chop.chop.chop.chop.chop.chop.chop.chop
    datss = dat.split('.')
    datt = datss[0].to_s
    datm = datss[1].to_s
    datj = datss[2].to_s
    z1 = dats[9].to_s
    z2 = dats[10].to_s
    z3 = dats[11].to_s
    z4 = dats[12].to_s
    z5 = dats[13].to_s
    z6 = dats[14].to_s
    z1 = z1.chop
    z2 = z2.chop
    z3 = z3.chop
    z4 = z4.chop
    z5 = z5.chop
    zz = dats[16].to_s
    jo = dats[18].to_s + dats[19].to_s
    jop = jo
    jo = jo.byteslice(0) + " " + jo.byteslice(1) + " " + jo.byteslice(2) + " " + jo.byteslice(3) + " " + jo.byteslice(4) + " " + jo.byteslice(5)
    jos = jop.split.to_s
    joss = jos[2] + ", " + jos[3] + ", " + jos[4] + ", " + jos[5] + ", " + jos[6] + ", " + jos[7]
    
    if tag == "Montag"
        saytag = "Montag"
        elsif tag == "Dienstag"
        saytag = "Dienstag"
        elsif tag == "Mittwoch"
        saytag = "Mittwoch"
        elsif tag == "Donnerstag"
        saytag = "Donnerstag"
        elsif tag == "Freitag"
        saytag = "Freitag"
        elsif tag == "Samstag"
        saytag = "Samstag"
        elsif tag == "Sonntag"
        saytag = "Sonntag"
        else
        saytag = "Fehler, Vorsicht!"
    end
    
    say "6 aus 45 - Ziehung vom: " + saytag +" den " +datt+ "." + datm +"." + datj, spoken: "6 aus 45, Ziehung vom: " + saytag +" den " +datt+ "ten " + datm +"ten " + datj
    say "GZ: " + z1 +"  "+ z2 +"  "+z3+"  " +z4+"  " +z5+"  " +z6, spoken: "Gewinnzahlen: " + z1 +",  "+ z2 +",  "+z3+",  " +z4+",  " +z5+",  " +z6
    say "ZZ: " + zz + " Joker: " + jo, spoken: "Zusatzzahl: " + zz + ", Tschoker: " + joss
    say "alle Angaben ohne Gewähr"
    
    request_completed
end



end
