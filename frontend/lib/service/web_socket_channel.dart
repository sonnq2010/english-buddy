import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService._singleton();
  static final _instance = WebSocketService._singleton();
  static WebSocketService get I => _instance;

  final _channelUri = Uri.parse(
    'ws://${dotenv.env['API_URL']}:${dotenv.env['API_PORT']}/ws',
  );

  Future<void> initialize() async {
    final channel = WebSocketChannel.connect(_channelUri);
    await channel.ready;

    channel.stream.listen((message) {});
  }

  void test() {}
}
