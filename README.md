## 動かし方

* yarnが必須です。入れてね。
* settings.ymlとdatabase.ymlを作ってね。mysqlのアダプターはtrilogyだよ
* credentials.yml.encを削除してEDITOR=vi bundle exec rails credentials:editを実行してね
* あとはプリコンパイルしたりパッケージ入れたりすればうまくいくと思うよ

settings.ymlについて
サンプル
```
reward:
  webhook: [webhookのURL]  # 報酬履歴作成時に送信されるよ
```