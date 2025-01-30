# 📸アプリ名：『<a href="https://www.oldcam1700.jp/">OldCam1700</a>』📸
[![Image from Gyazo](https://i.gyazo.com/54ec38747e3e4742e03a46a17b6b96ca.png)](https://gyazo.com/54ec38747e3e4742e03a46a17b6b96ca)
<br>
サービスURL :　https://www.oldcam1700.jp/
<br>

# 目次
- [サービス概要](#-サービス概要)
- [サービス開発の背景](#-サービス開発の背景)
- [機能紹介](#-機能紹介)
- [技術構成について](#-技術構成について)
  - [使用技術](#使用技術)
  - [画面遷移図](#画面遷移図)<br>
<br>

#  ■ サービス概要
〜 オールドコンデジ投稿専用サービス 〜<br>
<br>

『OldCam1700』は、オールドコンデジで撮影した写真を簡単に投稿・共有・閲覧できるサービスです。<br>
日常のワンシーンから特別な瞬間まで、大切な写真を記録として残せます。<br>
自分で撮った写真を投稿するのはもちろん、他のユーザーの投稿を参考にオールドコンデジを購入を考えている人にも役立つプラットフォームです。<br>
<br>

# 📖 サービス開発の背景
自分自身がもともとカメラが好きで、そのなかでもオールドコンデジならではの画質や色味、現代のカメラやスマホにはない独特の雰囲気や味わいを<br>
いろんな人にも楽しんでほしいと考えてこのサービスを作りました。<br>
<br>
オールドコンデジを購入しようとした際、SNSなどで情報を集めましたが、実際の作例を見つけるのは難しく、カメラの写りを比較するのに苦労した経験があります。<br>
カメラ自体の紹介はあっても、「このカメラでどんな写真が撮れるのか」が分かりにくく、購入の決め手に欠けると感じました。<br>
<br>
そこで、「オールドコンデジで撮影した写真や動画を簡単に投稿・閲覧できるサービスがあれば、同じようにオールドコンデジに興味を持つ人に役立つのでは？」と考え、このサービスを開発しました。<br>
購入を考えてない人にも、パッとオールドコンデジの味わいを楽しめるように工夫を取り入れています。<br>
<br>
このプラットフォームを通じて、オールドコンデジの魅力をより多くの人に伝え、気軽に写真を記録・共有できる場を提供したいと考えています。<br>

# 💻 機能紹介

| ユーザー登録 / ログイン |
| :---: | 
| <p align="left">ユーザーは「ユーザーネーム」「メールアドレス」「パスワード」を入力して登録後、ログインしてすぐにサービスを利用できます。<br>また、Googleアカウントでもログイン可能です。</p> |
ユーザー登録
| [![Image from Gyazo](https://i.gyazo.com/7fd003b744905ee3eaab442d948a0c92.png)](https://gyazo.com/7fd003b744905ee3eaab442d948a0c92) |
ログイン
| [![Image from Gyazo](https://i.gyazo.com/3acc53174f360fc086044d9144836010.png)](https://gyazo.com/3acc53174f360fc086044d9144836010) |
<br>

| トップ画面の投稿一覧と検索機能 |
| :---: | 
| <p align="left">トップ画面にユーザーの投稿を一覧表示し、スムーズかつ直感的に楽しめるデザインにしました。思わず自分も投稿したくなるようなレイアウトを意識しています。<br>また、画面上部にはカメラのメーカーや機種を検索できる機能を実装しました。これにより、他のユーザーが**同じカメラで撮影した写真を検索**したり、気になっているカメラの **実際の写りをチェック**することができます。</p> |
| [![Image from Gyazo](https://i.gyazo.com/f6c39a8cd670fbb9853d30524907f7cd.jpg)](https://gyazo.com/f6c39a8cd670fbb9853d30524907f7cd) |

<br>

| 写真・動画投稿機能 |
| :---: | 
| <p align="left">オールドコンデジで撮影した写真や動画をシンプルな項目で簡単にアップロードできます。</p> |
| [![Image from Gyazo](https://i.gyazo.com/bf710475b816b3b514beb4ed110adf89.png)](https://gyazo.com/bf710475b816b3b514beb4ed110adf89) |
<br>

| マイページ機能 |
| :---: | 
| <p align="left">オールドコンデジで撮影した写真や動画をシンプルな項目で簡単にアップロードできます。</p> |
| [![Image from Gyazo](https://i.gyazo.com/44aa4d285eefd66131e1e9c0c49bbbfa.jpg)](https://gyazo.com/44aa4d285eefd66131e1e9c0c49bbbfa) |
| [![Image from Gyazo](https://i.gyazo.com/7a2bb11a1f532fe56bbbd613e780b922.png)](https://gyazo.com/7a2bb11a1f532fe56bbbd613e780b922) |
<br>


# 🔧 技術構成について

## 使用技術
| カテゴリ | 技術内容 |
| --- | --- | 
| サーバーサイド | Ruby on Rails 8.0.0・Ruby 3.3.6 |
| フロントエンド | Ruby on Rails・JavaScript |
| CSSフレームワーク | Bootstrap |
| データベース | MySQL |
| 画像管理 | Simple File Upload |
| バージョン管理ツール | GitHub |
<br>

## 画面遷移図
[画面遷移図-figma](https://www.figma.com/design/Mzy3EBJ1ed9Ws70iMQ7quR/OldCam1700?node-id=242-446&t=hhYpzClxZFVwvtoa-1)  
[![Image from Gyazo](https://i.gyazo.com/51829a3c9a4249cabf91be0f49fd4eed.png)](https://gyazo.com/51829a3c9a4249cabf91be0f49fd4eed)

