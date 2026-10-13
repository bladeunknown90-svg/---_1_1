import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MultiplicationGameApp());
}

class MultiplicationGameApp extends StatelessWidget {
  const MultiplicationGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'العاب جدول الضرب',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // خلفية داكنة مريحة للعين
        primaryColor: Colors.amber,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random _random = Random();
  
  // المتغيرات الأساسية للعبة
  int num1 = 2;
  int num2 = 3;
  int score = 0;
  int totalQuestions = 0;
  
  List<int> options = [];
  int? selectedAnswer;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  // توليد سؤال جديد مع خيارات ذكية قريبة من الإجابة الصحيحة
  void generateNewQuestion() {
    setState(() {
      // اختيار أرقام عشوائية لجدول الضرب من 2 إلى 12
      num1 = _random.nextInt(11) + 2; 
      num2 = _random.nextInt(11) + 2;
      
      int correctAnswer = num1 * num2;
      isAnswered = false;
      selectedAnswer = null;

      // توليد خيارات خاطئة قريبة من الإجابة الصحيحة لتحدي التكرار والحفظ
      Set<int> falseOptions = {};
      while (falseOptions.size < 3) {
        int wrong = correctAnswer + (_random.nextInt(11) - 5);
        if (wrong != correctAnswer && wrong > 0) {
          falseOptions.add(wrong);
        }
      }

      options = falseOptions.toList();
      options.add(correctAnswer);
      options.shuffle(); // ترتيب الخيارات بشكل عشوائي
    });
  }

  // التحقق من إجابة المستخدم
  void checkAnswer(int answer) {
    if (isAnswered) return; // منع الضغط المتكرر بعد الإجابة

    setState(() {
      isAnswered = true;
      selectedAnswer = answer;
      totalQuestions++;
      if (answer == (num1 * num2)) {
        score++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int correctAnswer = num1 * num2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎯 بطل جدول الضرب',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.amber),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // لوحة النتيجة والعدادات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreCard('النقاط', '$score', Colors.green),
                _buildScoreCard('المحاولات', '$totalQuestions', Colors.blueAccent),
              ],
            ),

            // صندوق السؤال الأساسي للتكرار والحفظ
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$num1', style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    style: TextStyle(fontSize: 40, color: Colors.amber, fontWeight: FontWeight.bold),
                    child: Text('×'),
                  ),
                  Text('$num2', style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    style: TextStyle(fontSize: 40, color: Colors.amber, fontWeight: FontWeight.bold),
                    child: Text('='),
                  ),
                  const Text('؟', style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.amber)),
                ],
              ),
            ),

            // قائمة أزرار الخيارات المتعددة
            Column(
              children: options.map((option) {
                Color buttonColor = const Color(0xFF334155); // اللون الافتراضي للزر
                
                if (isAnswered) {
                  if (option == correctAnswer) {
                    buttonColor = Colors.green; // يظهر الأخضر للإجابة الصحيحة دائماً
                  } else if (option == selectedAnswer) {
                    buttonColor = Colors.red; // يظهر الأحمر إذا اختار المستخدم إجابة خاطئة
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () => checkAnswer(option),
                      child: Text(
                        '$option',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // زر الانتقال للسؤال التالي لتكرار العملية وتثبيت الحفظ
            if (isAnswered)
              SizedBox(
                width: 200,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: generateNewQuestion,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 28),
                  label: const Text('التالي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              )
            else
              const SizedBox(height: 55), // مساحة فارغة للحفاظ على توازن الواجهة
          ],
        ),
      ),
    );
  }

  // ودجت مخصصة لعرض عداد النقاط
  Widget _buildScoreCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}