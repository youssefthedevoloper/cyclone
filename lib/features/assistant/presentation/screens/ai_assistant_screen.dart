import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/widgets/pressable.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Mode toggle
  bool _isCameraMode = false;
  late TabController _modeController;
  
  // Camera related
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  File? _capturedImage;
  String? _extractedText;
  bool _isProcessingImage = false;
  
  // Text recognition
  final TextRecognizer _textRecognizer = TextRecognizer();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: "Hello! I'm Cyclone AI, your smart airport assistant. I can help you in two ways:",
      isAi: true,
      timestamp: DateTime.now(),
      type: _MessageType.welcome,
    ),
    _ChatMessage(
      text: "💬 **Chat Mode**: Ask me anything about the airport, flights, services, or navigation",
      isAi: true,
      timestamp: DateTime.now(),
      type: _MessageType.info,
    ),
    _ChatMessage(
      text: "📸 **Camera Mode**: Take photos of signs, documents, or text - I'll read and help you understand them",
      isAi: true,
      timestamp: DateTime.now(),
      type: _MessageType.info,
    ),
  ];
  @override
  void initState() {
    super.initState();
    _modeController = TabController(length: 2, vsync: this);
    _modeController.addListener(() {
      setState(() {
        _isCameraMode = _modeController.index == 1;
      });
      if (_isCameraMode && !_isCameraInitialized) {
        _initializeCamera();
      }
    });
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras!.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController?.value.isInitialized != true) return;
    
    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = File(photo.path);
        _isProcessingImage = true;
      });
      
      await _extractTextFromImage(File(photo.path));
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _extractTextFromImage(File imageFile) async {
    try {
      final InputImage inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      setState(() {
        _extractedText = recognizedText.text;
        _isProcessingImage = false;
      });
      
      if (_extractedText?.isNotEmpty == true) {
        _addMessage(_ChatMessage(
          text: "📸 I captured an image and extracted this text:\n\n\"$_extractedText\"\n\nHow can I help you with this information?",
          isAi: true,
          timestamp: DateTime.now(),
          type: _MessageType.ocr,
        ));
      } else {
        _addMessage(_ChatMessage(
          text: "📸 I took the photo but couldn't detect any readable text. The image might contain other visual information I can help you with - feel free to describe what you're looking at!",
          isAi: true,
          timestamp: DateTime.now(),
          type: _MessageType.info,
        ));
      }
    } catch (e) {
      setState(() {
        _isProcessingImage = false;
      });
      debugPrint('Text extraction error: $e');
    }
  }
  void _sendMessage([String? presetText]) {
    final text = presetText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    _addMessage(_ChatMessage(
      text: text,
      isAi: false,
      timestamp: DateTime.now(),
      type: _MessageType.user,
    ));
    
    if (presetText == null) _messageController.clear();

    _scrollToBottom();

    _fetchAiResponse(text);
  }

  Future<void> _fetchAiResponse(String text) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: kIsWeb ? 'http://localhost:8000/api' : 'http://10.0.2.2:8000/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ));
      final history = _messages
          .map((m) => {'role': m.isAi ? 'assistant' : 'user', 'text': m.text})
          .toList();
      final resp = await dio.post('/assistant/chat/', data: {
        'message': text,
        'history': history,
      });
      final data = resp.data as Map<String, dynamic>;
      final reply = data['response'] as String?;
      if (reply != null && reply.isNotEmpty && mounted) {
        _addMessage(_ChatMessage(
          text: reply,
          isAi: true,
          timestamp: DateTime.now(),
          type: _MessageType.response,
        ));
        _scrollToBottom();
        return;
      }
    } catch (_) {}

    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _addMessage(_ChatMessage(
        text: _generateIntelligentResponse(text),
        isAi: true,
        timestamp: DateTime.now(),
        type: _MessageType.response,
      ));
      _scrollToBottom();
    });
  }

  void _addMessage(_ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
  }

  String _generateIntelligentResponse(String input) {
    final lower = input.toLowerCase().trim();
    
    // ── Context-aware OCR responses ──
    if (_extractedText?.isNotEmpty == true && _isCameraMode) {
      final extracted = _extractedText!.toLowerCase();
      if (extracted.contains('gate') || extracted.contains('boarding')) {
        return "I can see gate or boarding information in the image. I notice it mentions \"${_extractedText!.length > 80 ? '${_extractedText!.substring(0, 80)}...' : _extractedText}\". Would you like me to help you navigate there or check related flight details?";
      } else if (extracted.contains('flight') || extracted.contains('airline')) {
        return "I detected flight-related text in the image. It appears to contain: \"${_extractedText!.length > 80 ? '${_extractedText!.substring(0, 80)}...' : _extractedText}\". Would you like me to track this flight or find services nearby?";
      } else if (extracted.contains('menu') || extracted.contains('food') || extracted.contains('restaurant')) {
        return "I see what looks like a menu or dining information. The text mentions: \"${_extractedText!.length > 80 ? '${_extractedText!.substring(0, 80)}...' : _extractedText}\". Would you like directions to this place?";
      } else if (extracted.contains('terminal') || extracted.contains('direction') || extracted.contains('map')) {
        return "This appears to be directional or terminal information. I can see: \"${_extractedText!.length > 80 ? '${_extractedText!.substring(0, 80)}...' : _extractedText}\". Need help navigating or finding something specific?";
      }
      return "I extracted this text from the image:\n\n\"${_extractedText!.length > 150 ? '${_extractedText!.substring(0, 150)}...' : _extractedText}\"\n\nHow can I help you with this? Ask me about it!";
    }

    // ── Score-based intent matching ──
    int score(String pattern) {
      int s = 0;
      final words = pattern.split(RegExp(r'\s+'));
      for (final w in words) {
        if (w.startsWith('~')) {
          final fuzzy = w.substring(1);
          if (lower.contains(fuzzy)) {
            s += 3;
          } else if (RegExp('(${fuzzy.substring(0, fuzzy.length > 3 ? fuzzy.length - 2 : 1)})\\w*').hasMatch(lower)) {
            s += 1;
          }
        } else {
          if (lower.contains(w)) s += w.length > 3 ? 4 : 2;
        }
      }
      return s;
    }

    int bestScore = 0;
    String bestResponse = '';

    final responses = <_Intent>[
      // Gates & navigation
      _Intent(['gate', '~find', '~where', '~direction', '~navigate', '~how.*get', '~terminal'], "🚪 **Finding your way:**\n• Check your boarding pass or departure screens for your gate\n• Gates are organized by terminal sections (A, B, C, D)\n• Follow overhead signs to your terminal\n• Need walking directions? Ask for a specific gate!\n\n💡 _Pro tip: The airport has moving walkways between terminals A-B and C-D._"),
      // Security
      _Intent(['security', 'checkpoint', '~screening', '~tsa', '~check.*in', '~bag.*drop'], "🔒 **Security Information:**\n• Security opens at 4:30 AM daily\n• Current estimated wait: 15-20 minutes\n• Fast Track available for premium/business class\n\n**Remember:**\n• Liquids under 100ml in a clear bag\n• Electronics larger than a phone in separate bins\n• Remove belts, jackets, and shoes\n• Boarding pass + ID ready"),
      // Food & dining
      _Intent(['food', 'restaurant', '~eat', '~dining', '~cafe', '~coffee', '~drink', '~hungry', '~lunch', '~dinner', '~breakfast'], "🍽️ **Dining Options by Terminal:**\n\n**Terminal 1:** McDonald's (24h), Starbucks\n**Terminal 2:** Shake Shack, Palm Bar\n**Terminal 4:** Centurion Lounge, Uptown Brasserie\n**Terminal 5:** TWA Hotel Bars, Blue Point Brewery\n\nWant me to find something near your gate?"),
      // Lounges
      _Intent(['lounge', '~priority.*pass', '~vip', '~club', '~relax', '~sit'], "✈️ **Premium Lounge Access:**\n\n**Available Lounges:**\n• Delta Sky Club (Terminals 2 & 4)\n• American Airlines Admirals Club (Terminal 8)\n• Centurion Lounge (Terminal 4, Amex)\n• Chase Sapphire Lounge (Terminal 5)\n• Air France/KLM Lounge (Terminal 1)\n\n**Quick tip:** Priority Pass members get access to select lounges. Ask me which ones!"),
      // WiFi & connectivity
      _Intent(['wifi', 'internet', '~connect', '~online', '~wireless', '~hotspot', '~network'], "📶 **Get Connected:**\n\n**Free WiFi:**\n• Network: `JFK_FREE_WIFI`\n• No password needed — just accept terms\n• Speed: Up to 50 Mbps\n\n**Premium:** \$7.95/day for faster speeds\n\n💡 _Many lounges offer complimentary high-speed WiFi too!_"),
      // Charging
      _Intent(['charging', '~charge', '~power', '~battery', '~plug', '~usb', '~outlet'], "🔋 **Stay Powered Up:**\n\n**Charging Stations:**\n• Near all gates (look for blue charging towers)\n• Built-in USB ports at many seats\n• Lounges have dedicated charging areas\n• Mobile charging stations throughout\n\n**Forgot your charger?** Ask about buying one at the Tech kiosk near Gate B20!"),
      // Restrooms
      _Intent(['bathroom', 'restroom', '~toilet', '~washroom', '~lavatory', '~baby.*change', '~family'], "🚻 **Restrooms & Facilities:**\n\n• Located near all gate areas\n• Before AND after security\n• Family restrooms with changing tables in every terminal\n• Accessible facilities clearly marked\n• Nursing rooms available (ask at info desk)\n\n_Closest restroom is likely within a 2-minute walk from your gate._"),
      // Shopping
      _Intent(['shop', '~store', '~duty.*free', '~buy', '~gift', '~souvenir', '~shopping'], "🛍️ **Shopping Guide:**\n\n**Duty Free Americas:** All terminals\n**Fashion:** Coach, Michael Kors, Swarovski\n**Tech:** Best Buy Express, InMotion\n**NYC Souvenirs:** Multiple locations\n\n🕐 _Most shops open 5 AM - 11 PM_\n\nLooking for something specific?"),
      // Transportation
      _Intent(['transportation', '~airtrain', '~subway', '~taxi', '~uber', '~lyft', '~train', '~bus', '~car', '~rental', '~parking', '~drive', '~manhattan', '~brooklyn', '~lirr'], "🚇 **Ground Transportation:**\n\n**AirTrain JFK:** Connects all terminals (\$7.75)\n• To Subway: Jamaica Station (E, J, Z lines)\n• To LIRR: Jamaica or Howard Beach\n\n**By Car:**\n• Taxi: Flat rate ~\$52 to Manhattan\n• Uber/Lyft: Follow signs to pickup area\n• Rental cars: Shuttle from each terminal\n\n🚌 **Express Bus:** Port Authority & Grand Central"),
      // Lost & Found / Baggage
      _Intent(['lost', '~baggage', '~luggage', '~bag', '~suitcase', '~belonging', '~claim', '~missing', '~left'], "🧳 **Lost & Found Assistance:**\n\n**For Checked Baggage:**\n• Report at your airline's baggage service office\n• Keep your baggage claim ticket handy\n• Track via your airline's mobile app\n• Emergency essentials provided for 6+ hour delays\n\n**For Lost Personal Items:**\n• Visit the airport's Lost & Found (Terminal 4)\n• Or use the Lost & Found feature in this app!\n\nWhich airline are you flying with?"),
      // Currency exchange
      _Intent(['currency', '~exchange', '~money', '~cash', '~atm', '~dollar', '~euro', '~convert'], "💱 **Currency & Banking:**\n\n**Currency Exchange:**\n• Travelex locations in all terminals\n• Better rates at local banks vs airport kiosks\n\n**ATMs:** Widely available throughout\n\n**Cards:** All major credit cards accepted\n\n💡 _Pro tip: Most airport vendors accept cards, so you may not need much cash._"),
      // Medical / Emergency
      _Intent(['medical', 'pharmacy', '~doctor', '~hospital', '~nurse', '~medicine', '~pill', '~pain', '~sick', '~injury', '~first.?aid', '~emergency', '~ambulance'], "🏥 **Medical & Emergency Services:**\n\n**First Aid Stations:** Located in each terminal\n**Pharmacy:** Terminal 4 (7 AM - 9 PM)\n\n**Emergency:** Call **911** or ask any staff member\n• AED units throughout the airport\n• Medical personnel on duty 24/7\n\nNeed directions to the nearest first aid station?"),
      // Flight status
      _Intent(['flight', '~status', '~delay', '~cancelled', '~on.?time', '~departure', '~arrival', '~depart', '~land', '~take.?off', '~time', '~schedule'], "✈️ **Flight Information:**\n\nCheck your flight status in the **Flights** tab for:\n• Real-time departure/arrival times\n• Gate assignments and changes\n• Delay and cancellation alerts\n• Boarding status\n\nI can also help you find your way to the gate once it's assigned! Need directions?"),
    ];

    for (final intent in responses) {
      final s = score(intent.pattern.join(' '));
      if (s > bestScore) {
        bestScore = s;
        bestResponse = intent.response;
      }
    }

    if (bestScore > 2) return bestResponse;

    // ── Catch-all: suggest topics from the input ──
    final topics = <String>[];
    final topicMap = {
      'gate': 'gate locations',
      'terminal': 'terminal info',
      'flight': 'flight status',
      'security': 'security info',
      'food': 'dining options',
      'restaurant': 'dining',
      'wifi': 'WiFi info',
      'lounge': 'lounge access',
      'shop': 'shopping',
      'baggage': 'baggage help',
      'transport': 'ground transport',
      'hotel': 'nearby hotels',
      'time': 'flight times',
      'delay': 'flight delays',
      'lost': 'lost & found',
      'help': 'assistance',
    };
    for (final e in topicMap.entries) {
      if (lower.contains(e.key)) topics.add(e.value);
    }

    final suggestions = topics.isNotEmpty
        ? topics.take(3).map((t) => '• $t').join('\n')
        : '• Gate locations and directions\n• Dining and shopping options\n• Ground transportation\n• Security and check-in\n• Flight information';

    return "I understand you're asking about \"$input\". I'd love to help! Here are some things I can assist with:\n\n$suggestions\n\nWhat specifically would you like to know?";
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _modeController.dispose();
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cyclone AI',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  Text(
                    _isCameraMode ? 'Camera & OCR Mode' : 'Intelligent Chat Mode',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: TabBar(
              controller: _modeController,
              indicator: BoxDecoration(
                gradient: AppColors.aiGradient,
                borderRadius: BorderRadius.circular(23),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  icon: Icon(Icons.chat_bubble_outline, size: 18),
                  text: 'Chat',
                ),
                Tab(
                  icon: Icon(Icons.camera_alt_outlined, size: 18),
                  text: 'Camera',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _modeController,
        children: [
          _buildChatMode(),
          _buildCameraMode(),
        ],
      ),
    );
  }
  Widget _buildChatMode() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return _ChatBubble(message: msg)
                  .animate()
                  .fadeIn(delay: (50 * index).ms)
                  .slideY(begin: 0.05);
            },
          ),
        ),
        
        // Quick Actions
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _QuickPromptChip(
                label: '🚪 Find my gate',
                onTap: () => _sendMessage('How do I find my departure gate?'),
              ),
              _QuickPromptChip(
                label: '🍽️ Food nearby',
                onTap: () => _sendMessage('What restaurants are near my gate?'),
              ),
              _QuickPromptChip(
                label: '📶 WiFi help',
                onTap: () => _sendMessage('How do I connect to airport WiFi?'),
              ),
              _QuickPromptChip(
                label: '🚇 Transportation',
                onTap: () => _sendMessage('How do I get to Manhattan from here?'),
              ),
              _QuickPromptChip(
                label: '✈️ Lounge access',
                onTap: () => _sendMessage('Which lounges can I access?'),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildCameraMode() {
    return Column(
      children: [
        // Camera Preview
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              child: _buildCameraPreview(),
            ),
          ),
        ),
        
        // Camera Controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildCameraButton(
                  icon: Icons.refresh,
                  label: 'Retake',
                  onTap: () {
                    setState(() {
                      _capturedImage = null;
                      _extractedText = null;
                    });
                  },
                  isEnabled: _capturedImage != null,
                ),
              ),
              Expanded(
                child: _buildCameraButton(
                  icon: Icons.camera_alt,
                  label: 'Capture',
                  onTap: _takePicture,
                  isEnabled: _isCameraInitialized && !_isProcessingImage,
                  isPrimary: true,
                ),
              ),
              Expanded(
                child: _buildCameraButton(
                  icon: Icons.help_outline,
                  label: 'Tips',
                  onTap: () => _showCameraTips(),
                  isEnabled: true,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Chat messages for camera mode
        Expanded(
          flex: 2,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return _ChatBubble(message: msg, isCompact: true)
                  .animate()
                  .fadeIn(delay: (50 * index).ms)
                  .slideY(begin: 0.05);
            },
          ),
        ),
        
        const SizedBox(height: 12),
        _buildMessageInput(),
      ],
    );
  }
  Widget _buildCameraPreview() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_capturedImage != null) {
      return Stack(
        children: [
          Image.file(
            _capturedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          if (_isProcessingImage)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Extracting text...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }
    
    if (!_isCameraInitialized) {
      return Container(
        color: isDark ? AppColors.darkBackground : AppColors.background,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return CameraPreview(_cameraController!);
  }

  Widget _buildCameraButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isEnabled,
    bool isPrimary = false,
  }) {
    return Pressable(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary && isEnabled ? AppColors.aiGradient : null,
          color: !isPrimary
              ? (isEnabled ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1))
              : null,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isEnabled ? AppColors.primary : Colors.grey,
            width: isPrimary ? 0 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary
                  ? Colors.white
                  : (isEnabled ? AppColors.primary : Colors.grey),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isPrimary
                    ? Colors.white
                    : (isEnabled ? AppColors.primary : Colors.grey),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMessageInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: _isCameraMode
                      ? 'Ask about the captured text...'
                      : 'Ask Cyclone AI anything...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Pressable(
            onTap: () => _sendMessage(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aiGradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCameraTips() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📸 Camera Tips',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const _TipItem(
              icon: '🔍',
              title: 'Clear Text',
              description: 'Ensure text is well-lit and in focus for best OCR results',
            ),
            const _TipItem(
              icon: '📋',
              title: 'Hold Steady',
              description: 'Keep the camera steady when capturing documents or signs',
            ),
            const _TipItem(
              icon: '💡',
              title: 'Good Lighting',
              description: 'Use natural light when possible, avoid shadows on text',
            ),
            const _TipItem(
              icon: '📏',
              title: 'Proper Distance',
              description: 'Fill the frame with text, but don\'t get too close',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Got it!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
enum _MessageType {
  user,
  response,
  welcome,
  info,
  ocr,
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isAi,
    required this.timestamp,
    required this.type,
  });
  
  final String text;
  final bool isAi;
  final DateTime timestamp;
  final _MessageType type;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    this.isCompact = false,
  });
  
  final _ChatMessage message;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: isCompact ? 8 : 12),
      child: Row(
        mainAxisAlignment: message.isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isAi) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                message.type == _MessageType.ocr
                    ? Icons.camera_alt
                    : Icons.auto_awesome,
                color: Colors.white,
                size: isCompact ? 12 : 14,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 12 : 16,
                vertical: isCompact ? 8 : 12,
              ),
              decoration: BoxDecoration(
                gradient: message.isAi ? null : AppColors.primaryGradient,
                color: message.isAi
                    ? (isDark ? AppColors.darkSurface : AppColors.surface)
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isAi ? 4 : 20),
                  bottomRight: Radius.circular(message.isAi ? 20 : 4),
                ),
                border: message.isAi
                    ? Border.all(
                        color: isDark
                            ? AppColors.darkBorder.withValues(alpha: 0.5)
                            : AppColors.border)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkBackground.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isAi
                      ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                      : Colors.white,
                  fontSize: isCompact ? 12 : 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickPromptChip extends StatelessWidget {
  const _QuickPromptChip({
    required this.label,
    required this.onTap,
  });
  
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Pressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({
    required this.icon,
    required this.title,
    required this.description,
  });
  
  final String icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Intent {
  final List<String> pattern;
  final String response;
  const _Intent(this.pattern, this.response);
}