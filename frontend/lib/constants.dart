enum Gender { male, female, all }

enum EnglishLevel { a1, a2, b1, b2, c1, c2, all }

enum WebSocketMessageType {
  id,
  join,
  offer,
  answer,
  candidates,
  skip,
  stop,
  chat,
  undefined;

  static WebSocketMessageType fromString(String type) {
    switch (type) {
      case 'id':
        return id;
      case 'join':
        return join;
      case 'offer':
        return offer;
      case 'answer':
        return answer;
      case 'candidates':
        return candidates;
      case 'skip':
        return skip;
      case 'stop':
        return stop;
      case 'chat':
        return chat;
      default:
        return undefined;
    }
  }
}
