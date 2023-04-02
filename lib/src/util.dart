library spicey;

import 'dart:io';
import 'dart:math';
import 'package:nyxx/nyxx.dart';
import 'package:dio/dio.dart';
import 'package:dio_client_deta_api/dio_client_deta_api.dart';
import 'package:deta/deta.dart';


class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;
  
  Tuple(this.item1, this.item2);
}

final List<String> canChange = ["1040459248938782770","450766617953959936", "635186009474203677", "196252989076275200"];

final guildSettingsDefault = {
  'birthdayChannel' : '',
};


var detaKey = Platform.environment['detaKey']!;

final deta = Deta(
  projectKey: detaKey,
  client: DioClientDetaApi(dio: Dio()),
);


DiscordColor getRandomColor() {
  final random = Random();

  return DiscordColor.fromRgb(random.nextInt(255), random.nextInt(255), random.nextInt(255));
}



String getKeyFromValue(String value, Map map) {
  return map.keys.firstWhere((key) => map[key] == value, orElse: () => '');
}

void replaceValue(Map<String, dynamic> map, String key, dynamic value) {
  if (map.containsKey(key)) {
    map[key] = value;
  }
}

void addKeyValuePair(Map<String, dynamic> map, String key, dynamic value) {
  map[key] = value;
}

bool valueExistsInList(dynamic value, List<dynamic> list) {
  return list.contains(value);
}

IGuildChannel? getChannel(IGuild guild, String channelId) {
  return guild.channels.firstWhere((channel) => channel.id.toString() == channelId);
}

void removeKeyValue(Map<String, dynamic> map, String key) {
  if (map.containsKey(key)) {
    map.remove(key);
  }
}

bool isValidDateFormat(String input) {
  RegExp regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  return regex.hasMatch(input);
}

int extractYear(String birthday) {
  if (isValidDateFormat(birthday) == false) {
    throw FormatException('Invalid birthday format. Must be YYYY-DD-MM');
  }
  List<String> parts = birthday.split('-');
  int year = int.parse(parts[0]);
  return year;
}


Tuple<int, int> calculateAges(String birthdayString) {
  final birthday = DateTime.parse(birthdayString);
  final now = DateTime.now();
  
  int currentAge = now.year - birthday.year;
  int nextAge = currentAge + 1;
  
  if (now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)) {
    currentAge--;
    nextAge--;
  }
  
  return Tuple(currentAge, nextAge);
}

int calculateAge(String birthdayString) {
  final birthday = DateTime.parse(birthdayString);
  final now = DateTime.now();
  int age = now.year - birthday.year;
  if (now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)) {
    age--;
  }
  return age;
}


String formatMap(Map<String, dynamic> map) {
  final buffer = StringBuffer();
  buffer.writeln('Map contents:');

  for (final entry in map.entries) {
    buffer.writeln('${entry.key}: ${entry.value}');
  }

  return buffer.toString();
}


EmbedBuilder errorMessage(String error){
  EmbedBuilder embed = EmbedBuilder()
    ..color = getRandomColor()
    ..title = "Uh oh!"
    ..description = error;

  return embed;
} 

EmbedBuilder sucessMessage(String message){
  EmbedBuilder embed = EmbedBuilder()
    ..color = getRandomColor()
    ..title = "Sucess!"
    ..description = message;
  
  return embed;
}

class BulkSnowflakes {
  List<Snowflake> action(List<String> x) {
    List<Snowflake> dat = [];
    x.forEach((element) {
      dat.add(Snowflake(element));
    });
    return dat;
  }
}