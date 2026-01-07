;ティラノスクリプトサンプルゲーム
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
[chara_face name="akane" face="angry" storage="chara/akane/angry.png"]
[chara_face name="akane" face="doki" storage="chara/akane/doki.png"]
[chara_face name="akane" face="happy" storage="chara/akane/happy.png"]
[chara_face name="akane" face="sad" storage="chara/akane/sad.png"]
; 設定ここまで

; 初期化
[eval exp="f.win = 0"]
[eval exp="f.turn = 1"]
[eval exp="f.prev_answer = -1"]


; キャラを選ぶ
[jump target="select_chara"]
; セレクト画面ここから
;メッセージウィンドウの設定
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore"]

;文字が表示される領域を調整
[position layer=message0 page=fore margint="45" marginl="50" marginr="70" marginb="60"]
;メッセージウィンドウの表示
@layopt layer=message0 visible=true

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" color="white" size=28 bold=true x=180 y=510]
*select_chara


#
誰で遊ぶ？[p]
; メッセージウィンドウを一旦消す（レイアウト干渉を避ける）
[layopt layer="message0" visible="false"]

[locate x=320 y=220]
[button graphic="../fgimage/icon/onigiri.png"  width="300" height="300"   target=*pick_akane]

[locate x=680 y=220]
[button graphic="../fgimage/icon/donuts.png" width="300" height="300"  target=*pick_mio]
[s]


共通ルート[l]
; [glink text="あかね" target="pick_akane" ]
; [glink text="みお"   target="pick_mio"]
; [s]

*pick_akane
[cm]  
[layopt layer="message0" visible="true"]

[eval exp="f.turn = 0"]
[eval exp="f.chara = 'akane'"]
[eval exp="f.chara_jname = 'あかね'"]
; ===== 緊張値初期化 =====
[eval exp="f.turn=0"]
[eval exp="f.win=0"]
[eval exp="f.tension=0"]
[eval exp="f.nopan=false"]
[eval exp="f.nopan_lock=0"]
; ===== 緊張値初期化ここまで =====

[jump target="game_loop"]

*pick_mio
[cm]  
[layopt layer="message0" visible="true"]

[eval exp="f.chara = 'mio'"]
[eval exp="f.chara_jname = 'みお'"]
; ===== 緊張値初期化 =====
[eval exp="f.turn=0"]
[eval exp="f.win=0"]
[eval exp="f.tension=0"]
[eval exp="f.nopan=false"]
[eval exp="f.nopan_lock=0"]
; ===== 緊張値初期化ここまで =====

[jump target="game_loop2"]
; セレクト画面ここまで

*game_loop
[if exp="f.turn >= 3"]
    [jump target="result"]
[endif]

[iscript]
if (f.prev_answer === -1) {
  f.answer = Math.floor(Math.random() * 2); // 0:白 1:黒
} else {
  var r = Math.random();
  if (r < 0.7) {
    f.answer = f.prev_answer;       // 70%で前回と同じ
  } else {
    f.answer = 1 - f.prev_answer;   // 30%で反対
  }
}
f.prev_answer = f.answer;
[endscript]
; ここまで

; 立ち絵（スカート捲り）
[bg storage="rouka.jpg" time="100"]
[chara_show name="akane" face="happy"]

[if exp="f.turn == 0"]
#あかね
この私のパンツを見ようなんて、いい度胸してるじゃない。[r ]
じゃあ勝負してあげるわ！[p ]
[endif]

#あかね
今履いてるパンツ……、何色だと思う？[p ]

[glink text="白"   target="choose_white" size="28"  x="80"  width="300"  y="250"]
[glink text="黒"   target="choose_black" size="28"  x="80"  width="300"  y="350"]
[s]

*choose_white
[eval exp="f.player = 0"]
[cm ]
[jump target="judge"]

*choose_black
[eval exp="f.player = 1"]
[cm ]
[jump target="judge"]

*judge
[wait time=100] 
; 1ターンにつき1回だけ増やす
; [if exp="f.nopan_lock == 1"]
;     [jump target="judge_main"]
; [endif]
; [eval exp="f.nopan_lock = 1"]

; --- ノーパン事故を「結果台詞の前」に判定＆割り込み ---
[eval exp="f.nopan = (Math.random() < 0.1)"]
[if exp="f.nopan"]
    [chara_mod name="akane" face="normal"]
    #あかね
    …[p ]
    ……[p ]
    …………っ！[p ]
    [quake count=5 time=200]
    #あかね
    しまったーーー！[r ]
    今、パンツ履いてなかった！！[p ]
    [jump target="end_nopan"]
[endif]
; [eval exp="f.turn += 1"]
; [jump target="game_loop"]
; --- ここまで ---

; *judge_main
[eval exp="f.tension += 1"]

[if exp="f.player == f.answer"]
    [eval exp="f.win += 1"]

; --- テンション演出（結果台詞の前に挟む） ---
[if exp="f.tension == 2"]
    ; 1回目：まだ軽い（何もしないでもOK）
; [elsif exp="f.tension == 3"]
    [chara_mod name="akane" face="sad"]
    #あかね
    ……今の、ちょっと、嫌な感じ[p ]
[elsif exp="f.tension >= 3"]
    [chara_mod name="akane" face="normal"]
    #あかね
    ……ねえ[p ]
    ……続けるの？[p ]
[endif]
; ---------------------------------------------
    #あかね
    ……正解[p ]
[else]
    [chara_mod name="akane" face="happy"]
    #あかね
    はずれー[p ]

    [if exp="f.tension >= 2"]
        #あかね
        ……今の、ちょっと危なかった気がする[p ]
    [endif]
[endif]

[eval exp="f.turn += 1"]
[jump target="game_loop"]
; [eval exp="f.nopan_lock = 0"]

*result
#
「あなたは[emb exp="f.win"]回当てました」
[p ]
[jump cond="f.win==3" target="end_all_nude"]
[jump cond="f.win==2" target="end_underwear"]
[jump cond="f.win==1" target="end_topless"]
[jump target="end_fail"]

*end_all_nude
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
[quake count=5 time=30]
#あかね
[font size=30]
……いやぁっーーー！![r ]
服がビリビリだよぉ……！[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
あかねEND 4 ビリビリ[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*end_underwear
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
ふん、これで勝ったと思わないでよね！[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
あかねEND 3 下着[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*end_topless
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
一回だけ？ しょぼ[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
あかねEND 1 ざぁこ♡[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*end_fail
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
ばーか、ばーかw[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
あかねEND 2 ばーか[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*end_nopan
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
わーん！[r ]
これじゃあたし、痴女だー！[p ]

[position layer="message0" opacity="255" ]
#
[font size=40 color=red]
あかねEND 4 履いてなかった[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*game_loop2
[bg storage="room.jpg" time="100"]
[chara_show name="akane" face="happy"]
#あかね
ループ2です[p ]

[if exp="f.turn >= 3"]
    [jump target="result"]
[endif]

[iscript]
if (f.prev_answer === -1) {
  f.answer = Math.floor(Math.random() * 2); // 0:白 1:黒
} else {
  var r = Math.random();
  if (r < 0.7) {
    f.answer = f.prev_answer;       // 70%で前回と同じ
  } else {
    f.answer = 1 - f.prev_answer;   // 30%で反対
  }
}
f.prev_answer = f.answer;
[endscript]
; ここまで

; 立ち絵（スカート捲り）
[bg storage="rouka.jpg" time="100"]
[chara_show name="akane" face="happy"]

[if exp="f.turn == 0"]
#あかね
ふん、雑魚が！[p ]
[endif]

#あかね
今履いてるパンツ……、何色だと思う？[p ]

[glink text="白"   target="choose_pink" size="28"  x="80"  width="300"  y="250"]
[glink text="黒"   target="choose_border" size="28"  x="80"  width="300"  y="350"]
[s]

*choose_pink
[eval exp="f.player = 0"]
[cm ]
[jump target="judge2"]

*choose_border
[eval exp="f.player = 1"]
[cm ]
[jump target="judge2"]

*judge2
[wait time=100] 

; --- ノーパン事故を「結果台詞の前」に判定＆割り込み ---
[eval exp="f.nopan = (Math.random() < 0.1)"]
[if exp="f.nopan"]
    [chara_mod name="akane" face="normal"]
    #あかね
    …[p ]
    ……[p ]
    …………っ！[p ]
    [quake count=5 time=200]
    #あかね
    しまったーーー！[r ]
    今、パンツ履いてなかった！！[p ]
    [jump target="end_nopan"]
[endif]
; --- ここまで ---

; *judge_main2
[eval exp="f.tension += 1"]

[if exp="f.player == f.answer"]
    [eval exp="f.win += 1"]

; --- テンション演出（結果台詞の前に挟む） ---
[if exp="f.tension == 2"]
    ; 1回目：まだ軽い（何もしないでもOK）
; [elsif exp="f.tension == 3"]
    [chara_mod name="akane" face="sad"]
    #あかね
    ……うう[p ]
[elsif exp="f.tension >= 3"]
    [chara_mod name="akane" face="normal"]
    #あかね
    ……まだ[p ]
    ……まだ負けてない[p ]
[endif]
; ---------------------------------------------
    #あかね
    ……正解[p ]
[else]
    [chara_mod name="akane" face="happy"]
    #あかね
    はずれー[p ]

    [if exp="f.tension >= 2"]
        #あかね
        ……今の、ちょっと危なかった気がする[p ]
    [endif]
[endif]

[eval exp="f.turn += 1"]
[jump target="game_loop"]


*result2
#
「あなたは[emb exp="f.win"]回当てました」
[p ]
[jump cond="f.win==3" target="end_all_nude2"]
[jump cond="f.win==2" target="end_underwear2"]
[jump cond="f.win==1" target="end_topless2"]
[jump target="end_fail"]

*end_all_nude2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
[quake count=5 time=30]
#あかね
[font size=30]
……いやぁっーーー！![r ]
服がビリビリだよぉ……！[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
END 4 ビリビリ[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*end_underwear2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
ふん、これで勝ったと思わないでよね！[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
END 3 下着[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*end_topless2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
一回だけ？ しょぼ[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
END 1 ざぁこ♡[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*end_fail2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
ばーか、ばーかw[p ]

[position layer="message0" opacity="255"]
#
[font size=40 color=red]
END 2 ばーか[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]

*end_nopan2
[chara_hide name="akane"]
[image storage="../bgimage/room.jpg" ]
#あかね
あ[p ]

[position layer="message0" opacity="255" ]
#
[font size=40 color=red]
END 4 履いてなかった[p ]
; ★ 元に戻す（次のループやタイトル用）
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true  page="fore" opacity="128" ]
[jump storage="scene2.ks"]