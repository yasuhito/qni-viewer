# README

## セットアップ

* Ruby 3.2.2 をインストール (rvm 等お好きなツールで OK)
* 適当なディレクトリに qni-viewer を git clone
* `cd qni-viewer`
* `bundle` (依存するライブラリをインストール)
* `./bin/rails tailwindcss:build` (CSS を生成) 


## 使い方

**シミュレータの起動 (Qni サーバの起動):**
* `./bin/rails server`

**量子回路の表示:**
* ブラウザで `http://localhost:3000` を開いておく

**量子回路の計算をリクエスト:**
* 後述のフォーマットに従って量子回路の JSON を書き、適当なファイルに保存
  * 回路ファイルの例は `examples/` 以下
* `./send_circuit_json [回路ファイル名]`

または、後述するように HTTP リクエストを送信することでも `send_circuit_json` と同様のことができる。


## `send_circuit_json` コマンド実行例

`send_circuit_json` を実行すると、実行結果の状態ベクトルの各要素 (複素数) が計算されて以下のように表示される。

```
$ ./send_circuit_json ./examples/random_bit.json
{"state_vector":[{"real":0.0,"imag":0.0},{"real":1.0000000000000002,"imag":0.0}],"measured_bits":[1]}
```

ブラウザには投入した回路の回路図と実行結果が表示される。

`send_circuit_json` の `--step NUMBER` でステップ番号を指定すると、指定したステップでの状態ベクトルを表示できる。

```
$ ./send_circuit_json ./examples/random_bit.json --step 1
{"state_vector":[{"real":0.7071067811865476,"imag":0.0},{"real":0.7071067811865476,"imag":0.0}],"measured_bits":[]}
```

出力の JSON は、パイプで [jsonpp](https://jmhodges.github.io/jsonpp/) に通すと整形して表示できる。

```
$ ./send_circuit_json ./examples/random_bit.json | jsonpp
{
  "state_vector": [
    {
      "real": 1.0,
      "imag": 0.0
    },
    {
      "real": 0.0,
      "imag": 0.0
    }
  ],
  "measured_bits": [
    0
  ]
}
```

## HTTP リクエストの送信

`send_circuit_json` を実行する代わりに、HTTP リクエストを Qni サーバへ送ることで量子回路計算を実行できる。

HTTP リクエストの送信先 URL は `http://localhost:3000/` で、エンドポイントもこれ 1 つ (回路の実行のみ)。

回路を実行するには、回路を JSON エンコードした文字列をパラメータとして渡す。

###### Example JSON Request

``` json
{
  "circuit_json": "{\"cols\":[[\"|0>\"],[\"H\"],[\"Measure\"]]}"
}
```

たとえば `|0>`、`H` ゲートの後に測定する以下の回路について、

``` text
   ┌───┐┌───┐┌─┐
q: ┤|0>├┤ H ├┤M├
   └───┘└───┘└─┘
```

これを計算するリクエストは次のように cURL で送ることができる:

``` shell
curl -H "accept: application/json" \
       -H "Content-Type: application/json" \
       -d '{"circuit_json": "{\"cols\":[[\"|0>\"],[\"H\"],[\"Measure\"]]}"}' \
       -XGET http://localhost:3000/
```


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


### Phase ゲート
#### 0 ビット目

量子回路:
```
   ┌────────┐
q: ┤ P(π/2) ├
   └────────┘
```

JSON:
`{ circuit_json: '{ "cols": [["P(π/2)"]] }' }`

#### 1 ビット目

量子回路:
```
               
q_0: ──────────
     ┌────────┐
q_1: ┤ P(π/2) ├
     └────────┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "P(π/2)"]] }' }`


### コントロールゲート
#### CNOT (コントロールが下位ビット)

量子回路:
```
q_0: ──■──
     ┌─┴─┐
q_1: ┤ X ├
     └───┘
```

JSON:
`{ circuit_json: '{ "cols": [["•", "X"]] }' }`

#### CNOT (コントロールが上位ビット)

量子回路:
```
     ┌───┐
q_0: ┤ X ├
     └─┬─┘
q_1: ──■──
```

JSON:
`{ circuit_json: '{ "cols": [["X", "•"]] }' }`


### アンチコントロールゲート
#### ACNOT (アンチコントロールが下位ビット)

量子回路:
```
q_0: ──□──
     ┌─┴─┐
q_1: ┤ X ├
     └───┘
```

JSON:
`{ circuit_json: '{ "cols": [["◦", "X"]] }' }`

#### ACNOT (アンチコントロールが上位ビット)

量子回路:
```
     ┌───┐
q_0: ┤ X ├
     └─┬─┘
q_1: ──□──
```

JSON:
`{ circuit_json: '{ "cols": [["X", "◦"]] }' }`


### Swap ゲート

量子回路:
```
q_0: ─X─
      │ 
q_1: ─X─
```

JSON:
`{ circuit_json: '{ "cols": [["Swap", "Swap"]] }' }`


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


### Measure ゲート
#### 0 ビット目

量子回路:
```
   ┌─┐
q: ┤M├
   └─┘
```

JSON:
`{ circuit_json: '{ "cols": [["Measure"]] }' }`

#### 1 ビット目

量子回路:
```
q_0: ───
     ┌─┐
q_1: ┤M├
     └─┘
```

JSON:
`{ circuit_json: '{ "cols": [[1, "Measure"]] }' }`
