import 'package:flutter/material.dart';
import 'package:front/dataSets/dataSetColors.dart';
import '../dataSets/dataSetTextStyles.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';

class PageFeatureMain extends StatefulWidget {
  const PageFeatureMain({Key? key}) : super(key: key);

  @override
  State<PageFeatureMain> createState() => _PageFeatureMainState();
}

class _PageFeatureMainState extends State<PageFeatureMain> {
  //dataSet
  final List<String> statusCheckTitle = ['노션 연동', '스테레오 녹음', '마이크 녹음'];
  final ScrollController agendaListViewScroller = ScrollController();
  late bool isRecordOn;
  late List<bool> statusCheck;
  late int time;
  late String meetingName;
  late String timeStamp;
  late int participants;
  late int currentTime;
  late List<String> agendaList;
  late List<dynamic> talk;

  @override
  void initState() {
    //현재 녹음 여부 기본 false로 선언
    isRecordOn = false;
    //연동 , 스테레오 녹음 , 마이크 녹음 등의 체크를 false로 기본 선언
    statusCheck = List.filled(3, false);
    //현재 녹음 시간 0으로 선언
    time = 0;
    meetingName = '회의록 By V-Map';
    timeStamp = '2023/03/14 · 16:00';
    participants = 4;
    currentTime = 0;
    agendaList = [
      '오늘 점심 메뉴 정하기',
      '랩실 청소 당번 정하기',
      '랩실 의자 교체 작업',
      '연구 보고서 작성 회의일자 정하기',
      '진행 과정 보고'
    ];
    talk = [
      ['0:02', '이상현', '안녕하세요'],
      ['0:03', '이세희', '반갑습니다.'],
      ['0:07', '조원희', '모두 오랜만입니다.'],
      ['0:12', '임재경', '그러게요, 정말 오랜만에 뵙는 것 같아요.']
    ];
    //이 함수가 실행 되어야 위젯 변수들의 초기화가 완료됨.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //전체를 감싸는 컨테이너, 배경색을 담당
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
                        Text('회의명 : $meetingName', style: b1eb),
                        Text(
                          '$timeStamp · 참여자 $participants명',
                          style: const TextStyle(
                              fontFamily: 'apb', color: Colors.grey),
                        )
                      ]),
                  const Expanded(child: SizedBox()),
                  Text('$currentTime', style: b1eb),
                  const SizedBox(width: 12),
                  TextButton(onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => PageFrameRanding()));
                  }, child: Text('HOME', style: TextStyle(fontSize: 15)),
                    style: TextButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: Size(100, 50),),
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
                    children: List<Widget>.generate(participants, (index) {
                      return  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue, radius: 16,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                            child: Text('${talk[index][1][0]}',style: const TextStyle(fontFamily: 'apl',fontSize: 12),),
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
                                    agendaList[index],
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(talk.length, (index) {
                        return ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '${talk[index][0]}',
                                    style: const TextStyle(
                                        fontFamily: 'apm', fontSize: 14),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${talk[index][1]}',
                                  style: const TextStyle(
                                      fontFamily: 'apeb', fontSize: 20),
                                ),
                                const Expanded(child: SizedBox()),
                                Text(
                                  '${talk[index][2]}',
                                  style: const TextStyle(
                                      fontFamily: 'apm', fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )),
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
                        setState(() {
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
