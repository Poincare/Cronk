#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

class Cronk
	def doesnt_exist
		puts ".cronk doesn't exist! Try adding an issue!"
	end

	def show
		if !File::exists?(".cronk")
			doesnt_exist
			return
		end

		cronkf = File.open('.cronk', 'r')
		linenum = 1
		cronkf.each_line do |line|
			puts ((linenum.to_s) + ". " + line)
			linenum += 1

		end
	end

	def remove(rval)
		if !File::exists?(".cronk")
			doesnt_exist
			return
		end

		#tremendous hackjob; can someone simplify this?
		cronkf = File.open('.cronk', 'r')
		res = cronkf.readlines

		res.delete_at (rval-1)

		cronko = File.open('.cronk', 'w')
		res.each do |l|
			cronko.puts l
		end

		puts "Removed issue :)"

		show
	end

	def usage
		puts "Usage: cronk --show || cronk --add ISSUE || cronk --remove NUM"
	end

	def add(issue)
		if !File::exists?(".cronk")
			puts "Made a new .cronk file"
		end

		File.open('.cronk', 'a+') do |f|
			f.puts issue
		end

		puts "Added issue"

		show
	end

	def deal_options(options)

		if options.issue != ""
			add(options.issue)

		elsif options.show
			show
		
		elsif options.remove != 0
			remove(options.remove)

		else 
			usage
		end
	end

	def main
		options = OpenStruct.new 
		options.issue = "" 
		options.show = false
		options.remove = 0

		OptionParser.new do |opts|
			opts.banner = "Usage: cronk [options]"
			
			opts.on("-a", "--add ISSUE", "Add issue") do |issue|
				options.issue = issue
			end

			opts.on('-s', "--show", "Show issues") do |show|
				options.show = show
			end

			opts.on('-r', "--remove ISSUENUM", "Remove issue") do |issuenum|
				options.remove = issuenum.to_i
			end

		end.parse!

		deal_options options
	end
end

cronk = Cronk.new()
cronk.main
