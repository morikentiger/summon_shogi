// main.dart

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:summon_shogi/helper_methods.dart';
import 'package:summon_shogi/shogi_piece.dart';
import 'package:summon_shogi/square.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SummonShogiPage(),
    );
  }
}

class SummonShogiPage extends StatefulWidget {
  const SummonShogiPage({super.key});

  @override
  State<SummonShogiPage> createState() => _SummonShogiPageState();
}

class _SummonShogiPageState extends State<SummonShogiPage> {
  late List<List<dynamic>> shogiBoard;
  ShogiPiece? selectedPiece; // 選択されている駒
  int selectedRow = -1; // 選択されている駒の行番号
  int selectedCol = -1; // 選択されている駒の列番号
  List<List<int>> validMoves = []; // 選択中の駒が移動可能な座標
  bool isAllyTurn = true; // 味方のターンかどうか
  List<ShogiPiece> piecesTakenByAlly = []; // 味方が獲得した駒の配列
  List<ShogiPiece> piecesTakenByEnemy = []; // 敵が獲得した駒の配列
  bool isSelectingDropPosition = false; // 手持ちの駒を打とうとしている

  void selectDropPosition(ShogiPiece piece) {
    if (isAllyTurn == piece.isAlly) {
      setState(() {
        isSelectingDropPosition = true;
        selectedPiece = piece;
      });
    }
  }

  void turnChange() {
    setState(() {
      isAllyTurn = !isAllyTurn;
    });
  }

  // 駒を移動
  void movePiece(int newRow, int newCol) {
    // 相手の駒があれば取得
    if (shogiBoard[newRow][newCol] != null) {
      var capturedPiece = shogiBoard[newRow][newCol];

      // 駒の取得
      if (capturedPiece!.isAlly) {
        piecesTakenByEnemy.add(turnOverPiece(capturedPiece));
      } else {
        piecesTakenByAlly.add(turnOverPiece(capturedPiece));
      }
    }

    shogiBoard[newRow][newCol] = selectedPiece; // 新しい座標へ移動
    shogiBoard[selectedRow][selectedCol] = null; // 元の座標を初期化

    // 現在の選択をリセット
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    turnChange();
  }

  void selectPiece(int row, int col) {
    // 駒を選択していない状態から駒を選択した時
    if (selectedPiece == null && shogiBoard[row][col] != null) {
      if (shogiBoard[row][col]!.isAlly == isAllyTurn) {
        setState(() {
          selectedPiece = shogiBoard[row][col];
          selectedRow = row;
          selectedCol = col;
        });
      }
      // 駒を選択している状態で自陣の他の駒を選択した時
    } else if (shogiBoard[row][col] != null &&
        shogiBoard[row][col]!.isAlly == selectedPiece!.isAlly) {
      setState(() {
        selectedPiece = shogiBoard[row][col];
        selectedRow = row;
        selectedCol = col;
      });
      // 移動可能な座標を選択した時
    } else if (selectedPiece != null &&
        validMoves.any(
            (coordinate) => coordinate[0] == row && coordinate[1] == col)) {
      movePiece(row, col);
    } else if (isSelectingDropPosition && shogiBoard[row][col] == null) {
      // 空き座標にセット
      shogiBoard[row][col] = selectedPiece;

      // 持ち駒から削除
      if (selectedPiece!.isAlly) {
        piecesTakenByAlly.remove(selectedPiece);
      } else {
        piecesTakenByEnemy.remove(selectedPiece);
      }
    }

    // 現在の選択をリセット
    selectedPiece = null;
    selectedRow = -1;
    selectedCol = -1;
    validMoves = [];
    isSelectingDropPosition = false;

    turnChange();

    // validMoves = calculateRawValidMoves(
    //     shogiBoard, selectedRow, selectedCol, selectedPiece); // 移動可能な座標を計算
  }

  @override
  void initState() {
    super.initState();

    initializeBoard(); // ゲーム開始時に盤面を初期化する
  }

  // 盤面の初期化
  void initializeBoard() {
    // 9 x 9 の配列
    List<List<dynamic>> newBoard =
        List.generate(9, (index) => List.generate(9, (index) => null));

    // 駒の初期配置
    // 王将・玉将を配置
    newBoard[0][4] = ShogiPiece(
      type: ShogiPieceType.ousho,
      isAlly: false,
      imagePath: 'lib/images/down_ousho.png',
      isPromoted: false,
    );
    newBoard[8][4] = ShogiPiece(
      type: ShogiPieceType.gyokusho,
      isAlly: true,
      imagePath: 'lib/images/up_gyokusho.png',
      isPromoted: false,
    );

    shogiBoard = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: piecesTakenByEnemy.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(piecesTakenByEnemy[index].imagePath),
              ),
            ),
          ),
          // ターン表示
          Text(
            isAllyTurn ? 'あなたのターンです' : '相手のターンです',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 9 * 9,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9),
            itemBuilder: (context, index) {
              int row = index ~/ 9; // 縦軸
              int col = index % 9; // 横軸
              bool isSlected =
                  row == selectedRow && col == selectedCol; // 座標が選択されているかどうか
              bool isValidMove = false;

              for (var position in validMoves) {
                if (position[0] == row && position[1] == col) {
                  isValidMove = true;
                }
              }

              return Square(
                shogiPiece: shogiBoard[row][col],
                isSelected: isSlected,
                onTap: () => selectPiece(row, col),
                isValidMove: isValidMove,
                isSelectingDropPosition: isSelectingDropPosition,
              );
            },
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: piecesTakenByAlly.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                selectDropPosition(piecesTakenByEnemy[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 2.0,
                  color: isSelectingDropPosition &&
                          selectedPiece == piecesTakenByAlly[index]
                      ? Colors.black26
                      : Colors.transparent,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(piecesTakenByAlly[index].imagePath),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
