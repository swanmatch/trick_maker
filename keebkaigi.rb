require 'rainbow'

def hsv_to_rgb(h, s, v)
  # hは[0, 360)の範囲に収まる
  # s, vは[0, 100]の範囲に収まる
  h = (h%360)
  s = (s%101) / 100.0
  v = (v%101) / 100.0

  h_i = (h / 60.0).floor % 6
  f = (h / 60.0) - h_i
  p = v * (1 - s)
  q = v * (1 - f * s)
  t = v * (1 - (1 - f) * s)

  case h_i
  when 0
    r, g, b = v, t, p
  when 1
    r, g, b = q, v, p
  when 2
    r, g, b = p, v, t
  when 3
    r, g, b = p, q, v
  when 4
    r, g, b = t, p, v
  when 5
    r, g, b = v, p, q
  end

  r = (r * 255).round
  g = (g * 255).round
  b = (b * 255).round

  [r, g, b]
end


STR = <<EOS
                                                                                               J@
                 (,                       ..,                                                .M3
                -F                    ..gH"'                                                .#`                ..                        ..,                 ..,......                        .........
               .@                `..gMD!                                                  .MN}                 dD                    ..g#"!        .N,       _F     ((                        :F     (<
              .#              ..MMNWNr                                                   .MqM:                JF                 ..kM"!             ,MN,     ~ Mud,W~.                        ! Mud,d:
             .MN,         .-MMNNNgMM"                                                  .dMMMM`               (F              ..MMNKM/                 dMa    _.B/7.T(.                        !.T%7.Ti.
            .MMMN.    .JMMNMMMM#"!       ..................,  ..................,     .MNMM@                .Mb          .(MMNKNgM#3                 .MNMN,  ,5"""""((.                  .,   ,Y"""""/(.
           .MMMMD..+MMMMMMM#"!         .dMMMMNNNNNNNNmf????! JMMMMNNNNNNNNmK7???!   .JMMMM=                .MMMb    ..JMMNNMMMB"!              .,     MMMdF   `` `  `    ....(ggNMMMN,  .M`    ``    `
          .MMMMMMMMMMMM#"`            .MMMMMMMMMTMMM"`     .dMMMMMMMMTMMM@!        .MMMMB`                .MMMM^..&MMMMMMM#"`               .JMMML....#MN#    .#      .MMMMMMMMMMM#' TN,M%      dF
          dMMMMMMMMY"`               .MMMMD               .MMMMF                  -MMMM$         ..g,    .MMMMNMMMMMMMY"`               ..MMMMMgM@7?(Md#M'   .Mdx.    MMMMMM""""?`     J#N,    .MN,
         dMMMFdMMMF                 .MMMM3 .MJNMgNdgM@""".MMMMD .MaNJmNJmM#"""  .MMMM#!  MMMMMMMMMMMMe  .MMMMMMMMMY"                 .JMMMMNM#"`    dNMdF    dNNMF   -MMM#            .MdM#   .MM#M!
        JMMM@.MMMMMN,.             .MMMM' gMMMMMMMMMD   .MMMM3 gMMMMMMMMMF     .MMMMD         .(MMMMMM[.MMMM5MMMM%               ..MMMMMMMB^       .#MN@    -MMQ@   .MMMM'           .MNMM^   MMMd$
       -MMM#` (TMMMMMMNa,         JMMM#`        ..,    .MMMM^        ..,     .dMMMM'      ..MMMMMMMY= .MMMMF.MMMMNa,          .JMMMMMMM"`         .MdMM!   .MM#M!   MMMMF            d#MMF   (MMWF
      .MMMM`      7WMMMMMMN,.     WMMMM,..(gNMM""^`    TMMMMp...&gMM""7!    .MMNMF     .&MMMMMM#"`    dMMMF  7WMMMMMMN,.       TMMMMP            .MNMMt   .MMNdt   -MMMN.       ... .MdM#   .MMNM`
     .MMMM'          .TMMMNMMNa,   ?MMMMMMMMMMt         ,MMMMMMMMMMF      .JMMQM^  ..MMMMMMM9^       JMMM@      _TMMMMMMNa,`    ?MMMMMMMMMMMMMMMMM#MMF    JMMNF     WMMMMMMMMMM"""".MNMM^  .MMMd%
    .MMMM^               ?WMMMgMMNJ,.WMMMM"""!            TMMMM"""!       WMMgMm.gMMMMMM#"          -MMM#           ?WMMNgMMN,.  ,MMMMMMMMMMMMMMMMMMM    .MM#M`      7MMMMMgNN%    d#MMF   JMMWF
   .MMMMt                   .TWMMNgMMa,                                    ,WMNMMMMMM"!            .MMMM`              .TMMMNKMNa.                       TMNd/                    -MMM#   .HMh#
  .MMMMD                        ?YNV"=?YNJ,                                  (MMM9^               .MMMM'                   ?"MMMNMMNJ,                     MF    ............(JJ++MMMM'     .M^
 .MMMMF                                                                                          .MMMM^                       .THmT9?TMg,                  7   .dMMMMMMMMMMMMMMMMMMMMF      .=
 dMMMF                                                                                          .MMMM%                                  ?                 .MMMMMMMMMMHHH""""""""""""`
 WMM@                                                                                          .MMMM$
  M#                                                                                           ,MMMF
 .#`                                                                                            .MF
 7!                                                                                             (F
                                                                                               ."
EOS


# 時間を変化させながらRGBの値を更新する例
h = 0
s = 0
v = 0
loop do
  if v < 100
    hsv_to_rgb(h, s, v)
    puts Rainbow(STR).color(*hsv_to_rgb(h, s, v))
    v += 1
  else
    puts STR.split("\n").map.with_index{|row, i| row.chars.map.with_index{|c, j| Rainbow(c).color(*hsv_to_rgb(h+i*2+j, s, v))}.join()}.join("\n")
    s += 1 if s < 100
    h += 10
  end
  sleep 0.1
  puts "\e[2J\e[H"
end
