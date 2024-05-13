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


## 量子回路の JSON フォーマット

### H ゲート
#### 0 ビット目

量子回路:
```
   ┌───┐
q: ┤ H ├
   └───┘
```

JSON:
`{ circuit_json: '{ "cols": [["H"]] }' }`

#### 1 ビット目

量子回路:
```
q_0: ─────
     ┌───┐
q_1: ┤ H ├
     └───┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "H"]] }' }`


### X ゲート
#### 0 ビット目

量子回路:
```
   ┌───┐
q: ┤ X ├
   └───┘
```

JSON:
`{ circuit_json: '{ "cols": [["X"]] }' }`

#### 1 ビット目

量子回路:
```
q_0: ─────
     ┌───┐
q_1: ┤ X ├
     └───┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "X"]] }' }`


### Y ゲート
#### 0 ビット目

量子回路:
```
   ┌───┐
q: ┤ Y ├
   └───┘
```

JSON:
`{ circuit_json: '{ "cols": [["Y"]] }' }`

#### 1 ビット目

量子回路:
```
q_0: ─────
     ┌───┐
q_1: ┤ Y ├
     └───┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "Y"]] }' }`


### Z ゲート
#### 0 ビット目

量子回路:
```
   ┌───┐
q: ┤ Z ├
   └───┘
```

JSON:
`{ circuit_json: '{ "cols": [["Z"]] }' }`

#### 1 ビット目

量子回路:
```
q_0: ─────
     ┌───┐
q_1: ┤ Z ├
     └───┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "Z"]] }' }`


### |0> ゲート
#### 0 ビット目

量子回路:
```
   ┌───┐
q: ┤|0>├
   └───┘
```

JSON:
`{ circuit_json: '{ "cols": [["|0>"]] }' }`

#### 1 ビット目

量子回路:
```
q_0: ─────
     ┌───┐
q_1: ┤|0>├
     └───┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "|0>"]] }' }`


### |1> ゲート
#### 0 ビット目

量子回路:
```
   ┌───┐
q: ┤|1>├
   └───┘
```

JSON:
`{ circuit_json: '{ "cols": [["|1>"]] }' }`

#### 1 ビット目

量子回路:
```
q_0: ─────
     ┌───┐
q_1: ┤|1>├
     └───┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "|1>"]] }' }`


### Measurement ゲート
#### 0 ビット目

量子回路:
```
   ┌─┐
q: ┤M├
   └─┘
```

JSON:
`{ circuit_json: '{ "cols": [["Measurement"]] }' }`

#### 1 ビット目

量子回路:
```
q_0: ───
     ┌─┐
q_1: ┤M├
     └─┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "Measurement"]] }' }`
