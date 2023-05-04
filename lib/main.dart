// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

import 'todo_function.dart';

var color1 = Color(0xffFCFAF9);
var color2 = Color(0xffD6E0EA);
var color3 = Color(0xffBDCCDB);
var color4 = Color(0xff4EB4E8);
var color5 = Color(0xff2676CD);


void main() {
  runApp(MyApp());
}

/// 메인 코드
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

  /// 화면전환 함수
  var tabNo = 0;
  var tabs = [MainTimer(),SwipableList()];

  changeTab(i){
    setState(() {
      if(i>1){
        i = 1;
      }
      tabNo = i;
    });
    print(tabNo.toString());
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: Scaffold(
        body: Column(
          children: [tabs[tabNo]],
        ),

        bottomNavigationBar: Navigation(changeTab : changeTab, tabNo : tabNo)
      )
    );
  }
}


/// 타이머

class MainTimer extends StatefulWidget {
  const MainTimer({Key? key}) : super(key: key);

  @override
  State<MainTimer> createState() => _MainTimerState();
}

class _MainTimerState extends State<MainTimer> {


  late Timer _timer;
  bool timerOn = false;
  var clockColor=color2;

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List _times = [0,0,0];
  var timeStr = '00:00';

  ///시간 표기 계산 ( 2403 -> 40:03 ) 함수
  timeListtoStr(_times){
    timeStr = _times[1].toString().padLeft(2,'0') + ':' + _times[2].toString().padLeft(2,'0');
    if(_times[0]!=0){
      timeStr = _times[0].toString() + ':' + timeStr;
    }
    return timeStr;
  }

  /// 과목별 데이터
  List subjectList = ['a', 'b', 'c', 'd'];
  List subjectTimeList = [[0,0,0],[0,0,0],[0,0,0],[0,0,0]];
  List subjectIndexList = [0,1,2,3];
  int subjectOn = 0;

  ///타이머 기능
  void _start() {
    sleep(Duration(milliseconds: 50));
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {

        /// 시간표기
        for (var i in [_times, subjectTimeList[subjectIndexList[subjectOn]]]) {
          i[2]++;
          if (i[2] == 60) {
            i[1]++;
            i[2] = 0;
            if (i[1] == 60) {
              i[0]++;
              i[1] = 0;
            }
          }
        }
        timeStr = timeListtoStr(_times);



      });
    });
  }
  void _pause() {
    _timer.cancel();
    timeStr = timeListtoStr(_times);
  }


  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color1)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ///날짜
            Container(
              alignment: Alignment(0,-1),
              padding: EdgeInsets.all(15),
              child: Text(
                '10월 27일 목요일',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: color5,
                  fontSize: 30
                ),
              )
            ),
            ///시계
            GestureDetector(
              onTap: (){
                timeStr = timeListtoStr(_times);
                setState(() {
                  timerOn = !timerOn;
                  if(timerOn){
                    clockColor = color4;
                    _start();
                  } else{
                    clockColor = color2;
                    _pause();
                  }
                });
              },
              /// 시계 UI
              child: Container(
                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: clockColor,
                      borderRadius: BorderRadius.circular(250),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 40),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// 전체 시간
                        Text(timeStr.toString(),
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w900,
                            // color: timerOn==1 ? Colors.black :Colors.white
                          ),
                        ),
                        /// 과목 시간
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ///과목 변경 (Timer ON 이면 화살표 사라짐)
                                timerOn == false
                                  ? IconButton(
                                    onPressed: (){
                                      setState(() {
                                        timeStr = timeListtoStr(_times);
                                        subjectOn--;
                                        subjectOn = subjectOn % 4;
                                      });
                                    },
                                    icon: Icon(Icons.arrow_left)
                                  )
                                  : Text(''),
                                Text(subjectList[subjectIndexList[subjectOn]].toString(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                                timerOn == false
                                  ? IconButton(
                                    onPressed: (){
                                      setState(() {
                                        timeStr = timeListtoStr(_times);
                                        subjectOn++;
                                        subjectOn = subjectOn %4;
                                      });
                                    },
                                    icon: Icon(Icons.arrow_right)
                                  )
                                  : Text(''),
                              ],
                            ),
                            ///과목 시간
                            Text(timeListtoStr(subjectTimeList[subjectIndexList[subjectOn]]),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}


/// 투두 창
// class Todo extends StatefulWidget {
//   const Todo({Key? key}) : super(key: key);
//
//   @override
//   State<Todo> createState() => _TodoState();
// }
//
// class _TodoState extends State<Todo> {
//   var todoNum = 1;
//   var todos = ['뭐할래?'];
//   var success = [-1];
//
//   final myController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 850,
//       width: 500,
//       decoration: BoxDecoration(
//         color: color1,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: color3,
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(30),
//             topLeft: Radius.circular(30)
//           )
//         ),
//
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             /// 추가버튼, 정렬버튼
//             Container(
//               margin: EdgeInsets.fromLTRB(20,10,20,10),
//               height: 30,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   /// 추가
//                   ElevatedButton(
//                     onPressed: (){
//                       setState(() {
//                         todoNum += 1;
//                         todos.add('뭐하지$todoNum');
//                         success.add(-1);
//                       });
//                       print(todoNum.toString());
//                     },
//                     style: ButtonStyle(
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18.0),
//                         ),
//                       ),
//                       elevation: MaterialStateProperty.all(0),
//                       backgroundColor: MaterialStateProperty.all(color4),
//                       foregroundColor: MaterialStateProperty.all(Colors.black),
//                       fixedSize: MaterialStateProperty.all(Size(80, 25)),
//                       textStyle: MaterialStateProperty.all(
//                         TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15
//                         )
//                       )
//                     ),
//                     child: Flexible(
//                       fit: FlexFit.tight,
//                       child: Text('추가')
//                     ),
//                   ),
//                   /// 정렬
//                   ElevatedButton(
//                     onPressed: (){},
//                     style: ButtonStyle(
//                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18.0),
//                             )
//                         ),
//                         elevation: MaterialStateProperty.all(0),
//                         backgroundColor: MaterialStateProperty.all(color2),
//                         foregroundColor: MaterialStateProperty.all(Colors.black),
//                         fixedSize: MaterialStateProperty.all(Size(80, 25)),
//                         textStyle: MaterialStateProperty.all(
//                             TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15
//                             )
//                         )
//                     ),
//                     child: Flexible(
//                         fit: FlexFit.tight,
//                         child: Text('정렬')
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             /// NEW 투두 입력 칸
//             Container(
//               height: 50,
//               margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
//               color: color2,
//               child: Row(
//                 children: [
//                   Flexible(
//                     fit: FlexFit.tight,
//                     child: TextField(
//                       controller: myController,
//                     ),
//                   ),
//                   IconButton(onPressed: (){}, icon: Icon(Icons.add_box_rounded))
//                 ],
//               )
//             ),
//
//             /// 투두리스트 (실질적)
//             Flexible(
//               fit: FlexFit.tight,
//               child: ListView.builder(
//                 itemCount: todoNum,
//                 itemBuilder: (c,i){
//                   return Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// 투두 내용
//                       Flexible(
//                         fit: FlexFit.tight,
//                         child: Container(
//                           height: 50,
//                           margin: EdgeInsets.fromLTRB(20, 0, 5, 10),
//                           padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
//                           decoration: BoxDecoration(
//                             color: success[i]==1 ? color4 :color2,
//                             borderRadius: BorderRadius.only(
//                               bottomLeft:Radius.circular(15),
//                               topLeft:Radius.circular(15),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               /// 과목(분류)
//                               // Container(
//                               //   width: 30,
//                               //   margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
//                               //   child: Text(
//                               //     '국어',
//                               //     style: TextStyle(
//                               //       fontWeight: FontWeight.bold,
//                               //     )
//                               //   ),
//                               // ),
//                               /// 내용
//                               Text(todos[i].toString()),
//                             ],
//                           )
//                         ),
//                       ),
//                       /// 체크버튼
//                       ElevatedButton(
//                         onPressed: (){
//                           setState(() {
//                             success[i]=-success[i];
//                           });
//                         },
//                         style: ButtonStyle(
//                           fixedSize: MaterialStateProperty.all(Size(50, 50)),
//                           elevation: MaterialStateProperty.all(0),
//                           backgroundColor: MaterialStateProperty.all(
//                             success[i]==1 ? color4 : color2
//                           ),
//
//                           foregroundColor: MaterialStateProperty.all(Colors.black),
//                           shape: MaterialStateProperty.all(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   topRight : Radius.circular(15),
//                                   bottomRight: Radius.circular(15),
//                               ),
//                             )
//                           ),
//
//
//                         ),
//                         child: Icon(Icons.check),
//                       ),
//                       /// 뒤쪽 여백 채우기 용도
//                       Container(
//                         color: color5,
//                         width: 20,
//                       )
//                     ],
//                   );
//                 },
//               ),
//             ),
//
//           ],
//         ),
//
//       ),
//     );
//
//   }
// }
//

/// 내비게이션 바?

class Navigation extends StatefulWidget {
  const Navigation({Key? key, this.changeTab, this.tabNo}) : super(key: key);

  final changeTab;
  final tabNo;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0; // track the selected index

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.tabNo; // initialize the selected index with the value passed to the widget
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (i){
        setState(() {
          _selectedIndex = i; // update the selected index
        });
        widget.changeTab(i);
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label:'분석'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label:'타이머'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_sharp),
            label:'투두'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label:'설정'
        ),
      ],
      currentIndex: _selectedIndex, // use the selected index from the state
    );
  }
}
