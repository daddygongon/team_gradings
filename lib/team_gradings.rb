# -*- coding: utf-8 -*-
require 'team_gradings/version'
require 'thor'
require 'date'
require 'fileutils'
require 'team_gradings/group'
require 'team_gradings/mk_score'
require 'team_gradings/abc_to_321'
require 'team_gradings/trans_hiki'
require 'team_gradings/final_score'

module TeamGradings
  # cli for team gradings
  class CLI < Thor
    desc 'list', 'list group name'
    def list
      File.readlines(File.join('..', 'Group.list')).each do |line|
        next if line =~ /^\#/
        puts line.split(',')[0]
      end
    end

    desc 'initial', 'setup initial files on the upstream'
    def initial
      read_target
      p @target_file
      ['Group.list', 'Report.tsv', 'Speaker.list'].each do |file|
        next if File.exist?(File.join('.', file))
        FileUtils.cp(File.join('templates', file), '.', verbose: true)
      end
      exit
    end

    desc 'final_score', 'mk final scores'
    def final_score
      upload
      FinalScore.new
      group_csv = File.read('final_group_results.csv')
      File.open(@target_file, 'w') do |file|
        file.print(TransHiki.new(group_csv).conts)
      end
      upload_to_hiki
    end

    desc 'upload', 'upload tables'
    def upload
      read_target
      weekly_table = MkScore.new.print_score_table
      table_with_scores = TransABCTo321.new(weekly_table).conts
      File.open('./bonus_table.csv', 'w') { |file| file.print(table_with_scores) }
      File.open(@target_file, 'w') do |file|
        file.print(TransHiki.new(table_with_scores).conts)
      end
      upload_to_hiki
    end

    desc 'speaker', 'score speakers'
    def speaker(*argv)
      date = argv[0] || Date.today.strftime('%m/%d')
      print_speaker_list(date)
      system 'open -a mi ./Speaker.list'
    end

    desc 'report', 'score report'
    def report
      system 'open ./Report.tsv'
    end

    desc 'group', 'edit group list'
    def group
      system 'emacs ./Group.list'
    end

    no_commands do
      def upload_to_hiki
        system "sudo cp #{@target_file} #{@target_dir}/text"
        system "sudo chown _www #{@target_dir}/text/#{@target_file}"
        system "sudo rm #{@target_dir}/cache/parser/#{@target_file}"
        system "open -a safari http://localhost/ist/?#{@target_file}"
      end

      def read_target
        @target_dir = '/Users/bob/Sites/new_ist_data/ist_data'
        begin
          @target_file = File.read('./.team_gradings')
        rescue
          puts 'input target_file of hiki'
          @target_file = STDIN.gets.chomp # "NumRecipeScore17"
          File.open('./.team_gradings', 'w') { |f| f.print @target_file }
        end
      end

      def print_speaker_list(date)
        File.readlines(File.join('.', 'Group.list')).each do |line|
          next if line =~ /^\#/
          print "#{date} #{line.split(/,/)[0]}\n"
        end
      end
    end
  end
end
