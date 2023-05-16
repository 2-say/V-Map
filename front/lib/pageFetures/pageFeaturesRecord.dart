import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front/dataSets/dataSetColors.dart';
import '../dataSets/dataSetTextStyles.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';

import '../firestore/firebaseController.dart';
import '../widgets/widgetCommonAppbar.dart';

class PageFeatureRecord extends StatefulWidget {
  const PageFeatureRecord(
      {Key? key, required this.meetingInfo, required this.userInfo})
      : super(key: key);
  final Map<String, dynamic>? meetingInfo;
  final Map<String, dynamic>? userInfo;

  @override
  State<PageFeatureRecord> createState() => _PageFeatureRecordState();
}

class _PageFeatureRecordState extends State<PageFeatureRecord> {
  //dataSet
  final ScrollController agendaListViewScroller = ScrollController();
  late bool isRecordOn;
  late List<bool> statusCheck;
  late int currentTime;
  late List<String> agendaList = [];
  late List<dynamic> talk = [];
  int count =0;

  //회의록 내용을 스트리밍 형태로 받아올 수 있는 객체 선언
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamConnectContents;

  @override
  void initState() {
    // 스트리밍 객체를 어떤 문서에 연결할 것인지 위젯 빌드 전 할당
    streamConnectContents = FirebaseFirestore.instance
        .collection('meetings')
        .where('password', isEqualTo: widget.meetingInfo!['password'])
        .snapshots();
    //현재 녹음 여부 기본 false로 선언
    isRecordOn = false;
    //연동 , 스테레오 녹음 , 마이크 녹음 등의 체크를 false로 기본 선언
    statusCheck = List.filled(3, false);
    //현재 녹음 시간 0으로 선언
    currentTime = 0;
    //이 함수가 실행 되어야 위젯 변수들의 초기화가 완료됨.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //전체를 감싸는 컨테이너, 배경색을 담당
      appBar: WidgetCommonAppbar(
          appBar: AppBar(), currentPage: 'meeting', loginState: true),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        //자식들을 담을 column
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              //세로 정렬 : start( 시작점 부터 )
              mainAxisAlignment: MainAxisAlignment.start,
              //가로 정렬 : start ( 시작점 부터 )
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //row:현재 회의 상태 표시
                Row(children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('회의명 : ${widget.meetingInfo!['meetingName']}',
                            style: b1eb),
                        Text(
                          '${widget.meetingInfo!['startTime']} · 참여자 ${widget.meetingInfo!['etc'].length + 1}명',
                          style: const TextStyle(
                              fontFamily: 'apb', color: Colors.grey),
                        )
                      ]),
                  const Expanded(child: SizedBox()),
                  Text('$currentTime', style: b1eb),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PageFrameRanding()));
                    },
                    child: Text('HOME', style: TextStyle(fontSize: 15)),
                    style: TextButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: Size(100, 50),
                    ),
                  ),
                  isRecordOn
                      ? const Text('녹음 중',
                          style: TextStyle(
                              fontFamily: 'apeb', color: Colors.blueAccent))
                      : const Text('일시 정지 중',
                          style: TextStyle(
                              fontFamily: 'apeb', color: Colors.redAccent)),
                  const SizedBox(width: 8),
                  Row(
                    children: List<Widget>.generate(
                        widget.meetingInfo!['etc'].length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 16,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                              child: Text(
                                '${talk[index][1][0]}',
                                style: const TextStyle(
                                    fontFamily: 'apl', fontSize: 12),
                              ),
                            )),
                      );
                    }),
                  )
                ]),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Image.asset('assets/wave.png'),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 48,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border.symmetric(
                          horizontal:
                              BorderSide(width: 1, color: Colors.grey))),
                  child: Text('자동 요약 안건', style: b1eb),
                ),
                Container(
                    padding: const EdgeInsets.all(4.0),
                    height: 136,
                    child: Scrollbar(
                      controller: agendaListViewScroller,
                      thumbVisibility: true,
                      //스크롤 위젯
                      child: SingleChildScrollView(
                          controller: agendaListViewScroller,
                          child: Column(
                            children: List<Widget>.generate(5, (index) {
                              return ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: -3),
                                  title: Text(
                                    '',
                                    style: const TextStyle(
                                        fontFamily: 'apm', color: Colors.grey),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.close)));
                            }),
                          )),
                    )),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 48,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border.symmetric(
                          horizontal:
                              BorderSide(width: 1, color: Colors.grey))),
                  child: Text('회의 내용', style: b1eb),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 32,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.grey))),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text('편집 도구',
                            style: TextStyle(
                                fontFamily: 'apeb', color: Colors.grey)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.title),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.view_agenda),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit,
                                    color: Colors.blueAccent),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.error,
                                    color: Colors.redAccent),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.notifications_on),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
                Expanded(
                    child: Container(
                        child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: streamConnectContents,
                            builder: (context, snapshot) {
                              //에러 없이 데이터가 성공적으로 수신되었다면
                              if (snapshot.hasData && snapshot.data != null) {
                                var docs = snapshot.data?.docs.first.data();
                                return SingleChildScrollView(
                                    child: Column(
                                        children: List.generate(
                                            docs?['contents'].length, (index) {
                                  return ListTile(
                                      title: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    docs?['contents'][index]
                                                        ['startTime'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'apm',
                                                        color: Colors.grey)),
                                                const SizedBox(width: 8),
                                                Text(
                                                    docs?['contents'][index]
                                                        ['user'],
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'apeb')),
                                                const SizedBox(width: 8),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color:
                                                          Colors.grey.shade300),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      docs?['contents'][index]
                                                          ['text'],
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'apm')),
                                                )
                                              ])));
                                })));
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                                // 기타 경우 ( 불러오는 중 )
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }))),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    isRecordOn ? ccKeyColorGreen : Colors.red,
                    ccKeyColorCyan
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
                  child: IconButton(
                      onPressed: () {
                        //firebase 컨트롤러 만들어놨어~ 이거 써서 업데이트 하면 돼
                        FirebaseController().updateMeetingContents(widget.meetingInfo!['password'], 'testUser', '00:00', '00:00', 'ㅋㅋㅋㅋㅋ 테스트!${count}');
                        count++;
                        setState(() {
                          //isRecordOn이 true일때 녹음 기능이 작동하도록 하면 될듯!
                          isRecordOn = !isRecordOn;
                        });
                      },
                      icon: Icon(
                          isRecordOn
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 36,
                          color: Colors.white)),
                )
              ]),
        ),
      ),
    );
  }
}
