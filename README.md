# Launch version 2
今後のLaunchで改善すべきことを掲載します。

## Todo
#### 1. 投稿済みの記事と下書き中の記事を異なるモデルで管理する。
同じモデルで管理すると投稿済みの記事と下書き中の記事を意識して機能を追加する手間がかかった。

記事の自動保存機能を実装すると、下書き中の記事もバリデーションを実行されてしまうため、ユーザーに不便であることが考えられる。そのため、投稿済みの記事と下書き中の記事のモデルを分けることでUXの改善が可能になると思われる。

#### 2. タグ機能の追加
