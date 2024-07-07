enum ButtonSize { large, small }

enum Gender {
  male,
  female,
  all;

  static Gender fromString(String? string) {
    switch (string) {
      case 'male':
        return male;
      case 'female':
        return female;
      default:
        return all;
    }
  }
}

enum EnglishLevel {
  a1,
  a2,
  b1,
  b2,
  c1,
  c2,
  all;

  static EnglishLevel fromString(String? string) {
    switch (string) {
      case 'a1':
        return a1;
      case 'a2':
        return a2;
      case 'b1':
        return b1;
      case 'b2':
        return b2;
      case 'c1':
        return c1;
      case 'c2':
        return c2;
      default:
        return all;
    }
  }
}

enum WebSocketMessageType {
  id,
  join,
  offer,
  answer,
  candidates,
  skip,
  stop,
  chat,
  unknown;

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
        return unknown;
    }
  }
}
