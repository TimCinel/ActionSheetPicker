#!/usr/bin/env ruby

readme = File.read("README.md")

re = /(\d+\.\d+\.)(\d+)/m

result = re.match(readme)
puts result
unless result
	puts "Not found"
	exit
end

pref = result[1]
new_version = result[2].to_i + 1

bumped_vers = pref + new_version.to_s
puts bumped_vers

`sed -i "" "s/#{result}/#{bumped_vers}/" README.md`
`sed -i "" "s/#{result}/#{bumped_vers}/" ActionSheetPicker-3.0.podspec`
`git commit --all -m "Update podspec"`
`git tag #{bumped_vers}`
`git push`
`pod trunk push ./ActionSheetPicker-3.0.podspec`