# 出力結果を整える
begin
  require 'awesome_print'
  Pry.config.print = proc { |output, value| output.puts value.ai }
rescue LoadError
  $stderr.puts "You should execute 'gem install awesome_print''"
end

# ActiveRecord の結果を mysql コンソールのテーブル出力っぽく整える
begin
  require 'hirb'
  require 'hirb-unicode'
rescue LoadError
  $stderr.puts "You should execute 'gem install hirb''"
end
if defined? Hirb
  Hirb::View.instance_eval do
    def enable_output_method
      @output_method = true
      @old_print = Pry.config.print
      Pry.config.print = proc do |*args|
        Hirb::View.view_or_page_output(args[1]) || @old_print.call(*args)
      end
    end

    def disable_output_method
      Pry.config.print = @old_print
      @output_method = nil
    end
  end

  Hirb.enable
end
