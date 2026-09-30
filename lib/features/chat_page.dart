import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage(this.text, this.isUser);
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      'Halo! Aku Chef AI. Tanya apa aja soal masak-memasak, atau kasih tau bahan yang kamu punya di rumah.',
      false,
    ),
  ];

  final _botReplies = const [
    'Dengan telur, nasi, dan kecap, kamu bisa bikin Nasi Goreng Sederhana! Tumis bawang, masukkan nasi, tambah kecap manis, lalu orak-arik telur di pinggir wajan.',
    'Coba deh Telur Kecap, telur rebus digoreng sebentar lalu disiram saus kecap manis dan bawang goreng.',
    'Kalau mau lebih hemat waktu, orak-arik nasi dengan telur dan sedikit kecap asin juga sudah jadi menu 10 menit yang enak.',
  ];
  int _replyIndex = 0;

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text, true));
      _controller.clear();
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(_botReplies[_replyIndex % _botReplies.length], false));
        _replyIndex++;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.teal,
                child: Icon(Icons.restaurant_menu, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chef AI',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  Text('Online',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.teal,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return Align(
                alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: msg.isUser ? AppColors.coral : AppColors.cardBg,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(msg.isUser ? 14 : 4),
                      bottomRight: Radius.circular(msg.isUser ? 4 : 14),
                    ),
                    border: msg.isUser
                        ? null
                        : Border.all(color: AppColors.textSecondary.withOpacity(0.15)),
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: msg.isUser ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Tulis pertanyaan...',
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                      BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
                    ),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.coral,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  onPressed: _send,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
