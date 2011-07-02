require "open-uri"
require "rubygems"
require "json"
require "time"

src = ''
open("http://tepco-usage-api.appspot.com/latest.json"){|file|
	src = file.read
}

#jsonパーサーを使う
json = JSON.parser.new(src)

#突っ込むためのハッシュ作成
h = Hash.new
h = json.parse()

#電力使用量の計算と返って来た日付をパースする
use_elec = ''
use_elec = h["usage"].to_f / h["capacity"].to_f * 100
t = Time.parse(h["entryfor"])

print "日付 :", t.year,"/", t.month, "/", t.day, "\n"
printf("使用率 : %.2f %\n", use_elec)
print "消費電力 :", h["usage"], "万kW\n"
print "供給可能最大電力 :", h["capacity"], "万kW\n"
print "計画停電 :", h["saving"]?  "実施有り" : "実施無し", "\n"

=begin
#ハッシュの各値の取り出し方
p h["usage"] : この時間帯の消費電力（万kW）
p h["month"] : 月
p h["capacity_updated"] : 供給可能最大電力が決定された日時（UTCなので注意）
p h["hour"] : 月
p h["entryfor"] : この時刻の文字列（UTCなので注意）
p h["day"] : 日
p h["saving"] : この時間帯に計画停電が実施されていればtrue
p h["year"] : 年
p h["capacity"] : 供給可能最大電力（万kW）
p h["capacity_peak_period"] :
最大の供給能力を発揮する予定の時刻（24時間制、日本時間）。
つまり、揚水発電を使って一時的に最大能力を発揮する時刻です。
過去のデータでは、この値が存在しないため「null」です。
p h["usage_updated"] : この消費電力のデータが更新された日時（UTCなので注意）
=end

#ハッシュを全てイテレーターで出力する例
=begin
h.each{|key,value|
	print "#{key}: #{value}\n"
}
=end
