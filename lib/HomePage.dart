import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_ai/message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _Messages = [];
  bool _isLoading = false;

  callGeminiModel() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _Messages.add(Message(text: _controller.text, isUser: true));
        _isLoading = true;
      });

      try {
        final model = GenerativeModel(
            model: 'gemini-pro', apiKey: dotenv.env['GOOGLE_API_KEY']!);
        final prompt = _controller.text.trim();
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);

        setState(() {
          if (response.text != null) {
            _Messages.add(Message(text: response.text!, isUser: false));
          }
          _isLoading = false;
        });
        _controller.clear();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: false,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/ai.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Open AI",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              Image.asset(
                'assets/user.png',
                height: 30,
                width: 30,
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _Messages.length,
                  itemBuilder: (context, index) {
                    final message = _Messages[index];
                    return ListTile(
                      title: Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: message.isUser
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: message.isUser
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      )
                                    : BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      )),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                  color: message.isUser
                                      ? Colors.white
                                      : Colors.black),
                            )),
                      ),
                    );
                  }),
            ),

            //User Input
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 32, top: 16.0, left: 16.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: "Write Your Message",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20)),
                      ),
                    ),
                    SizedBox(width: 8),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              child: Image.asset(
                                'assets/send.png',
                                width: 30,
                                height: 30,
                              ),
                              onTap: callGeminiModel,
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
