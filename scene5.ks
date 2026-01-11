;ティラノスクリプトサンプルゲーム
*start
[eval exp="f.start_serif = 0"]

[cm  ]
[clearfix]
[start_keyconfig]
[bg storage="rouka.jpg" time="100"]

; 勝利数
[eval exp="f.win = 0"]
[eval exp="f.turn = 1"]
[eval exp="f.prev_answer = -1"]

*game_loop
[eval exp="f.nopan_checked = 0"]

; 設定ここから
[bg storage="rouka.jpg" time="100"]
;メニューボタンの表示
@showmenubutton

;メッセージウィンドウの設定
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]

;文字が表示される領域を調整
[position layer=message0 page=fore margint="45" marginl="50" marginr="70" marginb="60"]
;メッセージウィンドウの表示
@layopt layer=message0 visible=true

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" color="white" size=28 bold=true x=180 y=510]

;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]

;このゲームで登場するキャラクターを宣言
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

; ここから
[if exp="f.turn > 3"]
    [jump target="result"]
[endif]

[iscript]
if (f.prev_answer === -1) {
  f.answer = Math.floor(Math.random() * 2);
   // 0:白 1:黒
} else {
  var r = Math.random();
  if (r < 0.7) {
    f.answer = f.prev_answer;       
    // 70%で前回と同じ
  } else {
    f.answer = 1 - f.prev_answer;  
     // 30%で反対
  }
}
f.prev_answer = f.answer;
[endscript]
; ここまで

; 立ち絵（スカート捲り）
[bg storage="rouka.jpg" time="100"]
[chara_show name="akane" face="normal" width="420" height="auto"  left="400" top="0"  time="30" ]

[if exp="f.start_serif == 0"]
  #あかね
  あなた、いきなり来て何バカなこと言ってるの？[p ]
    [eval exp="f.start_serif = 1"]
[endif]

[chara_mod name="akane" face="before"]
#あかね
……何色だと思う？[p ]
[glink text="白"   target="choose_white" size="28"  x="80"  width="200"  y="350"]
[glink text="黒"   target="choose_black" size="28"  x="780"  width="200"  y="350"]
[s]

*choose_white
[eval exp="f.player = 0"]
; ★ ノーパン抽選（例：20%）
[if exp="Math.random() < 0.1"]
  [jump target="nopan"]
[endif]
[jump target="judge"]

*choose_black
[eval exp="f.player = 1"]
; ★ ノーパン抽選（例：20%）
[if exp="Math.random() < 0.1"]
  [jump target="nopan"]
[endif]
[jump target="judge"]

*judge
; ===== 当たり判定 =====
[if exp="f.player == f.answer"]
    [eval exp="f.win += 1"]
    ; 当たり時：選んだ色のパンツ姿
    [if exp="f.answer == 0"]
        [chara_mod name="akane" face="white_pants"]
        @layopt layer=message0 visible=false
        [l ]
    [else]
        [chara_mod name="akane" face="black_pants"]
        @layopt layer=message0 visible=false
        [l ]
    [endif]
    @layopt layer=message0 visible=true
    #あかね
    ……正解[p ]
[else]
    ; ===== ハズレ：パンツ出さず通常立ち絵 =====
    [chara_mod name="akane" face="happy"]
    #あかね
    はずれー[p ]
[endif]
[eval exp="f.turn += 1"]
[jump target="game_loop"]

*result
#
あなたは[emb exp="f.win"]回当てました
[p ]
[jump cond="f.win==3" target="end_all_nude"]
[jump cond="f.win==2" target="end_underwear"]
[jump cond="f.win==1" target="end_topless"]
[jump target="end_fail"]

*end_all_nude
[cm]
[clearfix]
 [chara_mod name="akane" face="doki"]
#あかね
end_all_nude[p ]
[chara_hide name="akane" ]
@layopt layer=message0 visible=false
[jump storage="title.ks"]


*end_underwear
[cm]
[clearfix]
 [chara_mod name="akane" face="doki"]
#あかね
end_underwear[p ]
[chara_hide name="akane" ]
@layopt layer=message0 visible=false
[jump storage="title.ks"]

*end_topless
[cm]
[clearfix]
 [chara_mod name="akane" face="doki"]
#あかね
end_topless[p ]
[chara_hide name="akane" ]
@layopt layer=message0 visible=false
[clearfix]
[jump storage="title.ks"]

*end_fail
[cm]
[clearfix]
 [chara_mod name="akane" face="doki"]
#あかね
end_fail[p ]
[chara_hide name="akane" ]
@layopt layer=message0 visible=false
[clearfix]
[jump storage="title.ks"]

*nopan
[cm]
[clearfix]
 [chara_mod name="akane" face="end_nopan"]
#あかね
nopan[p]
@layopt layer=message0 visible=false
[l ]
[chara_hide name="akane" ]
@layopt layer=message0 visible=true
[image storage="../bgimage/no_panEnd.PNG" ]
#
ノーパンエンド
[l ]
@layopt layer=message0 visible=false
[jump storage="title.ks"]




