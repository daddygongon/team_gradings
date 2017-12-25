# -*- coding: utf-8 -*-
require "team_gradings/version"
require 'thor'
require 'date'
require 'fileutils'
require "team_gradings/mk_score"
require "team_gradings/final_score"


module TeamGradings
  class CLI < Thor
    desc 'list', 'list group name'
    def list
      File.readlines(File.join('..',"Group.list")).each do |line|
        next if line =~ /^\#/
        puts line.split(',')[0]
      end
    end

    desc 'initial', 'setup initial files on the upstream'
    def initial
      read_target
      p @target_file
      ["Group.list","Report.tsv","Speaker.list"].each do |file|
        next if File.exists?(File.join('..',file))
        FileUtils.cp(File.join('templates',file), '..', verbose: true)
      end
      exit
    end

    desc 'count', 'count members in Group.list'
    def count
      sum = 0
      File.readlines('../Group.list').each do |line|
        next if line.match(/^#/)
        p line.chomp.split(',')[1]
        p num = line.split(',')[1].split(' ').size
        sum += num
      end
      print sum

      exit
    end

    desc 'final', 'mk final scores'
    def final
      upload
      #      system "./lib/final_score3.rb"
      MkGroups.new
      target_dir = "/Users/bob/Sites/new_ist_data/ist_data"
      system "./trans_hiki.rb < tmp3.csv > #{@target_file}"
      system "sudo cp #{@target_file} #{target_dir}/text"
      system "sudo chown _www #{target_dir}/text/#{@target_file}"
      system "sudo rm #{target_dir}/cache/parser/#{@target_file}"
      system "open -a safari http://localhost/ist/?#{@target_file}"
    end

    desc 'upload', 'upload tables'
    def upload
      read_target

      tmp_csv = MkScore.print
      system "ruby ./abc_to_321.rb < tmp.csv > tmp2.csv"
      system "./trans_hiki.rb < tmp2.csv > #{@target_file}"
      target_dir = "/Users/bob/Sites/new_ist_data/ist_data"
#      target_file = "ModelPhysTeamScore17"
      system "sudo cp #{@target_file} #{target_dir}/text"
      system "sudo chown _www #{target_dir}/text/#{@target_file}"
      system "sudo rm #{target_dir}/cache/parser/#{@target_file}"
      system "open -a safari http://localhost/ist/?#{@target_file}"
#      system "rm tmp.csv ModelingPhys.csv" # leave csvs for final_score2.rb
    end

    desc 'speaker', 'score speakers'
    def speaker(*argv)
      date = argv[0] || Date.today.strftime("%m/%d")
      print_speaker_list(date)
      system "open -a mi ./Speaker.list"
    end

    desc 'report', 'score report'
    def report
      system "open ./Report.tsv"
    end

    desc 'group', 'edit group list'
    def group
      system "emacs ./Group.list"
    end

    no_commands{
      def read_target()
        begin
          @target_file = File.read("./.team_gradings")
        rescue
          puts "input target_file of hiki"
          @target_file = STDIN.gets.chomp #"NumRecipeScore17"
          File.open("./.team_gradings",'w'){|f| f.print @target_file}
        end
      end
      def print_speaker_list(date)
        File.readlines(File.join('..',"Group.list")).each do |line|
          next if line =~ /^\#/
          print "#{date} #{line.split(/,/)[0]}\n"
        end
      end
    }
  end

end

