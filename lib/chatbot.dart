import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

const String GEMINI_API_KEY = "YOUR GIMINI KEY HERE";

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatbotPage(),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  Gemini? gemini; // Use nullable Gemini instance until initialized
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Your Assistant",
    profileImage:
    "https://img.freepik.com/free-vector/floating-robot_78370-3669.jpg?w=740&t=st=1729462220~exp=1729462820~hmac=f9e5372411288e53e0e6fd84558071bea1d7c8749a91233be34e06e21845322e",
  );

  @override
  void initState() {
    super.initState();
    _initializeGemini(); // Initialize Gemini in initState
  }

  // Initialize Gemini API asynchronously
  Future<void> _initializeGemini() async {
    await Gemini.init(
      apiKey: GEMINI_API_KEY,
    );
    setState(() {
      gemini = Gemini.instance; // Set instance after initialization
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Your Assistant",
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.deepPurple, // Set AppBar background color
      ),
      body: Container(
        color: Colors.deepPurple, // Set background color
        child: _buildChatUI(),
      ),
    );
  }

  // Chat UI using DashChat widget
  Widget _buildChatUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(
            Icons.image,
            color: Colors.white, // Set icon color to white
          ),
        )
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
      ),
    );
  }

  // Handle sending a text message
  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    if (gemini == null) {
      // Wait for Gemini to initialize
      return;
    }

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      gemini!.streamGenerateContent(
        question,
        images: images,
      ).listen((event) {
        String response = event.content?.parts?.fold(
            "", (previous, current) => "$previous ${current.text}") ?? "";
        if (messages.isNotEmpty && messages.first.user == geminiUser) {
          ChatMessage lastMessage = messages.removeAt(0);
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage, ...messages];
          });
        } else {
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Handle sending a media (image) message
  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}

