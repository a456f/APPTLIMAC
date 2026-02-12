import 'package:flutter/material.dart';
import 'dart:async';

// Modelo para un mensaje de chat
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isTyping;

  ChatMessage({required this.text, required this.isUser, this.isTyping = false});
}

class PlantillasPage extends StatefulWidget {
  const PlantillasPage({super.key});

  @override
  State<PlantillasPage> createState() => _PlantillasPageState();
}

class _PlantillasPageState extends State<PlantillasPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // Para el scroll
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>(); // Para la lista animada
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Mensaje inicial del bot
    _messages.add(ChatMessage(text: "Hola, soy TLI-Bot. Escribe el código o nombre de la plantilla que deseas buscar.", isUser: false));
  }

  void _addBotMessage(String text) {
    // 1. Mostrar indicador de "Escribiendo..."
    final typingMessage = ChatMessage(text: '', isUser: false, isTyping: true);
    
    if (mounted) {
      _messages.insert(0, typingMessage);
      _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 300));
    }

    // Agrega un pequeño retraso para simular que el bot está "pensando"
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        // 2. Quitar indicador
        final index = _messages.indexOf(typingMessage);
        if (index != -1) {
          _messages.removeAt(index);
          _listKey.currentState?.removeItem(index, (context, animation) => _buildAnimatedMessageBubble(typingMessage, animation));
        }

        // 3. Mostrar mensaje real
        _messages.insert(0, ChatMessage(text: text, isUser: false));
        _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
      }
    });
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    final userMessage = text;
    _controller.clear();

    _messages.insert(0, ChatMessage(text: userMessage, isUser: true));
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));

    // Simulación de respuesta del bot
    if (userMessage.trim().toLowerCase() == '1234') {
      const String template = """🔌 PASO 2 - BOT INICIAL

TICKET: VTEXT-40011771

DNI: 40473252

OBSERVACIÓN: 


📸 Debes adjuntar la foto del BOT potencia actual coandato alterois deusiro profaovr y agrge aniaocnprofisonal""";
      _addBotMessage(template);
    } else {
      _addBotMessage("Entendido. Buscando resultados para \"$userMessage\"...");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D0D0D), Color(0xFF000000)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Búsqueda de Plantillas"),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  controller: _scrollController,
                  reverse: true, // Para que el chat crezca desde abajo
                  padding: const EdgeInsets.all(16.0),
                  initialItemCount: _messages.length,
                  itemBuilder: (context, index, animation) {
                    return _buildAnimatedMessageBubble(_messages[index], animation);
                  },
                ),
              ),
              _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }

  // Dibuja la burbuja con animación de entrada
  Widget _buildAnimatedMessageBubble(ChatMessage message, Animation<double> animation) {
    // El mensaje del usuario desliza desde la derecha, el del bot desde la izquierda
    final slideBegin = message.isUser ? const Offset(0.5, 0.0) : const Offset(-0.5, 0.0);

    return SlideTransition(
      position: Tween<Offset>(
        begin: slideBegin,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
        child: _buildMessageBubble(message),
      ),
    );
  }

  // Dibuja la burbuja de chat, con colores estilo WhatsApp
  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isTyping) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: const Color(0xFF202C33),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFB6FF00)),
                ),
              ),
              const SizedBox(width: 8),
              Text("Escribiendo...", style: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      );
    }

    final bubbleAlignment = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isUser ? const Color(0xFF005C4B) : const Color(0xFF202C33);

    return Container(
      alignment: bubbleAlignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(message.text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  // Dibuja el campo de texto y el botón de enviar
  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _handleSubmitted,
              cursorColor: const Color(0xFFB6FF00),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: "Escribe tu búsqueda...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: const Color(0xFF202C33),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFFB6FF00),
            child: IconButton(icon: const Icon(Icons.send, color: Colors.black), onPressed: () => _handleSubmitted(_controller.text)),
          ),
        ],
      ),
    );
  }
}