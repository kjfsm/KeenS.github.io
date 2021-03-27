---
categories: [yubikey, bitwarden]
date: 2021-03-28T05:33:43+09:00
title: "YubiKeyとBitWardenで安心Web生活"
---

κeenです。最近YubiKeyを買ったので色々試しています。今回はそのうちのWeb認証回です。

<!--more-->

# YubiKeyについて
[YubiKey](https://securitykey.yubion.com)は米瑞企業のYubico社が販売している認証デバイスです。FIDOやらWebAuthnやらの文脈で耳にした方も多いんじゃないしょうか。YubiKeyは日本ではソフト技研社が販売代理店をしています。

YubiKeyはラインナップがいくつかありますが私が買ったのはYubiKey 5 NFCです。

YubiKeyでできることは色々あります。

* FIDO U2F
* FIDO2 / WebAuthn
* Challenge and Response
* OATH-TOTP / OATH-HOTP
* Yubico OTP
* PIV
* OpenPGP
* 静的パスワード

参考：[Yubikey 5をArchLinuxで使う - Qiita](https://qiita.com/onokatio/items/15108b9c199ccf378f91)

このうち今回はFIDO U2F、FIDO/WebAuthn、OATH-TOTP / OATH-HOTPの機能を使います。

# YubiKeyとWeb認証

YubiKey（のうち私の持ってるYubiKey 5）がWebでの認証に持てる役割は3つあります。

* WebAuthn：いわゆるパスワードレスログイン
* FIDO U2F：いわゆるセキュリティキーとしての機能
* OATH-TOTP / OATH-HOTP：いわゆるワンタイムパスワードのキーストア

1番目のWebAuthnについては知ってる方も知らない方もマチマチといったところでしょうか。SSHの公開鍵暗号認証のように公開鍵でWebサービスにログインする仕組みです。YubiKeyはその秘密鍵を保持する役割を持ちます。今回は私はお世話になりませんでした。FIDO2 / WebAuthnについて詳しくはYahooのテックブログなどを参照下さい。

[Yahoo! JAPANでの生体認証の取り組み（FIDO2サーバーの仕組みについて） - Yahoo! JAPAN Tech Blog](https://techblog.yahoo.co.jp/advent-calendar-2018/webauthn/)


2番目のFIDO U2Fは2段階認証のための仕組みです。Webサービスにパスワードで認証を進めたあと、YubiKeyなどのセキュリティキーをNFCにかざしたりUSBに挿したりして2段目の認証をします。パスワードの知識による認証に加えてセキュリティキーの所有による認証を提供することで2要素の認証が実現できます。

3番目のOATH-TOTP / OATH-HOTPはいわゆるワンタイムパスワードに使います。これは対応していないYubiKeyもあるので購入の際は気をつけて下さい。よくスマホでなんちゃらAuthenticatorとかで2次元バーコードを読んで設定しているやつですね。あれはスマホ内にサーバとの共通鍵を保存してます（多分）。その共通鍵を（Yubico Authenticatorを使えば）YubiKeyに保存できるという機能です。Yubico AuthenticatorはデスクトップPC向けにも提供されているのでスマホに依存せず2段階認証が可能になります。スマホを買い替えたり故障したりしても安心ですね。

よく「YubiKeyが使えるサービスが少ない」と言われるのは大抵2番目のセキュリティキーとしての機能についてです。3番目のワンタイムパスワードは多くのサービスが対応しているのでそこまで含めるとYubiKeyが活躍する範囲はかなり広いです。

という訳でYubiKeyのセキュリティキーとワンタイムパスワードの共通鍵ストアとしての機能を使って色々なサービスの安全性を確保しようというのがこの記事の趣旨の1つです。

# Webサービスのトラストチェーン

トラストチェーンという言葉が適切かどうかは分かりませんが適当な用語を思い当たらなかったのでひとまずそう呼びます。それぞれのサービスがどうやって「私であるか」を保証しているかについてです。それに関連して私個人が以前やっていた管理の問題点を挙げつつ説明します。

私はいくつかのサービスのログインにTwitterログインを使っています。この場合、これらのサービスは「このTwitterアカウントを持っている者はκeenである」と定めている訳です。Twitterに本人性の保証を委任してるとも言えます。

![図1](/images/yubikey_and_accounts/fig1.png)


ではTwitterは私のことをどう認証しているかというとGMailのアドレスとパスワードです。しかしパスワードは補助的なもので、emailによるパスワードリセットがあるので実質的にはemailアドレスで認証しています。つまりTwitterは「このemailアドレスを持っている者はκeenである」と定めている訳です。

![図2](/images/yubikey_and_accounts/fig2.png)

ではGMailは私のことをどう認証しているかというとemailアドレス（ID）とパスワードです。このパスワードは覚えている訳ではなくてパスワードマネージャに預けています。具体的にはDropboxに保存したKeePassのDBが担当します。つまり（KeePassのDBにパスワードがあるのである程度間接的にですが）Googleアカウントの安全性はDropboxが担保しています。

![図3](/images/yubikey_and_accounts/fig3.png)


じゃあDropboxアカウントの安全性はというとGMailでアカウントを作っているのでパスワードリセットのことを考えるとGMailが本人性を担保しています（因みにDropboxのパスワードは脳味噌で覚えています）。さらに、Androidを使ってるとGoogleのパスワードマネージャがDropboxを含むいくつかのアカウントのパスワードを記憶してしまっています

![図4](/images/yubikey_and_accounts/fig4.png)


さらに加えて、Firefox Syncのアカウントに記憶させているので実質的にはFirefox Syncのアカウントが破られるとDropboxやGoogle、その他Webサービスのアカウントが掌握されます。因みにFirefox SyncのアカウントははGMailで作ってパスワードはDropbox（に保存したKeePassのDB）管理です。


![図5](/images/yubikey_and_accounts/fig5.png)


ここでグラフに閉路が出てきてしまいましたね。GoogleアカウントかDropboxアカウントかFirefox Syncアカウントのどれかが乗っ取られると私のWebアカウント全体が掌握されてしまいます。死守しないといけないものは少ない方がいいのでどうにかの依存を減らせないでしょうか。さらにおまけを加えると、私のGoogleアカウントにはいつ取得したかも覚えてないフリーメール（死語）のアドレスをバックアップ用のアカウントに設定していました。つまり、そのアカウントが乗っ取られるとGoogleアカウントのパスワードリセットでGoogleアカウントも乗っ取られてしまいます。

![図6](/images/yubikey_and_accounts/fig6.png)

因みにそのフリーメールアカウントにはスパムメールが1日20件くらい届いてます。一番大事にしないといけないアンカーの部分を一番信用ならないものに預けてしまっていますね。このグダグダなWebアカウントの管理を整理してもうちょっと信頼の置けるものにしようというのが今回の趣旨の2つ目です。具体的にはパスワードマネージャをアンカーにして以下のように整理したいです。

![図7](/images/yubikey_and_accounts/fig7.png)

そのためにまず適切なパスワードマネージャを選ぶところからです。

# パスワードマネージャの選定（BitWarden）

パスワードマネージャの選定には多少個人の好みも乗るので先に結論を書くとBitWardenを選びました。以下に選定理由を書きます。

私がパスワードマネージャに求めた要件は以下です。

* トラストアンカーとして使えること
  + ≒ ログインに使ったemailアドレスが掌握されてもアカウントが乗っ取られないこと
* Linuxのデスクトップクライアントがあること
* Androidクライアントがあること
* オフラインでも動くこと
* （可能なら）Firefox向けのアドオンがあること
* アカウントが不意に凍結されないこと

KeePassはDBの共有に別途オンラインアカウントを必要とする点と、スマホから更新したときにDropboxの同期が微妙な点で使うのを止めることにしました。Firefox Syncはでデスクトップクライアントがありません。Googleアカウントはアカウントが不意に凍結されるのでパスワードを預けられません。その他のLastPassなどのパスワードマネージャを検討して、確か1PasswordとBitWardenが候補に残りました。正直どちらでもよかったのですが、BitWardenはオープンソースだったので気休め程度ですが最後の1推しということでBitWardenを採用しました。

BitWardenが要件を満たしているか確認します。

* トラストアンカーとして使えること：メールアドレスでできるのはアカウントのリセット（データ削除）のみで乗っ取りはできない
* Linux、Androidのクライアント：ある
* オフラインでも動くか：動く（多分）
* Firefox向けのアドオン：ある。Firefox for Androidのアドオンもある
* アカウントが不意に凍結されない：不明（凍結された情報はない）
  + アカウントが凍結されてもパスワードのDBは手元に残るので最悪凍結されても大丈夫

良さそうですね。最後の1推しになったオープンソースについて補足しておきます。実際に使っているサービスが企業が説明する仕組み通りに動いているかやバックドアがないかは普通は確かめる術がなく、企業を信頼するしかありません。企業に悪意がなくてもとあるWebサービスで事実誤認でE2Eで暗号化をしてないのにE2E暗号化していると宣伝するケースだってありました。そこに来てオープンソースなら自分の目でコードを読んで安全性を確認できます。さらに、ソースコードがあれば企業側からサポート終了されてもコミュニティで開発を継続できるという利点もあります（特にLinuxはサポート切られがち）。BitWardenはサーバのソースコードも公開していて最悪自分でサーバを立てて運用もできるのでBitWarden社が倒産しても安心ですね。…とは書いたものの実際はコードを読んで自分でビルドしたものを使っているどころか公開されているコードは一読もせずパッケージを使っていますしコードを手元に確保することすらしていません。なので気休め程度ですね。殊勝などこかの誰かが確認してくれていることを信じて使っていきましょう。

# アカウントの大整理

まずはBitWardenのアカウントを作ってKeePass、Firefox Sync、Googleパスワードマネージャに散らばった各種アカウントをBitWardenにまとめます。そのときの作業ログは以下のスクラップにあるので興味のある方は読んでみて下さい。

[bitwardenのセットアップ](https://zenn.dev/blackenedgold/scraps/bb71cb4e218d3c)

ここで問題になるのがGoogleアカウントのバックアップ用に設定していたフリーメール（死語）についてです。代替を用意してフリーメールは解約するとして、代替をどうしましょう。

SMSによるバックアップもありますが、これは基本的には設定しない方がマシです。SMSは権限のあるAndroidアプリなら誰でも読めてしまうのでSMSバックアップを設定していると悪意のあるアプリから簡単にアカウントが乗っ取られます。

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Good morning to everyone except those who think SMS is a secure type of 2FA.</p>&mdash; Yubico | #YubiKey (@Yubico) <a href="https://twitter.com/Yubico/status/1367519412199124994?ref_src=twsrc%5Etfw">March 4, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

考えられる手段はインターネットを契約したときについてくるプロバイダのメールアドレスを設定するか、いっそバックアップを設定しないかかなと思います。プロバイダのメールアドレスは使ったことがなくてイマイチ信用していいのか分からないのでバックアップを設定しない選択をとりました。この辺ベストプラクティスがよく分からないので知っている方いましたら教えて下さい。

あとはそもそも諸々の認証に使うメールアドレスをGMailにしていいのかという問題もあります。Googleは事前告知や説明なくアカウントを凍結することで有名ですし、色々なサービスに紐付いていてどこかでGoogle様の癇に障ったら全てのアクセスを停止されてしまうのでかなりリスクが高いですね。Webアカウント作成用には[ProtonMail](https://protonmail.com)とかの安心して使えるメールアドレスや[SimpleLogin](https://simplelogin.io)とかの元のメールアドレスに依存しないプロキシ使った方がいいのかなという気がしています。とはいえ寄らば大樹の陰って言葉もありますし難しいですね。ひとまず惰性でGMailをそのまま使っていきます。

# YubiKeyによる安全性の強化

ようやくYubiKeyが活躍します。先述のとおりYubiKey 5はセキュリティキーとしての機能とワンタイムパスワードの共通鍵ストアとしての機能があるのでした。それらを使っていきます。セキュリティキーが使えるならセキュリティキーを、使えないならワンタイムパスワードを使うのが推奨されるようです。

基本的にはつらつら設定していくだけなのですが、いくつかポイントを解説しておきます。

## セキュリティキー（FIDO U2F）

いくつかのサービスはセキュリティをサポートしています。大抵の場合はワンタイムパスワードを設定したあとに追加でセキュリティキーを設定するようです。セキュリティキーは設定するときも使うときもセキュリティキーを操作しろとの案内が出るのでYubiKeyの「Y」マークのところに触れると操作ができます。

因みにFirefox on Linuxだとセキュリティキーに対応してますがFirefox for Android (87.0.0)だと対応していませんでした。なのでどのみちU2Fとワンタイムパスワードはセットで設定しないといけないようです。Android版Chromeは対応しているとの噂ですのでChromeユーザは（設定できるなら）ワンタイムパスワードなしでも生きていけるのかもしれません。

トラストチェーンでいくつかハブになっているものがありました。パスワードマネージャや第3者認証（認可）でログインによく使っているTwitterやGitHub、Googleなどでです。幸いにもBitWarden、Twitter、GitHub、Googleは全てFIDO U2Fに対応していました。これで安心してアカウントが使えますね。

![図8](/images/yubikey_and_accounts/fig8.png)

## デスクトップクライアントの使い方

デスクトップクライアントをインストールしておきます。


```shell
sudo apt install yubioauth-desktop
```


あんまり記憶にないのですが、 `pcscd` も必要という記述がWebには転がっていました。必要に応じてインストールして下さい。

セットアップは、YubiKeyをUSBに挿した状態でデスクトップ画面にQRコードを表示して右上の＋を押すと勝手に認識して登録してくれるようです。

デスクトップクライアントを使えばPCでワンタイムパスワードを表示できるのでコピペでワンタイムパスワードが入力できてとても便利です。

## モバイルアプリの使い方

Playストアから[Yubico Authenticator](https://play.google.com/store/apps/details?id=com.yubico.yubioath)をインストールして使います。鍵はYubiKeyにあるのでUSBで挿すかNFCでかざすとワンタイムパスワードが表示されます。新しくワンタイムパスワードを設定するときも同様に挿すかかざすかします。

私はデスクトップPCで信頼して使えるのがUSB Type-Aで、スマホはUSB Type-CだったのでType A + NFCのモデルを買いましたが、PCの方もUSB Type-Cが使えるならUSB Type-Cのみのモデルを買ってもいいかもしれませんね。因みに値段は謎にType A + NFCのモデルが一番安いです。多分ですが口金不要で基盤1枚でできてて作りがシンプルだからですかね？


## リカバリーコードの保存

2段階認証の全てをYubiKeyに預けてしまうのでYubiKeyをうっかり失くしたときに大惨事になりそうです。ですが2段階認証を設定するときはリカバリーコードが発行されるはずなのでそれさえキッチリ管理しておけば問題ありません。リカバリーコードで2段階認証を一時的に外せるのでその間に使って買い直したYubiKeyをセットアップするまでです。

リカバリーコードの適切な管理については、私はGPGで暗号化してUSBメモリに保存し、家の中で安全に管理しています。念のため作業は全てtmpfsの上で行っています。詳細はOpenPGPの記事を参照して下さい。

[YubikeyでOpenPGP鍵をセキュアに使う | κeenのHappy Hacκing Blog](/blog/2021/03/23/yubikeywotsukau_openpghen/)


バックアップ用に2つ目のYubiKeyをセットアップする人もいるようですが、個人的にはセットアップが煩雑になる点、YubiKeyを失くしたらどのみち再設定をしないと安全性が脅かされるのであまり意味がない点、管理しないといけないものが増える点、サービスによっては2つ目のキーを許していない点（認証可能なもの複数があると安全性が下がりますからね）、などから好きじゃないです。


## BitWardenのセットアップ

ちょっとだけBitWardenのセットアップに触れておきます。アカウントは無料でも作れますが、私が今回欲しいFIDO U2Fによる2段階認証は有料プランでないと使えないので納金しました。有料とはいっても年間$10という破格なのでほとんどタダみたいなものです。クライアントによってFIDO U2Fが使えたり使えなかったり色々あるのでワンタイムパスワードの設定も忘れないで下さいね。



BitWardenのアカウントを作るときにマスターパスワードを設定することになりますが、これが実質的なトラストアンカーになるので慎重に設定します。 `words` がだいたい10万語くらいあるので8つ単語を並べると128bit以上の情報量があることになります。

```text
$ cat /usr/share/dict/words | wc -l
102774
$ ruby -e 'p Math.log2(102274 ** 8)'
133.13663924444612
```

wordsからランダムに8語選んで一部は記号や数字に置き換えたり挟んだりすればまあ安全なんじゃないでしょうか。

```text
$ cat /usr/share/dict/words | shuf | head -n 8
derringer
educators
vacationer's
toting
pilgrims
reassert
spy's
demoing
```

あとはこれを打ち損じないように `cat > /dev/null` に何度もタイプ練習して目を瞑っていても打てるようになったら（だいたいパスワード入力は伏せ字になるので）、マスターパスワードに設定しましょう。

# まとめ

YubiKey購入をきっかけに私が行なったWebのログイン周りの整理を紹介しました。トラストアンカーをBitWardenにしてYubiKeyで2段階認証をすることでごちゃごちゃした関係がすっきりしました。BitWardenもYubiKeyもLinuxのクライアントがあるのでLinuxユーザでも便利に使えます。また、YubiKeyを2段階認証に設定することでスマホに依存しなくなるのでスマホの買い替えが楽になりました。
