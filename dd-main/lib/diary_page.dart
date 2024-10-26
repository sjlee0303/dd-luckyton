import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'speech_service.dart'; // SpeechService 불러오기
import 'drawer_menu.dart'; // DrawerMenu 불러오기

class DiaryPage extends StatefulWidget {
  final DateTime selectedDate;

  const DiaryPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DateTime _selectedDate;
  String _recordingStatus = "마이크 버튼을 누르고 녹음을 시작하세요";
  bool _isListening = false;
  final SpeechService _speechService = SpeechService(); // SpeechService 인스턴스
  String _recognizedText = "";

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _speechService.initialize();
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  // 녹음 버튼을 눌렀을 때 음성 인식 기능 실행
  void _onRecordButtonPressed() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      _speechService.startListening((resultText) {
        setState(() {
          _recordingStatus = "녹음된 텍스트: $resultText";
          _recognizedText = resultText;
        });
      });
    } else {
      _speechService.stopListening();
      setState(() {
        _recordingStatus = "녹음 중지됨. 마이크 버튼을 눌러 다시 시작하세요.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Scaffold 키 설정
      backgroundColor: const Color(0xFF8B4513), // 배경색 설정
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // 메뉴 버튼 추가
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer(); // Drawer 열기
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: DrawerMenu(), // Drawer 추가
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 날짜 네비게이션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _changeDate(-1),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MM').format(_selectedDate.add(const Duration(days: -1))),
                        style: TextStyle(color: Colors.brown[200], fontSize: 20),
                      ),
                      Text(
                        DateFormat('dd').format(_selectedDate.add(const Duration(days: -1))),
                        style: TextStyle(color: Colors.brown[200], fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _changeDate(-1),
                      icon: const Icon(Icons.arrow_left, color: Colors.white, size: 30),
                    ),
                    Text(
                      DateFormat('MM dd').format(_selectedDate),
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    IconButton(
                      onPressed: () => _changeDate(1),
                      icon: const Icon(Icons.arrow_right, color: Colors.white, size: 30),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _changeDate(1),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MM').format(_selectedDate.add(const Duration(days: 1))),
                        style: TextStyle(color: Colors.brown[200], fontSize: 20),
                      ),
                      Text(
                        DateFormat('dd').format(_selectedDate.add(const Duration(days: 1))),
                        style: TextStyle(color: Colors.brown[200], fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 녹음 안내 메시지 박스
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Text(
                    _recordingStatus,
                    style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          // 마이크 버튼
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: IconButton(
              icon: const Icon(Icons.mic, size: 50, color: Colors.white),
              onPressed: _onRecordButtonPressed, // 버튼 클릭 시 녹음 시작
            ),
          ),
        ],
      ),
    );
  }
}
