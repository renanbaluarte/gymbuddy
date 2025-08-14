import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, String>> qaList = [];
  List<Map<String, String>> messages = [];
  bool showDropdown = false;
  String? selectedQuestion;

  final ScrollController _scrollController = ScrollController(); // ScrollController

  @override
  void initState() {
    super.initState();
    loadQA();
  }

  Future<void> loadQA() async {
    final String jsonString = await rootBundle.loadString('assets/data/chat_data.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      qaList = jsonData.map<Map<String, String>>((item) {
        return {
          'pergunta': item['pergunta'],
          'resposta': item['resposta'],
        };
      }).toList();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void onQuestionSelected(String? question) {
    if (question == null) return;

    final matched = qaList.firstWhere((element) => element['pergunta'] == question);

    setState(() {
      messages.add({'type': 'user', 'text': matched['pergunta']!});
      messages.add({'type': 'bot', 'text': ''}); // Bot começa vazio (digitando)
      selectedQuestion = null;
      showDropdown = false;
    });

    _scrollToBottom(); // Scroll após adicionar pergunta
    _simulateTyping(matched['resposta']!);
  }

  Future<void> _simulateTyping(String fullText) async {
    String currentText = "";
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1)); // Velocidade da digitação
      currentText += fullText[i];
      setState(() {
        messages[messages.length - 1] = {'type': 'bot', 'text': currentText};
      });
      _scrollToBottom(); // Scroll durante a digitação
    }
  }

  Widget buildMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? Colors.green[200] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GymBuddy 🏋️"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text("Faça uma pergunta clicando no botão abaixo"))
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10).copyWith(bottom: 130), // <-- padding inferior
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return buildMessage(
                  message['text']!,
                  message['type'] == 'user',
                );
              },
            ),
          ),
          if (showDropdown)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Escolha uma pergunta',
                ),
                value: selectedQuestion,
                items: qaList
                    .map((qa) => DropdownMenuItem(
                  value: qa['pergunta'],
                  child: Text(qa['pergunta']!),
                ))
                    .toList(),
                onChanged: onQuestionSelected,
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showDropdown
          ? null
          : FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            showDropdown = true;
          });
        },
        label: const Text("Fazer Pergunta"),
        icon: const Icon(Icons.question_answer),
        backgroundColor: Colors.green,
      ),
    );
  }
}
