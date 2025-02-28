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

```shell
$ ./send_circuit_json ./examples/random_bit.json
{"state_vector":[{"magnitude":0.0,"phaseDeg":0.0,"real":0.0,"imag":0.0},{"magnitude":1.0000000000000004,"phaseDeg":0.0,"real":1.0000000000000002,"imag":0.0}],"measured_bits":[1]}
```

ブラウザには投入した回路の回路図と実行結果が表示される。

`send_circuit_json` の `--step NUMBER` でステップ番号を指定すると、指定したステップでの状態ベクトルを表示できる。

```shell
$ ./send_circuit_json ./examples/random_bit.json --step 1
{"state_vector":[{"magnitude":0.5000000000000001,"phaseDeg":0.0,"real":0.7071067811865476,"imag":0.0},{"magnitude":0.5000000000000001,"phaseDeg":0.0,"real":0.7071067811865476,"imag":0.0}],"measured_bits":[]}
```

出力の JSON が長くて読みづらい場合、パイプで [jsonpp](https://jmhodges.github.io/jsonpp/) に通すと整形して表示できる。

```shell
$ ./send_circuit_json ./examples/random_bit.json | jsonpp
{
  "state_vector": [
    {
      "magnitude": 0.0,
      "phaseDeg": 0.0,
      "real": 0.0,
      "imag": 0.0
    },
    {
      "magnitude": 1.0000000000000004,
      "phaseDeg": 0.0,
      "real": 1.0000000000000002,
      "imag": 0.0
    }
  ],
  "measured_bits": [
    1
  ]
}
```

## HTTP リクエストの送信

`send_circuit_json` を実行する代わりに、HTTP リクエストを Qni サーバへ送ることで量子回路計算を実行できる。

HTTP リクエストの送信先 URL は `http://localhost:3000/` で、エンドポイントも同じものを 1 つだけ使う (回路の実行のみ)。

実際に HTTP リクエストを送るには、`GET http://localhost:3000/` にクエリパラメータ `circuit_json` として回路を JSON エンコードした文字列を渡す。オプションパラメータとしてステップ番号 `step` を渡すこともできる。もし `step` を指定しない場合は、回路の最後 (右端) まで実行した結果を返す。

### Example JSON Request

``` json
{
  "circuit_json": "{\"cols\":[[\"|0>\"],[\"H\"],[\"Measure\"]]}",
  "step": 1
}
```

この JSON は `|0>`、`H` ゲートの後に測定する以下の回路を表す。

``` text
   ┌───┐┌───┐┌─┐
q: ┤|0>├┤ H ├┤M├
   └───┘└───┘└─┘
```

これを実行するための HTTP リクエストは、たとえば cURL では次のように送れる:

``` shell
$ curl -H "accept: application/json" \
       -H "Content-Type: application/json" \
       -d '{"circuit_json": {"cols":[["|0>"],["H"],["Measure"]]},"step": 1}' \
       -XGET http://localhost:3000/
{"state_vector":[{"magnitude":0.5000000000000001,"phaseDeg":0.0,"real":0.7071067811865476,"imag":0.0},{"magnitude":0.5000000000000001,"phaseDeg":0.0,"real":0.7071067811865476,"imag":0.0}],"measured_bits":[]}
```

状態ベクトルはレスポンスのボディとして取得できる (cURL の実行例↑の最後の行)。

以下に、各ゲートの JSON フォーマットをゲート別に説明する。

## 量子回路の JSON フォーマット

### H ゲート

0 ビット目:

```text
   ┌───┐
q: ┤ H ├
   └───┘
```

JSON:
`{ "cols": [["H"]] }`

1 ビット目:

```text
q_0: ─────
     ┌───┐
q_1: ┤ H ├
     └───┘
```

JSON:
`{ "cols": [[1, "H"]] }`

### X ゲート

0 ビット目:

```text
   ┌───┐
q: ┤ X ├
   └───┘
```

JSON:
`{ "cols": [["X"]] }`

1 ビット目:

```text
q_0: ─────
     ┌───┐
q_1: ┤ X ├
     └───┘
```

JSON:
`{ "cols": [[1, "X"]] }`

### Y ゲート

0 ビット目:

```text
   ┌───┐
q: ┤ Y ├
   └───┘
```

JSON:
`{ "cols": [["Y"]] }`

1 ビット目:

```text
q_0: ─────
     ┌───┐
q_1: ┤ Y ├
     └───┘
```

JSON:
`{ "cols": [[1, "Y"]] }`

### Z ゲート

0 ビット目:

```text
   ┌───┐
q: ┤ Z ├
   └───┘
```

JSON:
`{ "cols": [["Z"]] }`

1 ビット目:

```text
q_0: ─────
     ┌───┐
q_1: ┤ Z ├
     └───┘
```

JSON:
`{ "cols": [[1, "Z"]] }`

### Phase ゲート

0 ビット目:

```text
   ┌────────┐
q: ┤ P(π/2) ├
   └────────┘
```

JSON:
`{ "cols": [["P(1.5707963267948966)"]] }`

1 ビット目:

```text
q_0: ──────────
     ┌────────┐
q_1: ┤ P(π/2) ├
     └────────┘
```

JSON:
`{ "cols": [[1, "P(1.5707963267948966)"]] }`

### コントロールゲート

#### CNOT (コントロールが下位ビット)

```text
q_0: ──■──
     ┌─┴─┐
q_1: ┤ X ├
     └───┘
```

JSON:
`{ "cols": [["•", "X"]] }`

#### CNOT (コントロールが上位ビット)

```text
     ┌───┐
q_0: ┤ X ├
     └─┬─┘
q_1: ──■──
```

JSON:
`{ "cols": [["X", "•"]] }`

### アンチコントロールゲート

#### ACNOT (アンチコントロールが下位ビット)

```text
q_0: ──□──
     ┌─┴─┐
q_1: ┤ X ├
     └───┘
```

JSON:
`{ "cols": [["◦", "X"]] }`

#### ACNOT (アンチコントロールが上位ビット)

```text
     ┌───┐
q_0: ┤ X ├
     └─┬─┘
q_1: ──□──
```

JSON:
`{ "cols": [["X", "◦"]] }`

### Swap ゲート

```text
q_0: ─X─
      │
q_1: ─X─
```

JSON:
`{ "cols": [["Swap", "Swap"]] }`

### |0> ゲート

0 ビット目:

```text
   ┌───┐
q: ┤|0>├
   └───┘
```

JSON:
`{ "cols": [["|0>"]] }`

1 ビット目:

```text
q_0: ─────
     ┌───┐
q_1: ┤|0>├
     └───┘
```

JSON:
`{ "cols": [[1, "|0>"]] }`

### |1> ゲート

0 ビット目:

```text
   ┌───┐
q: ┤|1>├
   └───┘
```

JSON:
`{ "cols": [["|1>"]] }`

1 ビット目:

```text
q_0: ─────
     ┌───┐
q_1: ┤|1>├
     └───┘
```

JSON:
`{ "cols": [[1, "|1>"]] }`

### Measure ゲート

0 ビット目:

```text
   ┌─┐
q: ┤M├
   └─┘
```

JSON:
`{ "cols": [["Measure"]] }`

1 ビット目:

```text
q_0: ───
     ┌─┐
q_1: ┤M├
     └─┘
```

JSON:
`{ "cols": [[1, "Measure"]] }`

### QFT ゲート

```text
     ┌─┐
q_0: ┤ ├
     |Q|
q_1: ┤F├
     |T|
q_2: ┤ ├
     └─┘
```

JSON:
`{ "cols": [["QFT3"]] }`

### Oracle ゲート (グローバー)

```text
     ┌─┐
q_0: ┤ ├
     | |
q_1: ┤O├
     | |
q_2: ┤ ├
     └─┘
```

JSON:
`{ "cols": [["Oracle3"]] }`
