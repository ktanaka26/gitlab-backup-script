# GitLab Backup Script
実行される度にGitLabのバックアップコマンドを実行し、吐き出されたバックアップデータtarファイルをbzipで圧縮後、Google Driveまでアップロードします。

## 使い方
### gdriveのインストール
Google Driveへのアップロードに[gdrive](https://github.com/prasmussen/gdrive)を使用しているため、あらかじめインストールしておいてください。

### Directory IDの取得
gdriveのページを参考に、Google DriveにおけるDirectory IDを取得し、ソースコード内に記述してください。

### cronへの登録
cronに登録することで、決まったタイミングでバックアップを行うことができます。以下は研究室で使用している毎朝5時に動作する例です。

`# 0 5 * * * /usr/local/bin/gitlab-backup.sh 1>> /usr/local/log/gitlab-backup-cron.log 2>> /usr/local/log/gitlab-backup-cron-error.log
`

## 補足
ソースコード内ではgdriveはPATHが通っている場所に設置することを前提としていますが、修正箇所としては1行なので任意の場所に設置後、絶対パスで指定することで同じ動きができます。

## メモ
研究室で構築、運用しているGitLabのバックアップに使用しています。
ログの整形のために`echo`を多用しています。
