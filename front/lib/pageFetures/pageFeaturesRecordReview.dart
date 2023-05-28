import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front/dataSets/dataSetColors.dart';
import 'package:front/pageFetures/pageFeaturesInvite.dart';
import 'package:rxdart/rxdart.dart';
import '../dataSets/dataSetTextStyles.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:async';
import '../firestore/firebaseController.dart';
import '../testFeatures/requsestOpenMeeting.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/widgetCommonAppbarM.dart';

class PageFeatureRecordReView extends StatefulWidget {
  const PageFeatureRecordReView({Key? key, required this.meetingInfo, required this.userInfo})
      : super(key: key);
  final Map<String, dynamic>? meetingInfo;
  final Map<String, dynamic>? userInfo;

  @override
  State<PageFeatureRecordReView> createState() => _PageFeatureRecordReViewState();
}

enum MenuType {
  edit,
  change,
  delete,
}

class _PageFeatureRecordReViewState extends State<PageFeatureRecordReView> {
  //dataSet
  final ScrollController agendaListViewScroller = ScrollController();
  late bool isRecordOn;
  late List<bool> statusCheck;
  late int currentTime;
  late List<String> agendaList = [];
  late List<dynamic> talk = [];
  TextEditingController manualTextController = TextEditingController();
  String manualText = '';
  FocusNode myFocusNode = FocusNode();

  var statuses = BehaviorSubject<String>();
  final TextEditingController _textEditingController = TextEditingController();
  var words = StreamController<SpeechRecognitionResult>();
  ScrollController contentsScroll = ScrollController();
  bool stopsign = false;
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

  setterGoPageFeatureInvite(var contentPrev, int index) {
    TextEditingController tt = TextEditingController();
    tt.text = contentPrev['text'];
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
                        hintText: '회의명 입력')),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('취소', style: TextStyle(fontFamily: 'apeb'))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      FirebaseController().editMeetingContents(widget.meetingInfo!['password'], contentPrev, index);
                      FeaturesMeeting()
                          .editNotion(contentPrev['startTime'], widget.meetingInfo!['Id'], contentPrev['text']);
                    },
                    child: Text('수정', style: TextStyle(fontFamily: 'apeb', color: ccKeyColorGreen)))
              ]);
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

  @override
  void dispose() {
    _textEditingController.removeListener(_onTextChanged);
    _textEditingController.dispose();
  }

  void _startsign() {
    print("_startsign");
    stopsign = false;
  }

  void _stopsign() {
    print("_stopsign");
    stopsign = true;
  }

  void _onTextChanged() {
    // print(_textEditingController.text);
    if (stopsign) {
      stopListening();
    } else {
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
                    .patchNotion(dt2.toString(), widget.meetingInfo!['Id'], widget.userInfo!['userName'], result)
                    .then((_) {
                  FirebaseController().updateMeetingContents(widget.meetingInfo!['password'],
                      widget.userInfo!['userName'], dt2.toString(), dt2_end.toString(), result);
                });
              }
            } else {
              print(_textList.first);
              var dt2_end = DateTime.now();
              featuresMeeting
                  .patchNotion(dt2.toString(), widget.meetingInfo!['Id'], widget.userInfo!['userName'], _textList.first)
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
      body: Container(
        color: crKeyColorB1Talk,
        height: double.infinity,
        //자식들을 담을 column
        child: Column(
          //세로 정렬 : start( 시작점 부터 )
            mainAxisAlignment: MainAxisAlignment.start,
            //가로 정렬 : start ( 시작점 부터 )
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //row:현재 회의 상태 표시
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: crKeyColorB1Menu,
                    borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
                child: Row(children: <Widget>[
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Text('${widget.meetingInfo!['meetingName']}', style: h1C),
                    Text(
                      '${widget.meetingInfo!['startTime']} · 참여자 ${widget.meetingInfo!['etc'].length}명',
                      style: const TextStyle(fontFamily: 'apb', color: Colors.grey),
                    )
                  ]),
                  const Expanded(child: SizedBox()),
                  Text('$currentTime', style: b1eb),
                  const SizedBox(width: 12),
                  isRecordOn
                      ? const Text('녹음 중', style: TextStyle(fontFamily: 'apeb', color: Colors.blueAccent, fontSize: 20))
                      : const Text('일시 정지 중',
                      style: TextStyle(fontFamily: 'apeb', color: Colors.redAccent, fontSize: 20)),
                  const SizedBox(width: 8),
                ]),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: streamConnectContents,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          Map<String, dynamic>? docs = snapshot.data?.docs.first.data();
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List<Widget>.generate(
                                  docs?['etc'].length,
                                      (index) => WidgetCircleAvatarRecord(
                                      userName: docs?['etc'][index]['userName'], isClerk: index == 0 ? true : false)));
                        } else if (snapshot.hasError) {
                          return const Text('Error');
                          // 기타 경우 ( 불러오는 중 )
                        } else {
                          return const CircularProgressIndicator();
                        }
                      })),
              Expanded(
                  child: Container(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: streamConnectContents,
                          builder: (context, snapshot) {
                            //에러 없이 데이터가 성공적으로 수신되었다면
                            if (snapshot.hasData && snapshot.data != null) {
                              Map<String, dynamic>? docs = snapshot.data?.docs.first.data();
                              return SingleChildScrollView(
                                  reverse: true,
                                  child: Column(
                                      children: List.generate(docs?['contents'].length, (index) {
                                        return docs?['contents'][index]['user'] == widget.userInfo!['userName']
                                            ? Container(
                                          width: double.infinity,
                                          child: ListTile(
                                              title: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                                  child: Container(
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          const SizedBox(width: 8),
                                                          //프로필
                                                          CircleAvatar(
                                                              backgroundColor: Colors.white,
                                                              child: Text(docs?['contents'][index]['user'][0],
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontFamily: 'apeb',
                                                                      color: crKeyColorB1F))),
                                                          const SizedBox(width: 8),
                                                          //말풍선
                                                          Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                                                  child: Text(docs?['contents'][index]['user'],
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontFamily: 'apeb',
                                                                          color: crKeyColorB1F)),
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    constraints: const BoxConstraints(
                                                                        minWidth: 100, maxWidth: 240),
                                                                    width: 240,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.only(
                                                                            bottomRight: Radius.circular(12),
                                                                            bottomLeft: Radius.circular(12),
                                                                            topRight: Radius.circular(12)),
                                                                        color: Colors.white),
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(docs?['contents'][index]['text'],
                                                                              style: const TextStyle(
                                                                                  fontSize: 14, fontFamily: 'apm')),
                                                                          Row(children: [
                                                                            Expanded(child: SizedBox()),
                                                                            Text(
                                                                                docs?['contents'][index]['startTime'],
                                                                                style: const TextStyle(
                                                                                    fontSize: 10,
                                                                                    fontFamily: 'apl',
                                                                                    color: Colors.grey)),
                                                                          ])
                                                                        ]))
                                                              ]),
                                                          PopupMenuButton<MenuType>(
                                                              color: crKeyColorB1F,
                                                              onSelected: (MenuType result) {
                                                                result.toString().split('.')[1] == 'edit'
                                                                    ? setterGoPageFeatureInvite(
                                                                    docs?['contents'][index], index)
                                                                    : result.toString().split('.')[1] == 'change'
                                                                    ? print('kk')
                                                                    : FirebaseController()
                                                                    .deleteMeetingContents(
                                                                    widget.meetingInfo!['password'],
                                                                    docs?['contents'][index],
                                                                    index)
                                                                    .then((_) {
                                                                  // FeaturesMeeting().deleteNotion(
                                                                  //     docs?['contents'][index]['startTime'],
                                                                  //     widget.meetingInfo!['Id'],
                                                                  //     docs?['contents'][index]['text']);
                                                                });
                                                              },
                                                              itemBuilder: (BuildContext buildContext) {
                                                                return [
                                                                  for (final value in MenuType.values)
                                                                    PopupMenuItem(
                                                                      value: value,
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          value.toString().split('.')[1] == 'edit'
                                                                              ? const Icon(Icons.edit,
                                                                              color: Colors.blueAccent)
                                                                              : value.toString().split('.')[1] ==
                                                                              'change'
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
                                                              })
                                                        ]),
                                                  ))),
                                        )
                                            : ListTile(
                                            title: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 6),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      const SizedBox(width: 8),
                                                      //프로필
                                                      CircleAvatar(
                                                          backgroundColor: Colors.white,
                                                          child: Text(docs?['contents'][index]['user'][0],
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: 'apeb',
                                                                  color: crKeyColorB1F))),
                                                      const SizedBox(width: 8),
                                                      //말풍선
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                                          child: Text(docs?['contents'][index]['user'],
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: 'apeb',
                                                                  color: crKeyColorB1F)),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Container(
                                                            alignment: Alignment.centerLeft,
                                                            constraints:
                                                            const BoxConstraints(minWidth: 100, maxWidth: 240),
                                                            width: 240,
                                                            decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.only(
                                                                    bottomRight: Radius.circular(12),
                                                                    bottomLeft: Radius.circular(12),
                                                                    topRight: Radius.circular(12)),
                                                                color: Colors.grey.shade300),
                                                            padding: const EdgeInsets.all(8),
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(docs?['contents'][index]['text'],
                                                                      style: const TextStyle(
                                                                          fontSize: 14, fontFamily: 'apm')),
                                                                  Row(children: [
                                                                    Expanded(child: SizedBox()),
                                                                    Text(docs?['contents'][index]['startTime'],
                                                                        style: const TextStyle(
                                                                            fontSize: 10,
                                                                            fontFamily: 'apl',
                                                                            color: Colors.grey)),
                                                                  ])
                                                                ]))
                                                      ]),
                                                      PopupMenuButton<MenuType>(
                                                          color: crKeyColorB1F,
                                                          onSelected: (MenuType result) {
                                                            result.toString().split('.')[1] == 'edit'
                                                                ? setterGoPageFeatureInvite(
                                                                docs?['contents'][index], index)
                                                                : result.toString().split('.')[1] == 'change'
                                                                ? print('kk')
                                                                : FirebaseController()
                                                                .deleteMeetingContents(
                                                                widget.meetingInfo!['password'],
                                                                docs?['contents'][index],
                                                                index)
                                                                .then((_) {
                                                              // FeaturesMeeting().deleteNotion(
                                                              //     docs?['contents'][index]['startTime'],
                                                              //     widget.meetingInfo!['Id'],
                                                              //     docs?['contents'][index]['text']);
                                                            });
                                                          },
                                                          itemBuilder: (BuildContext buildContext) {
                                                            return [
                                                              for (final value in MenuType.values)
                                                                PopupMenuItem(
                                                                  value: value,
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      value.toString().split('.')[1] == 'edit'
                                                                          ? const Icon(Icons.edit,
                                                                          color: Colors.blueAccent)
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
                                                          })
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
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(color: crKeyColorB1L, borderRadius: BorderRadius.circular(32)),
                        height: 48,
                        child: Row(
                          children: <Widget>[
                            const SizedBox(width: 8),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 16, 4),
                                  child: TextField(
                                    autofocus: true,
                                    style: TextStyle(fontFamily: 'apeb', color: crKeyColorB1F),
                                    controller: manualTextController,
                                    onChanged: (val) {
                                      manualText = val;
                                    },
                                    focusNode: myFocusNode,
                                    onSubmitted: (val) {
                                      FirebaseController().updateMeetingContents(
                                          widget.meetingInfo!['password'],
                                          widget.userInfo!['userName'],
                                          DateTime.now().toString(),
                                          DateTime.now().toString(),
                                          manualText);
                                      manualTextController.clear();
                                      manualText = '';
                                      myFocusNode.requestFocus();
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: '수동 기록할 내용 입력',
                                        hintStyle: TextStyle(color: Colors.white)),
                                  ),
                                )),
                            IconButton(
                                onPressed: () {
                                  FirebaseController().updateMeetingContents(
                                      widget.meetingInfo!['password'],
                                      widget.userInfo!['userName'],
                                      DateTime.now().toString(),
                                      DateTime.now().toString(),
                                      manualText);
                                  manualTextController.text = '';
                                  manualText = '';
                                },
                                icon: const Icon(Icons.send, size: 16, color: Colors.green))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(primary: Colors.transparent, elevation: 0),
                        child: const Text('닫기',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'apeb')),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}

class WidgetCircleAvatarRecord extends StatelessWidget {
  WidgetCircleAvatarRecord({
    Key? key,
    required this.userName,
    required this.isClerk,
  }) : super(key: key);
  final String userName;
  final bool isClerk;

  @override
  Widget build(BuildContext context) {
    return isClerk == true
        ? Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4.0)),
            height: 20,
            width: 24,
            child: Text('서기', style: TextStyle(fontSize: 12, fontFamily: 'aepb', color: crKeyColorB1F))),
        const SizedBox(width: 4.0),
        Text(
          userName,
          style: const TextStyle(fontFamily: 'apm', fontSize: 12, color: Colors.white),
        ),
        const SizedBox(width: 8.0)
      ],
    )
        : Row(
      children: <Widget>[
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.blueAccent,
          child: Text(userName[0], style: const TextStyle(fontFamily: 'apeb', fontSize: 16, color: Colors.white)),
        ),
        const SizedBox(width: 4.0),
        Text(
          userName,
          style: const TextStyle(fontFamily: 'apm', fontSize: 12, color: Colors.white),
        ),
        const SizedBox(width: 8.0)
      ],
    );
  }
}
