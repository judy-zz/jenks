
module Profiler
	class Profile

		@pattern = nil
		@start_times = []
		@stop_times = []
		@count = 0

		def initialize( pattern )
			@pattern = pattern
			@start_times = []
			@stop_times = []
			@count = 0
		end


		def start
			if( @start_times.size != @stop_times.size )
				raise "Profile('#{@pattern}') - start() called with already open start() record."
			end
			@start_times.push Time.now.to_f
		end


		def stop
			if( @start_times.size != @stop_times.size + 1 )
				raise "Profile('#{@pattern}') - stop() called with no open start() record."
			end
			@stop_times.push Time.now.to_f
			@count += 1
		end


		def scale_units( num )
			if 0.001 > num
				return [ num * 1000000, "ns" ]
			elsif 1 > num
				return [ num * 1000, "ms" ]
			elsif 86400 < num
				return [ num / 86400.0, "d" ]
			elsif 3600 < num
				return [ num / 3600.0, "h" ]
			elsif 60 < num
				return [ num / 60.0, "m" ]
			else 
				return [ num, "s" ]
			end
		end


		def report( pattern_width )
			total_diff, count, avg_diff, variance, sdev = [0.0,0.0,0.0,0.0,0.0]
			dump_flag = false;
			min_diff = 99999999999999999999.9;
			max_diff = -99999999999999999999.9;

			if( @count > 0 )
				@count.times do |i|
					if( @stop_times[i] != nil &&  @start_times[i] != nil )
						diff = @stop_times[i] - @start_times[i]
						min_diff = diff < min_diff ? diff : min_diff
						max_diff = diff > max_diff ? diff : max_diff
						total_diff += diff
						count += 1
					end
				end
				avg_diff = total_diff/count
				@count.times do |i|
					if( @stop_times[i] != nil &&  @start_times[i] != nil )
						variance += (( @stop_times[i] - @start_times[i] ) - avg_diff ) ** 2
					end
				end
				variance /= count
				sdev = variance ** 0.5
			end

			dump_flag = avg_diff - 3 * sdev > min_diff ? true : dump_flag;
			dump_flag = avg_diff + 3 * sdev < max_diff ? true : dump_flag;

			total_diff, total_unit = scale_units( total_diff )
			avg_diff, avg_unit = scale_units( avg_diff )
			sdev, sdev_unit = scale_units( sdev )

			report = ""
			if( count > 1 )
				report += "%-#{pattern_width}s %5i * %7.3f %2s = %7.3f %2s %7.3f %2s\n" % [@pattern, count, avg_diff, avg_unit, total_diff, total_unit, sdev, sdev_unit]
			elsif( count > 0 )
				report += "%-#{pattern_width}s %5i * %7.3f %2s = %7.3f %2s\n" % [@pattern, count, avg_diff, avg_unit, total_diff, total_unit]
			else
				report += "%-#{pattern_width}s %s\n" % [@pattern, "    No completed records found"]
			end

			raw_data = ""
			if( dump_flag == true )
				raw_data += dump_data()
			end

			return report, raw_data
		end

		def dump_data
			dump = "Profile.#{self.object_id} exceeded 3 standard deviations{\n"
			dump += "  pattern : '#{@pattern}',\n"
			dump += "  count : '#{@count}',\n"
			dump += "  start_times : #{@start_times.inspect},\n"
			dump += "  stop_times : #{@stop_times.inspect}\n"
			dump += "  diffs : #{@start_times.map.with_index { |x,i| @stop_times[i] - @start_times[i] }}\n"
			dump += "}\n"
		end

		# public :start, :stop, :report, :dump_data
		# private :scale_units

	end
end