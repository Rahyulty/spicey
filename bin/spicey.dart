import 'dart:io';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:spicey/spicey_commands.dart';

void main() async {
  print("HELLO?!?!?");
  final token = Platform.environment['discordToken']!;
  final client = NyxxFactory.createNyxxWebsocket(token, GatewayIntents.all);
  final commands = CommandsPlugin(prefix: mentionOr((_) => "?"), options: CommandsOptions(logErrors: false));
  commands
    ..addCommand(avatar)
    ..addCommand(addCode)
    ..addCommand(removecode)
    ..addCommand(getBirthday)
    ..addCommand(addBirthday)
    ..addCommand(getcode)
    ..addCommand(updatecode)
    ..addCommand(ping);

  client
    ..eventsWs.onReady.listen((event) {
      var shardManager = client.shardManager;
      
      shardManager.setPresence(PresenceBuilder.of(
        activity: ActivityBuilder('to my heart', ActivityType.listening)));
    })
    ..eventsWs.onMessageDelete.listen((event) {
      print("Hello");
    })
    ..registerPlugin(Logging())
    ..registerPlugin(CliIntegration())
    ..registerPlugin(IgnoreExceptions())
    ..registerPlugin(Logging(logLevel: Level.ALL))
    ..registerPlugin(commands);

  await client.connect();

    
}