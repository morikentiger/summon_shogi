// helper_methods.dart

import 'package:summon_shogi/shogi_piece.dart';

// 駒の画像を差し替える
ShogiPiece turnOverPiece(ShogiPiece piece) {
  String currentKeyString = piece.isAlly ? "up" : "down"; // 画像パスから検索する文字列
  String newKeyString = piece.isAlly ? "down" : "up"; // 置き換える文字列
  String newImagePath =
      piece.imagePath.replaceFirst(currentKeyString, newKeyString); // 画像パスの置き換え

  return ShogiPiece(
    type: piece.type,
    isAlly: !piece.isAlly,
    imagePath: newImagePath,
    isPromoted: false,
  );
}

// メソッドの定義
bool isInBoard(int row, int col) {
  // 盤面の範囲内にあるかどうかを確認
  return row >= 0 && row < 9 && col >= 0 && col < 9;
}

// 駒が移動可能な座標を配列で返す
List<List<int>> calculateRawValidMoves(
    List<List<dynamic>> shogiBoard, int row, int col, ShogiPiece? piece) {
  if (piece == null) {
    return [];
  }

  List<List<int>> candidateMoves = [];
  int direction = piece.isAlly ? -1 : 1;

  switch (piece.type) {
    case ShogiPieceType.hohei: // 歩兵
      var newRow = row + direction;

      // 盤面から出ていない
      if (isInBoard(newRow, col)) {
        // 空の座標か、敵の座標だった場合
        if (shogiBoard[newRow][col] == null ||
            shogiBoard[newRow][col]!.isAlly != piece.isAlly) {
          candidateMoves.add([newRow, col]);
        }
      }

      break;
    case ShogiPieceType.hisya: // 飛車
      var directions = [
        [-1, 0], // 上
        [1, 0], // 下
        [0, -1], // 左
        [0, 1], // 右
      ];

      for (var direction in directions) {
        var i = 1;

        while (true) {
          var newRow = row + (direction[0] * i);
          var newCol = col + (direction[1] * i);

          // 盤面から出た場合
          if (!isInBoard(newRow, newCol)) {
            break;
          }

          // 対象の座標に駒がある
          if (shogiBoard[newRow][newCol] != null) {
            // 対象の駒が敵
            if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }

          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }

      break;
    case ShogiPieceType.promotedHisya: // 龍王
      // 上下左右にはいくらでも移動できる
      var runningDirections = [
        [-1, 0], // 上
        [1, 0], // 下
        [0, -1], // 左
        [0, 1], // 右
      ];

      // 斜めにはひとつ移動できる
      var singleDirections = [
        [-1, -1], // 左上
        [-1, 1], // 右上
        [1, -1], // 左下
        [1, 1], // 右下
      ];

      // 上下左右移動判定
      for (var direction in runningDirections) {
        var i = 1;

        while (true) {
          var newRow = row + (direction[0] * i);
          var newCol = col + (direction[1] * i);

          // 盤面から出た場合
          if (!isInBoard(newRow, newCol)) {
            break;
          }

          // 対象の座標に駒がある
          if (shogiBoard[newRow][newCol] != null) {
            // 対象の駒が敵
            if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }

          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }

      // 斜め移動判定
      for (var direction in singleDirections) {
        var newRow = row + (direction[0]);
        var newCol = col + (direction[1]);

        // 盤面から出た場合
        if (!isInBoard(newRow, newCol)) {
          continue;
        }

        // 対象の座標に駒がある
        if (shogiBoard[newRow][newCol] != null) {
          // 対象の駒が敵
          if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
            candidateMoves.add([newRow, newCol]);
          }
          continue;
        }

        candidateMoves.add([newRow, newCol]);
      }

      break;
    case ShogiPieceType.kakugyo: // 角行
      var directions = [
        [-1, -1], // 左上
        [-1, 1], // 右上
        [1, -1], // 左下
        [1, 1], // 右下
      ];

      for (var direction in directions) {
        var i = 1;

        while (true) {
          var newRow = row + (direction[0] * i);
          var newCol = col + (direction[1] * i);

          // 盤面から出た場合
          if (!isInBoard(newRow, newCol)) {
            break;
          }

          // 対象の座標に駒がある
          if (shogiBoard[newRow][newCol] != null) {
            // 対象の駒が敵
            if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }

          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }

      break;
    case ShogiPieceType.promotedKakugyo: // 龍馬
      // 斜めにはいくらでも移動できる
      var runningDirections = [
        [-1, -1], // 左上
        [-1, 1], // 右上
        [1, -1], // 左下
        [1, 1], // 右下
      ];

      // 上下左右にはひとつ移動できる
      var singleDirections = [
        [-1, 0], // 上
        [1, 0], // 下
        [0, -1], // 左
        [0, 1], // 右
      ];

      // 斜め移動判定
      for (var direction in runningDirections) {
        var i = 1;

        while (true) {
          var newRow = row + (direction[0] * i);
          var newCol = col + (direction[1] * i);

          // 盤面から出た場合
          if (!isInBoard(newRow, newCol)) {
            break;
          }

          // 対象の座標に駒がある
          if (shogiBoard[newRow][newCol] != null) {
            // 対象の駒が敵
            if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }

          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }

      // 上下左右移動判定
      for (var direction in singleDirections) {
        var newRow = row + (direction[0]);
        var newCol = col + (direction[1]);

        // 盤面から出た場合
        if (!isInBoard(newRow, newCol)) {
          continue;
        }

        // 対象の座標に駒がある
        if (shogiBoard[newRow][newCol] != null) {
          // 対象の駒が敵
          if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
            candidateMoves.add([newRow, newCol]);
          }
          continue;
        }

        candidateMoves.add([newRow, newCol]);
      }

      break;
    case ShogiPieceType.kyousya: // 香車
      var kyousyaMoves = [
        [direction, 0]
      ];

      for (var move in kyousyaMoves) {
        var i = 1;

        while (true) {
          var newRow = row + (move[0] * i);

          // 盤面から出た場合
          if (!isInBoard(newRow, col)) {
            break;
          }

          // 対象の座標に駒がある
          if (shogiBoard[newRow][col] != null) {
            // 対象の駒が敵
            if (shogiBoard[newRow][col]!.isAlly != piece.isAlly) {
              candidateMoves.add([newRow, col]);
            }
            break;
          }

          candidateMoves.add([newRow, col]);
          i++;
        }
      }

      break;
    case ShogiPieceType.keima: // 桂馬
      var keimaMoves = [
        [direction * 2, -1], // 左斜め
        [direction * 2, 1], // 右斜め
      ];

      for (var move in keimaMoves) {
        var newRow = row + move[0];
        var newCol = col + move[1];

        // 盤面から出た場合
        if (!isInBoard(newRow, newCol)) {
          continue;
        }

        // 対象の座標に駒がある
        if (shogiBoard[newRow][newCol] != null) {
          // 対象の駒が敵
          if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
            candidateMoves.add([newRow, newCol]);
          }
          continue;
        }

        candidateMoves.add([newRow, newCol]);
      }

      break;
    case ShogiPieceType.ginsho: // 銀将
      var directions = [
        [direction, 0], // 上
        [-1, -1], // 左上
        [-1, 1], // 右上
        [1, -1], // 左下
        [1, 1], // 右下
      ];

      for (var direction in directions) {
        var newRow = row + (direction[0]);
        var newCol = col + (direction[1]);

        // 盤面から出た場合
        if (!isInBoard(newRow, newCol)) {
          continue;
        }

        // 対象の座標に駒がある
        if (shogiBoard[newRow][newCol] != null) {
          // 対象の駒が敵
          if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
            candidateMoves.add([newRow, newCol]);
          }
          continue;
        }

        candidateMoves.add([newRow, newCol]);
      }

      break;
    case ShogiPieceType.kinsho: // 金将
    case ShogiPieceType.promotedKeima:
    case ShogiPieceType.promotedKyousya:
    case ShogiPieceType.promotedGinsho:
    case ShogiPieceType.promotedHohei:
      var directions = [
        [-1, 0], // 上
        [1, 0], // 下
        [0, -1], // 左
        [0, 1], // 右
        [direction, -1], // 左上
        [direction, 1], // 右上
      ];

      for (var direction in directions) {
        var newRow = row + (direction[0]);
        var newCol = col + (direction[1]);

        // 盤面から出た場合
        if (!isInBoard(newRow, newCol)) {
          continue;
        }

        // 対象の座標に駒がある
        if (shogiBoard[newRow][newCol] != null) {
          // 対象の駒が敵
          if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
            candidateMoves.add([newRow, newCol]);
          }
          continue;
        }

        candidateMoves.add([newRow, newCol]);
      }

      break;
    case ShogiPieceType.gyokusho: // 玉将
    case ShogiPieceType.ousho: // 王将
      var directions = [
        [-1, 0], // 上
        [1, 0], // 下
        [0, -1], // 左
        [0, 1], // 右
        [-1, -1], // 左上
        [-1, 1], // 右上
        [1, -1], // 左下
        [1, 1], // 右下
      ];

      for (var direction in directions) {
        var newRow = row + (direction[0]);
        var newCol = col + (direction[1]);

        // 盤面から出た場合
        if (!isInBoard(newRow, newCol)) {
          continue;
        }

        // 対象の座標に駒がある
        if (shogiBoard[newRow][newCol] != null) {
          // 対象の駒が敵
          if (shogiBoard[newRow][newCol]!.isAlly != piece.isAlly) {
            candidateMoves.add([newRow, newCol]);
          }
          continue;
        }

        candidateMoves.add([newRow, newCol]);
      }

      break;
    default:
  }

  return candidateMoves;
}
