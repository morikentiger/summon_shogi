// square.dart

import 'package:flutter/material.dart';
import 'package:summon_shogi/shogi_piece.dart';

class Square extends StatelessWidget {
  final ShogiPiece? shogiPiece;
  final bool isSelected; // 選択されているかどうか
  final void Function()? onTap; // タップされた時に呼ばれるメソッド
  final bool isValidMove; // 選択中の駒が移動可能か
  final bool isSelectingDropPosition; // 手持ちの駒を打とうとしているか

  const Square({
    super.key,
    required this.shogiPiece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
    required this.isSelectingDropPosition,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    // 座標の状態によって背景色を変化
    if (isSelectingDropPosition && shogiPiece == null) {
      squareColor = Colors.green[100]; // 選択中の駒を打つことができる
    } else if (isSelected) {
      squareColor = Colors.green; // 駒を選択中
    } else if (isValidMove) {
      squareColor = Colors.green[100]; // 選択中の駒が移動可能
    } else {
      squareColor = Colors.deepPurple[700]; // 盤面の色
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: squareColor,
            border: Border.all(color: Colors.white, width: 1.0)),
        // 駒を引数に受け取っていれば駒の画像を表示
        child: shogiPiece != null
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(shogiPiece!.imagePath),
              )
            : null,
      ),
    );
  }
}
