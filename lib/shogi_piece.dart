// shogi_piece.dart

// 駒の種類
enum ShogiPieceType {
  ousho,
  gyokusho,
  hisya,
  promotedHisya,
  kakugyo,
  promotedKakugyo,
  kinsho,
  ginsho,
  promotedGinsho,
  keima,
  promotedKeima,
  kyousya,
  promotedKyousya,
  hohei,
  promotedHohei,
}

class ShogiPiece {
  final ShogiPieceType type; // 駒の種類
  final bool isAlly; // 味方の駒かどうか
  final String imagePath; // 駒の画像
  final bool isPromoted; // 成っているかどうか

  ShogiPiece({
    required this.type,
    required this.isAlly,
    required this.imagePath,
    required this.isPromoted,
  });
}
