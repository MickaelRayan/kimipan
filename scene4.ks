*start

[cm  ]
[clearfix]
[start_keyconfig]
[bg storage="rouka.jpg" time="0"]
[eval exp="f.nopan = 0"]

; 設定ここから
@hidemenubutton
;メッセージウィンドウの設定
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore"]
[position layer=message0 page=fore margint="45" marginl="50" marginr="70" marginb="60"]
@layopt layer=message0 visible=true
[ptext name="chara_name_area" layer="message0" color="white" size=28 bold=true x=180 y=510]
[chara_config ptext="chara_name_area"]

;akane
[chara_new  name="akane" storage="chara/akane/normal.png" jname="あかね"  ]
;キャラクターの表情登録
[chara_face name="akane" face="normal" storage="chara/akane/normal.png"]
[chara_face name="akane" face="before" storage="chara/akane/before.png"]
[chara_face name="akane" face="black_pants" storage="chara/akane/black.png"]
[chara_face name="akane" face="white_pants" storage="chara/akane/white.png"]
[chara_face name="akane" face="end_nopan" storage="chara/akane/no_pan.png"]
[chara_face name="akane" face="doki" storage="chara/akane/doki.png"]
[chara_face name="akane" face="happy" storage="chara/akane/happy.png"]
[chara_face name="akane" face="sad" storage="chara/akane/sad.png"]
; 設定ここまで

; 初期化
[eval exp="f.win = 0"]
[eval exp="f.turn = 1"]
[eval exp="f.prev_answer = -1"]

;========================
; キャラ選択
;========================
*select_chara
#
誰で遊ぶ？[p]
[layopt layer="message0" visible="false"]

[locate x=320 y=220]
[button graphic="../fgimage/icon/pic_akane.PNG"  width="300" height="300"   target=*pick_akane]

[locate x=680 y=220]
[button graphic="../fgimage/icon/pic_mio.PNG" width="300" height="300"  target=*pick_mio]
[s]

*pick_akane
[cm]
[layopt layer="message0" visible="true"]
[eval exp="f.chara='akane'"]
[eval exp="f.chara_jname='あかね'"]
[jump target="game_init"]

*pick_mio
[cm]
[layopt layer="message0" visible="true"]
[eval exp="f.chara='mio'"]
[eval exp="f.chara_jname='みお'"]
[jump target="game_init"]


;========================
; 共通初期化
;========================
*game_init
[eval exp="f.turn=0"]         
; 0,1,2 の3回
[eval exp="f.win=0"]
[eval exp="f.tension=0"]
[eval exp="f.prev_answer=-1"]
[jump target="game_loop"]


;========================
; 共通ループ（3回固定）
;========================
*game_loop
[if exp="f.turn >= 3"]
  [jump target="*result_common"]
[endif]

; 次の正解を決める（前回と同じ/反対の確率）
[iscript]
if (f.prev_answer === -1) {
  f.answer = Math.floor(Math.random() * 2); // 0/1
} else {
  var r = Math.random();
  f.answer = (r < 0.7) ? f.prev_answer : (1 - f.prev_answer);
}
f.prev_answer = f.answer;
[endscript]

; 背景・立ち絵（※みお絵を登録したらここを差し替え）
[bg storage="RF_noon.jpg" time="100"]
[chara_show name="akane" face="normal"]

; 初回だけ・キャラ別煽り（turn==0で1回だけ）
[if exp="f.turn == 0 && f.chara=='akane'"]
#あかね
ハァ？パンツを見せろ？[r ]
あなた、いきなり来て何バカなこと言ってるの？[p ]
この私のパンツを見ようなんて、いい度胸してるじゃない。[r ]
[chara_show name="akane" face="normal"]
じゃあ勝負してあげるわ！[p ]
[elsif exp="f.turn == 0 && f.chara=='mio'"]
#みお
え?ぱ、パンツですか？[r ]
今ここで見せろ？[p ]
そ、そそそ……、そんなこと言われましても……[p ]
……[r ]
…………そ、そこまで言うなら……。[p ]
[endif]

; 問題文（2回目以降は共通）
[if exp="f.chara=='akane'"]
#あかね
今履いてるパンツ……、何色だと思う？[p ]
[else]
#みお
じゃあ、私のパンツの色……、当ててみてください……？[p ]
[endif]

; 選択肢（見た目だけキャラ差分）
[if exp="f.chara=='akane'"]
  [glink text="白" target="choose_0" size="28" x="80" width="300" y="250"]
  [glink text="黒" target="choose_1" size="28" x="80" width="300" y="350"]
[else]
  [glink text="ピンク" target="choose_0" size="28" x="80" width="300" y="250"]
  [glink text="ブルー" target="choose_1" size="28" x="80" width="300" y="350"]
[endif]
[s]

*choose_0
[eval exp="f.player=0"]
[cm]
[jump target="judge"]

*choose_1
[eval exp="f.player=1"]
[cm]
[jump target="judge"]


;========================
; 判定（ノーパン→結果→turn++→次へ）
;========================
*judge
[wait time=100]


; ==== ★ パンツ色の確定（ここ）====
[if exp="f.player == f.answer"]
    [eval exp="f.pants_color = f.player"]  ; 当たり → 選んだ色
[else]
    [eval exp="f.pants_color = 1 - f.player"] ; ハズレ → 逆の色
[endif]

; ★ ここでCG・立ち絵を切り替える
[if exp="f.pants_color == 0"]
    [chara_mod name="akane" face="white_pants"]
[else]
    [chara_mod name="akane" face="black_pants"]
[endif]

; ↓ そのあと普通に結果処理
[if exp="f.player == f.answer"]
    [eval exp="f.win += 1"]
    #あかね
    ……正解[p]
[else]
    #あかね
    はずれー[p]
[endif]
; ================

; ノーパン事故（結果台詞の前に割り込み）
[eval exp="f.nopan = (Math.random() < 0.1)"]
[if exp="f.nopan"]
  [chara_mod name="akane" face="doki"]
  [if exp="f.chara=='akane'"]
    #あかね
    …[p ]……[p ]…………っ！[p ]
    [quake count=5 time=200]
    #あかね
    しまったーーー！[r ]
    今、パンツ履いてなかった！！[p ]
    [jump target="end_nopan"]
  [else]
    #みお
    …[p ]……[p ]…………っ！[p ]
    [quake count=5 time=200]
    #みお
    さっき……[r ]
    パンツ、脱いできちゃったんだった……♡[p ]
    はずかしー！！[p ]
    [jump target="end_nopan2"]
  [endif]
[endif]

; テンション加算
[eval exp="f.tension += 1"]

; 正誤
[if exp="f.player == f.answer"]
  [eval exp="f.win += 1"]

  ; テンション演出（必要最低限・共通）
  [if exp="f.tension == 3"]
    [chara_mod name="akane" face="doki"]
    [if exp="f.chara=='akane'"]
      #あかね
      ……今の、ちょっと、嫌な感じ[p ]
    [else]
      #みお
      ……うう[p ]
    [endif]
  [elsif exp="f.tension >= 4"]
    [chara_mod name="akane" face="sad"]
    [if exp="f.chara=='akane'"]
      #あかね
      ……ねえ[p ]……続けるの？[p ]
    [else]
      #みお
      ……まだ[p ]……まだ負けてない[p ]
    [endif]
  [endif]

  [if exp="f.chara=='akane'"]
      [chara_mod name="akane" face="before"]
    #あかね
    ……正解[p ]
  [else]
    #みお
    ……正解[p ]
  [endif]
[else]
  [chara_mod name="akane" face="happy"]
  [if exp="f.chara=='akane'"]
    #あかね
    はずれー[p ]
  [else]
    #みお
    はずれー[p ]
  [endif]
[endif]

; ★ turnは必ずここで1回だけ進める
[eval exp="f.turn += 1"]
[jump target="game_loop"]


;========================
; 結果分岐（ここは1個だけ）
;========================
*result_common
[if exp="f.chara=='mio'"]
  [jump target="result_mio"]
[else]
  [jump target="result_akane"]
[endif]

*result_akane
#
「あなたは[emb exp="f.win"]回当てました」
[p ]
[jump cond="f.win==3" target="end_all_win"]
[jump cond="f.win==2" target="end_win_2"]
[jump cond="f.win==1" target="end_win_1"]
[jump target="end_fail"]

*end_all_win
[chara_hide name="akane"]
[image storage="../bgimage/win3_1.PNG" ]
[quake count=5 time=30]
#あかね
[font size=30]
はぁっ ……、いや ……[r ]
ホントに ……、入れる気？[p ]
#
気がつくと俺はあかねを全裸にひん剥き、愚息を膣口に充てているところだった。[p ]
#あかね
あっ ……、おちんちんおっきぃ ……[p ]
#
じゅぷっ……、じゅぷぷぷぷっ…………♡[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
あかねEND 4 ちんぽに屈服[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]

*end_win_2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
ふん、これで勝ったと思わないでよね！[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
あかねEND 3 おっぱい[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]

*end_win_1
[chara_hide name="akane"]
[image storage="../bgimage/win2.PNG" ]
#あかね
一回だけ？ しょぼ[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
あかねEND 1 パンツ越し[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]

*end_fail
[chara_hide name="akane"]
[image storage="../bgimage/win_zero.PNG" ]
#あかね
おちんちん入れたぁい♡[r ]
残念！[p ]
一度も勝てないような雑魚ちんこなんて、入れませぇん♡[p ]
[font size=40]
ばーかwww[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
あかねEND 2 ばーか[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]

*end_nopan
[chara_hide name="akane"]
[image storage="../bgimage/no_panEnd.PNG" ]
#あかね
わーん！[r ]
これじゃあたし、痴女だー！[p ]

[position layer="message0" opacity="255" ]
#
[font size=40 color=red]
あかねEND5 履いてなかった[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]


*result_mio
#
「あなたは[emb exp="f.win"]回当てました」
[p ]
[jump cond="f.win==3" target="end_all_nude2"]
[jump cond="f.win==2" target="end_underwear2"]
[jump cond="f.win==1" target="end_topless2"]
[jump target="end_fail2"]

*end_all_nude2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
[quake count=5 time=30]
#みお
[font size=30]
……いやぁっーーー！![r ]
服がビリビリだよぉ……！[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
みおEND 4 ビリビリ[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]

*end_underwear2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#みお
ふん、これで勝ったと思わないでよね！[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
みおEND 3 下着[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]

*end_topless2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#みお
一回だけ？ しょぼ[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
みおEND 1 ざぁこ♡[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]

*end_fail2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#みお
ばーか、ばーかw[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
みおEND 2 ばーか[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]

*end_nopan2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#みお
もう……、お嫁に行けない……[p ]

[position layer="message0" opacity="255" ]
#
[font size=40 color=red]
みおEND5 履いてなかった[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene4.ks"]
