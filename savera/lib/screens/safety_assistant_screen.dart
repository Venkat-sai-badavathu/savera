import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/colors.dart';

class SafetyAssistantScreen extends StatefulWidget {
  const SafetyAssistantScreen({Key? key}) : super(key: key);

  @override
  _SafetyAssistantScreenState createState() => _SafetyAssistantScreenState();
}

class _SafetyAssistantScreenState extends State<SafetyAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final Connectivity _connectivity = Connectivity();

  // API Configuration
  final String apiUrl = dotenv.get(
    'SAFETY_ASSISTANT_API_URL',
    fallback: 'http://192.168.42.139:5000/api/message',
  );

  @override
  void initState() {
    super.initState();
    // Initial greeting from the assistant
    _messages.add(
      ChatMessage(
        text: "Hello! I'm your Safety Assistant. How can I help you today?",
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _checkInternetConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _sendMessage() async {
    final String userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    // Clear input and add user message
    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    // Check internet connection first
    if (!await _checkInternetConnection()) {
      _showError('No internet connection');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': userMessage}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String botReply =
            responseData['reply'] ??
            "I couldn't understand that. Can you rephrase?";

        setState(() {
          _messages.add(ChatMessage(text: botReply, isUser: false));
        });
      } else {
        _handleApiError(response.statusCode, response.body);
      }
    } catch (e) {
      _showError('Failed to connect: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _handleApiError(int statusCode, String body) {
    String errorMessage;
    switch (statusCode) {
      case 400:
        errorMessage = 'Invalid request';
        break;
      case 404:
        errorMessage = 'Service not found';
        break;
      case 500:
        errorMessage = 'Server error';
        break;
      default:
        errorMessage = 'Error: $statusCode';
    }
    _showError(errorMessage);

    // Add error message to chat
    setState(() {
      _messages.add(
        ChatMessage(
          text: "I'm having trouble responding. Please try again later.",
          isUser: false,
        ),
      );
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Safety Assistant',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your safety concern...',
                hintStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isUser
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// >curl -X POST http://localhost:5000/api/message -H "Content-Type: application/json" -d "{\"message\": \"Hi, I feel unsafe\"}"
// {"reply":"I'm really sorry to hear that you're feeling this way, but I'm unable to provide the help that you need. 
//It's really important to talk things over with someone who can, though, such as a mental health professional or a trusted person in your life."}

//curl.exe -X POST http://localhost:5000/api/panic-detect -F "image=@C:\Users\HP\Desktop\App\savera2.0\backend\crowded.jpeg"
