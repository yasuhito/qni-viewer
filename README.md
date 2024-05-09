# README

## セットアップ

* Ruby 2.7.4 をインストール (rvm 等お好きなツールで OK)
* 適当なディレクトリに qni-viewer を git clone
* `cd qni-viewer`
* `bundle` (依存するライブラリをインストール)
* `./bin/rails server` (起動)


## 使い方

* ブラウザで `http://localhost:3000` を開く
*  Qni で好きな回路を作り、URL 後半の文字列 (`%7B%22cols%22...` みたいなもの) をコピー
* `./send_circuit_json [コピーした文字列]`

## 実行例

`send_circuit_json` を実行すると、実行結果の状態ベクトルの各要素 (複素数) が計算されて以下のように表示される。

```
$ ./send_circuit_json %7B%22cols%22%3A%5B%5B%22H%22%2C1%2C%22H%22%5D%5D%7D
[{"real":0.4999999999999999,"imag":0.0},{"real":0.4999999999999999,"imag":0.0},{"real":0.0,"imag":0.0},{"real":0.0,"imag":0.0},{"real":0.4999999999999999,"imag":0.0},{"real":0.4999999999999999,"imag":0.0},{"real":0.0,"imag":0.0},{"real":0.0,"imag":0.0}]
```

ブラウザには投入した回路の回路図と実行結果が表示される。
