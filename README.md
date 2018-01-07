<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. TeamGradings</a>
<ul>
<li><a href="#sec-1-1">1.1. help</a></li>
</ul>
</li>
<li><a href="#sec-2">2. FILES</a></li>
<li><a href="#sec-3">3. team gradingの仕方</a>
<ul>
<li><a href="#sec-3-1">3.1. initial</a></li>
<li><a href="#sec-3-2">3.2. 日常手順</a></li>
<li><a href="#sec-3-3">3.3. final score</a></li>
<li><a href="#sec-3-4">3.4. Installation</a></li>
</ul>
</li>
</ul>
</div>
</div>


# TeamGradings<a id="sec-1" name="sec-1"></a>

procedures for team gradings

## help<a id="sec-1-1" name="sec-1-1"></a>

    Commands:
      team_grading count           # count members in Group.list
      team_grading final           # mk final scores
      team_grading group           # edit group list
      team_grading help [COMMAND]  # Describe available commands or one specific command
      team_grading initial         # setup initial files on the upstream
      team_grading list            # list group name
      team_grading report          # score report
      team_grading speaker         # score speakers
      team_grading upload          # upload tables

# FILES<a id="sec-2" name="sec-2"></a>

初期ファイルとして，
\`\`\`
./.team\_gradings
./Group.list
./Report.tsv
./Speaker.list
\`\`\`

# team gradingの仕方<a id="sec-3" name="sec-3"></a>

## initial<a id="sec-3-1" name="sec-3-1"></a>

1.  科目の名前(hikiのfile名)を./.team\_gradingsに置く
2.  Group.listを作成

## 日常手順<a id="sec-3-2" name="sec-3-2"></a>

1.  team\_grading report
2.  team\_grading speaker
3.  team\_grading upload
4.  hiki sync

## final score<a id="sec-3-3" name="sec-3-3"></a>

1.  個人成績をfinal\_exam.csvに記録(no, score\n, &#x2026;)
2.  team\_grading final
    1.  final\_greoup\_results.csv:bonusを追加して，group成績を確定．uploadに回す
    2.  personal\_results.csv:個人成績とgroup成績とgroup最終成績を出力
3.  luna sheetに登録
4.  upload

## Installation<a id="sec-3-4" name="sec-3-4"></a>

Add this line to your application's Gemfile:

    gem 'team_gradings'

And then execute: `$ bundle`

Or install it yourself as: `$ gem install team_gradings`
