#!/usr/bin/env ruby

readme = File.read("ActionSheetPicker-3.0.podspec")

re = /(\d+\.\d+\.)(\d+)/m

result = re.match(readme)
unless result
	puts "Not found"
	exit
end

pref = result[1]
new_version = result[2].to_i + 1

bumped_vers = pref + new_version.to_s
puts "Bump version: #{result} -> #{bumped_vers}"

def execute_line(line)
	value =%x[#{line}]
	puts value
	if $?.exitstatus != 0
		puts "Error -> terminate"
		exit
	end
end

execute_line("sed -i \"\" \"s/#{result}/#{bumped_vers}/\" README.md")
execute_line("sed -i \"\" \"s/#{result}/#{bumped_vers}/\" ActionSheetPicker-3.0.podspec")
execute_line("git commit --all -m \"Update podspec to version #{bumped_vers}\"")
execute_line("git tag #{bumped_vers}")
execute_line("git push")
execute_line("git push --tags")
execute_line("pod trunk push ./ActionSheetPicker-3.0.podspec")