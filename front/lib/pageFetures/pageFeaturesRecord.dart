import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front/dataSets/dataSetColors.dart';
import 'package:rxdart/rxdart.dart';
import '../dataSets/dataSetTextStyles.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:async';

import '../firestore/firebaseController.dart';
import '../testFeatures/requsestOpenMeeting.dart';
import '../widgets/widgetCommonAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../dataSets/dataSetTextStyles.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../firestore/firebaseController.dart';
import '../testFeatures/NoCheckCertificateHttpOverrides.dart';
import '../testFeatures/requsestOpenMeeting.dart';
import '../widgets/widgetCommonAppbar.dart';
import '../pageFetures/pageFeaturesInvite.dart';
import '../widgets/widgetCommonAppbarM.dart';

class PageFeatureRecord extends StatefulWidget {
  const PageFeatureRecord({Key? key, required this.meetingInfo, required this.userInfo, required this.meetingId})
      : super(key: key);
  final Map<String, dynamic>? meetingInfo;
  final Map<String, dynamic>? userInfo;
  final int meetingId;

  @override
  State<PageFeatureRecord> createState() => _PageFeatureRecordState();
}

enum MenuType {
  edit,
  change,
  delete,
}

class _PageFeatureRecordState extends State<PageFeatureRecord> {
  //dataSet
  final ScrollController agendaListViewScroller = ScrollController();
  late bool isRecordOn;
  late List<bool> statusCheck;
  late int currentTime;
  late List<String> agendaList = [];
  late List<dynamic> talk = [];

  var statuses = BehaviorSubject<String>();
  final TextEditingController _textEditingController = TextEditingController();
  var words = StreamController<SpeechRecognitionResult>();
  ScrollController contentsScroll = ScrollController();

  bool switchEdit = false;
  bool switchEdit2 = false;
  bool stopsign = false;

  final TextEditingController _textEditingControllerEdit = TextEditingController();
  String textEdit = '';

  // speech_to_text 추가 - 임재경
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  final _textList = <String>[''];
  final List<String> _recognizedWords = [];

  FeaturesMeeting featuresMeeting = FeaturesMeeting();

  //회의록 내용을 스트리밍 형태로 받아올 수 있는 객체 선언
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamConnectContents;

  setterGoPageFeatureInvite(var contentPrev,int index) {
    TextEditingController tt = TextEditingController();
    tt.text=contentPrev['text'];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            title: const Text('수정할 정보 입력', style: TextStyle(fontSize: 20, fontFamily: 'apeb')),
            content: Container(
              height: 30,
              child: TextField(
                controller: tt,
                onChanged: (val) {
                  setState(() {
                    contentPrev['text'] = val;
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    hintText: '회의명 입력'),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('취소', style: TextStyle(fontFamily: 'apeb'))),
              //이 부분에 zoom 관련 코드 받아서 바로 리턴받을 수 있도록 !
              TextButton(
                  onPressed: () async {
                    FirebaseController().editMeetingContents(widget.meetingInfo!['password'], contentPrev, index);
                    FeaturesMeeting().editNotion(contentPrev['startTime'], widget.meetingInfo!['documentId'], contentPrev['text']);
                    Navigator.pop(context);
                  },
                  child: Text(
                    '수정',
                    style: TextStyle(fontFamily: 'apeb', color: ccKeyColorGreen),
                  ))
            ],
          );
        });
  }

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
    //현재 녹음 시간 0으로 선언=
    currentTime = 0;
    //이 함수가 실행 되어야 위젯 변수들의 초기화가 완료됨.
    _speech = stt.SpeechToText();
    super.initState();
    _textEditingController.addListener(_onTextChanged);
  }

  Future<void> endZoomMeeting(int? meetingId) async {
    var url = Uri.parse('https://api.zoom.us/v2/meetings/$meetingId/status');

    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6InJ1MXllX2xnVE1XSElpUGlZNkc3U1EiLCJleHAiOjE3MDM4NjE5NDAsImlhdCI6MTY4NDk0MTU1Nn0.M03nmML-4E_UVC1AYPWX2e3gYIuzL7RlVTAjzF2vaa4',
      'Content-Type': 'application/json'
    };

    var body = jsonEncode({'action': 'end'});

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 204) {
      print('Zoom meeting ended successfully.');
    } else {
      print('Failed to end Zoom meeting. Status code: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onTextChanged);
    _textEditingController.dispose();
  }

  void _startsign(){
    print("_startsign");
    stopsign=false;
  }


  void _stopsign(){
    print("_stopsign");
    stopsign=true;
  }

  void _onTextChanged() {
    // print(_textEditingController.text);
    if(stopsign){stopListening();}
    else {
      try {
        if (_textEditingController.text != "listening") {
          print("start");
          _startListening();
        } else if (_textEditingController.text == "done") {
          _startListening();
        }
      } catch (e) {
        print("catch(3)");
        stopListening();
        _startListening();
      }
    }

  }

  void handleValue(bool value) {
    // 값 처리 로직을 구현
    print('Boolean 값: $value');
  }

  void statusListener(String status) {
    statuses.add(status);
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: statusListener,
    );
    statuses.listen((status) {
      setState(() {
        if (status == "done") status = "listening";
        _textEditingController.text = status;
      });
    });

    print('start meeting');
    _isListening = true;
    _listen();
  }

  void stopListening() {
    print('stop meeting');
    _speech.stop();
    _isListening = false;
    // print(_isListening);
  }

  String getDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _listen() async {
    // if (_isListening) {
    _speech.listen(
      onResult: (result) {
        setState(() {
          if (result.alternates.last.confidence >= 0.89) {
            _text = result.alternates.last.recognizedWords;
            _textList.add(_text);
            var dt2 = DateTime.now();
            if (_textList.length >= 2) {
              List<String> previousElements = _textList[_textList.length - 2].split(' ');
              List<String> lastElements = _textList.last.split(' ');

              List<String> result1 = [];
              for (int i = 0; i < lastElements.length; i++) {
                String item = lastElements[i];
                if (i >= previousElements.length || item != previousElements[i]) {
                  result1.add(item);
                }
              }
              String result = result1.join(' ');

              if (result.isNotEmpty) {
                var dt2_end = DateTime.now();
                featuresMeeting
                    .patchNotion(dt2.toString(), widget.userInfo!['id'], widget.userInfo!['userName'], result)
                    .then((_) {
                  FirebaseController().updateMeetingContents(widget.meetingInfo!['password'],
                      widget.userInfo!['userName'], dt2.toString(), dt2_end.toString(), result);
                });
              }
            } else {
              print(_textList.first);
              var dt2_end = DateTime.now();
              featuresMeeting
                  .patchNotion(dt2.toString(), widget.userInfo!['id'], widget.userInfo!['userName'], _textList.first)
                  .then((_) {
                FirebaseController().updateMeetingContents(widget.meetingInfo!['password'],
                    widget.userInfo!['userName'], dt2.toString(), dt2_end.toString(), _textList.first);
              });
            }
          }

        });
      },
      cancelOnError: false,
      partialResults: true,
      listenFor: Duration(hours: 2),
      listenMode: stt.ListenMode.dictation,
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //전체를 감싸는 컨테이너, 배경색을 담당
      appBar: WidgetCommonAppbarM(appBar: AppBar(), currentPage: 'meeting', loginState: true),
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
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Text('회의명 : ${widget.meetingInfo!['meetingName']}', style: b1eb),
                    Text(
                      '${widget.meetingInfo!['startTime']} · 참여자 ${widget.meetingInfo!['etc'].length + 1}명',
                      style: const TextStyle(fontFamily: 'apb', color: Colors.grey),
                    )
                  ]),
                  const Expanded(child: SizedBox()),
                  Text('$currentTime', style: b1eb),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PageFrameRanding()));
                    },
                    child: Text('HOME', style: TextStyle(fontSize: 15)),
                    style: TextButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: Size(100, 50),
                    ),
                  ),
                  isRecordOn
                      ? const Text('녹음 중', style: TextStyle(fontFamily: 'apeb', color: Colors.blueAccent))
                      : const Text('일시 정지 중', style: TextStyle(fontFamily: 'apeb', color: Colors.redAccent)),
                  const SizedBox(width: 8),
                  Row(
                    children: List<Widget>.generate(widget.meetingInfo!['etc'].length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 16,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                              child: Text(
                                '${talk[index][1][0]}',
                                style: const TextStyle(fontFamily: 'apl', fontSize: 12),
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
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                  child: Image.asset('assets/wave.png'),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 48,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.grey))),
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
                                  visualDensity: const VisualDensity(vertical: -3),
                                  title: Text(
                                    '',
                                    style: const TextStyle(fontFamily: 'apm', color: Colors.grey),
                                  ),
                                  trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.close)));
                            }),
                          )),
                    )),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 48,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.grey))),
                  child: Text('회의 내용', style: b1eb),
                ),
                Expanded(
                    child: Container(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: streamConnectContents,
                            builder: (context, snapshot) {
                              //에러 없이 데이터가 성공적으로 수신되었다면
                              if (snapshot.hasData && snapshot.data != null) {
                                Map<String, dynamic>? docs = snapshot.data?.docs.first.data();
                                var contentsData = docs?['contents'];
                                return SingleChildScrollView(
                                    reverse: true,
                                    child: Column(
                                        children: List.generate(docs?['contents'].length, (index) {
                                      return ListTile(
                                          title: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 6),
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(docs?['contents'][index]['startTime'],
                                                        style: const TextStyle(
                                                            fontSize: 14, fontFamily: 'apm', color: Colors.grey)),
                                                    const SizedBox(width: 8),
                                                    Text(docs?['contents'][index]['user'],
                                                        style: const TextStyle(fontSize: 16, fontFamily: 'apeb')),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(4),
                                                          color: switchEdit == true
                                                              ? Colors.orange
                                                              : Colors.grey.shade300),
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(docs?['contents'][index]['text'],
                                                          style: const TextStyle(fontSize: 14, fontFamily: 'apm')),
                                                    ),
                                                    PopupMenuButton<MenuType>(onSelected: (MenuType result) {
                                                      result.toString().split('.')[1] == 'edit'
                                                          ? setterGoPageFeatureInvite(docs?['contents'][index],index)
                                                          : result.toString().split('.')[1] == 'change'
                                                              ? print('kk')
                                                              : print('kk');
                                                    }, itemBuilder: (BuildContext buildContext) {
                                                      return [
                                                        for (final value in MenuType.values)
                                                          PopupMenuItem(
                                                            value: value,
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                value.toString().split('.')[1] == 'edit'
                                                                    ? const Icon(Icons.edit, color: Colors.blueAccent)
                                                                    : value.toString().split('.')[1] == 'change'
                                                                        ? const Icon(Icons.change_circle,
                                                                            color: Colors.green)
                                                                        : const Icon(Icons.delete,
                                                                            color: Colors.redAccent),
                                                                const SizedBox(width: 4),
                                                                Text(value.toString().split('.')[1]),
                                                              ],
                                                            ),
                                                          )
                                                      ];
                                                    }),
                                                  ])));
                                    })));
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                                // 기타 경우 ( 불러오는 중 )
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }))),

                Row(
                  children: [
                    Flexible(
                      flex: 9,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [isRecordOn ? ccKeyColorGreen : Colors.red, ccKeyColorCyan],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                //isRecordOn이 true일때 녹음 기능이 작동하도록 하면 될듯!
                                isRecordOn = !isRecordOn;
                                if (isRecordOn) {
                                  _startListening();
                                  _startsign();
                                } else {
                                  _stopsign();
                                  stopListening();
                                }
                              });
                            },
                            icon: Icon(isRecordOn ? Icons.pause_circle_outline : Icons.play_circle_outline,
                                size: 36, color: Colors.white)),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextButton(
                          onPressed: () {
                            //HttpOverrides.global = NoCheckCertificateHttpOverrides();
                            print('meeting ID: ${widget.meetingId}');
                            endZoomMeeting(widget.meetingId);
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text(
                            '회의 종료',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
