---
categories: [compiler]
date: 2021-08-22T13:23:58+09:00
title: "コンパイル時に定数を処理してしまうアレ"
---

κeenです。コンパイル時に定数を処理する最適化技法あるじゃないですか。あれの名称がイマイチはっきりしないのでモヤモヤするなーという記事です。

<!--more-->

## 技法

コンパイル時に定数を処理する最適化技法は色々あるんですがそれらを包括した名称だったり個別の名称だったりがごっちゃになってるのがはっきりしない要因です。
ここでは個別の技法を7つ挙げておきます。

### 技法A

定数と分かっている変数を定数におきかえるやつ

例

```
A = 100;
B = A + 10;
```

↓

```
A = 100;
B = 100 + 10;
```


### 技法B

変数から変数への代入を削除し、代入先の変数への参照を代入元の変数への参照に置き換えるやつ

例

```
A = 100;
B = A;
C = B + 10;
```

```
A = 100;
C = A + 10;
```

### 技法C

条件分岐の条件が定数の場合に条件なしジャンプにするやつ

例

```
if (true) {
  do_something1();
}
else {
  do_something2();
}
```

↓

```
goto THEN;
THEN:
  do_something1();
  goto JOIN;
ELSE:
  do_something2();
JOIN:
```

#### 技法C'

無条件に条件実行されないコードは削除するやつ

例

```
goto THEN;
THEN:
  do_something1();
  goto JOIN;
ELSE:
  do_something2();
JOIN:
```

```
do_something1();
```

### 技法D

定数の値の計算をコンパイラが知っている計算（=プリミティブ）ならしてしまうやつ

例

```
A = 100 + 10;
```

↓

```
A = 110;
```

### 技法E

ユーザが定義した関数を計算してしまうやつ

例

```
add(a, b) { return a + b; }

A = add(100, 10);
```

↓

```
add(a, b) { return a + b; }

A = 110;
```

### 技法F

ユーザが定義した関数に渡る引数が部分的に分かっている場合に部分的に計算した関数を用意するやつ

例

```
add(a, b) { return a + b; }

A = add(x, 10);
```

↓

```
add(a, b) { return a + b; }

add10(a) { return a + 10; }

A = add10(x);
```

### 技法G

ユーザが定義した関数の定義を呼び出し箇所に展開するやつ


例

```
add(a, b) { return a + b; }

A = add(x, 10);
```

↓

```
add(a, b) { return a + b; }

A = x + 10;
```

----

色々話題に上げるためにちょっと細かく分類したり、多めに技法を挙げたりしました。

## 名前

で、何の話題かというと「定数伝播（constant propagation）」とか「定数畳み込み（constant folding）」とか言われているやつです。意外とこれらの呼び分けにゆれがあります。

* Wikipediaは定数畳み込みの見出しがあり、A, B, Dあたりの技法を定数畳み込みと呼んで、そのうちAを定数伝播と呼び分けているような記述になっている [定数畳み込み - Wikipedia](https://ja.wikipedia.org/wiki/%E5%AE%9A%E6%95%B0%E7%95%B3%E3%81%BF%E8%BE%BC%E3%81%BF)
  + その他C, E, Fは技法も紹介しつつも別技術として扱っているよう
* ドラゴンブックは「定数伝播、すなわち"定数の畳み込み"」と両者をほぼ同じものとして扱っている。
  + 書籍中で具体的に定数の畳み込みとして言及があるのは手法A, C, Dを確認。
  + Bはコピー伝播という別の名前で扱っているが、定数伝播の枠組みにも入っている
* タイガーブックはそれぞれ別の名前をつけているが、以下は全て1つのアルゴリズムに統合できるとしている。
  + A - 定数伝播、 B - 複写伝播（copy propagation）、C - 定数条件（constant condition）、C' - 不到達コード（unreachable code）、 D, E - 定数畳み込み

さらっと見た感じドラゴンブックとタイガーブックではFについては言及なさそうでした。Gはまあ、普通はインライン化と呼ばれますね。

## 実際のところ

技法A〜Dまでは同時にできるアルゴリズムが存在するのでユーザの立場からは全部ひとまとめに定数畳み込みや定数伝播と呼んでいいんじゃないですかね。
私個人としては技法Aを定数伝播、A〜Dまでを総括したものを定数"式の"畳み込みと呼びたいなって思ってます。数は畳み込めないんや。

### CTFE？

技法Eは言語によって色々変わるかなと思ってます。

ある立場（主に手続型言語）では関数の呼び出しは本来はコンパイル結果のコードの呼び出しなのでコンパイル中に呼び出すのは特別扱いしてコンパイル時関数呼び出し（compile time function execution, CTFE）と呼ぶもの。
これは実装上は実際にコードを生成して実行したりコンパイラ内にインタプリタを持っていたりします。

もう1つの立場（主に関数型言語）では関数呼び出しはその定義への置き換えとしているので割とカジュアルにコンパイル中にやってしまうもの。
この場合技法D、E、F、Gの区別があまりなく（そもそも引数が1つしかないのでFが存在しない場合も多い）ひっくるめてβ簡約と呼ぶこともある気がします。
実装上はコンパイラが（部分的に）インタプリタを持っていることに相当します。

特にHaskellの場合は純粋かつ遅延評価なので引数が定数か非定数かに関わらずβ簡約してしまえます。
そのことを以って全てを定数畳み込みと呼ぶこともあるようですが、式と簡約済みの値を区別したいなという気持もあり…。

### 部分評価？

技法Fのことを私は部分評価（partial evaluation）や特殊化（specialization）と呼んでたんですがそれぞれもうちょっと広い意味を持っていて特定の最適化技法を指す言葉とは限らなそうでした。
なんか良い名前ないですか。部分適用？あ、因みにこれをカリー化（currying）と呼ぶのは間違いです。

## まとめ

コンパイラ難しい