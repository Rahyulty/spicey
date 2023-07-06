import 'dart:io';
import 'dart:async';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:spicey/spicey_commands.dart';
import '../lib/src/Services/db.dart' as db;

void main() async {
  final database = db.MyDatabase('./lib/src/Data');
  final playerTimers = <String, Timer>{};
  final token = Platform.environment['discordToken']!;
  final client = NyxxFactory.createNyxxWebsocket(token, GatewayIntents.all);
  final commands = CommandsPlugin(
      prefix: mentionOr((_) => "?"),
      options: CommandsOptions(logErrors: false));
  commands
    ..addCommand(avatar)
    ..addCommand(addCode)
    ..addCommand(removecode)
    ..addCommand(getBirthday)
    ..addCommand(addBirthday)
    ..addCommand(getcode)
    ..addCommand(timeout)
    ..addCommand(snipe)
    ..addCommand(untimeout)
    ..addCommand(exile)
    ..addCommand(updatecode)
    ..addCommand(listcode)
    ..addCommand(ping);

  client
    ..eventsWs.onReady.listen((event) {
      var shardManager = client.shardManager;

      shardManager.setPresence(PresenceBuilder.of(
          activity: ActivityBuilder('to my heart', ActivityType.listening)));
    })
    ..eventsWs.onMessageReceived.listen((event) async {
      final message = event.message;
      final authorID = message.author.id.toString();
      final channelID = '969183828457422868';
      final user = await client.fetchUser(message.author.id);
      final channel = await client.fetchChannel(Snowflake(channelID));
      print("Recived Message");
      
      if (message.content.toLowerCase() == "shikai timer" && playerTimers.containsKey(authorID) == false) {
        print("Conditions Met, now exucutingh");

         if (channel is ITextChannel){
            await channel.sendMessage(MessageBuilder.content('${user.mention} timer started I will let you know when you can fight your shikai again'));
          }
        playerTimers[authorID] = Timer(Duration(minutes: 30), () async {


          if (channel is ITextChannel){
            await channel.sendMessage(MessageBuilder.content('${user.mention} time for shikai good luck!'));
          }
          
          playerTimers.remove(authorID);
        });
      }
    })
    ..eventsWs.onMessageDelete.listen((event) async {
      // make sure its not the bot message that got deleted
      if (event.message?.author.id.toString() != "1091860915042930799") {
        print("Hello");
        final serverId = event.message?.guild?.id.toString();

        if (serverId == null) return;

        final table = await database.getTable(serverId);

        final deletedMessage = {
          'id': event.message?.id.toString(),
          'content': event.message?.content,
          'author': {
            'id': event.message?.author.id.toString(),
            'username': event.message?.author.username
          }
        };
        if (event.message?.attachments.isEmpty == false) {
          deletedMessage['attachment'] = event.message?.attachments[0].url;
        }

        final messages = table[serverId] ?? <Map<String, dynamic>>[];
        messages.add(deletedMessage);
        table[serverId] = messages;

        await database.setTable(serverId, table);
      }
    })
    ..registerPlugin(Logging())
    ..registerPlugin(CliIntegration())
    ..registerPlugin(IgnoreExceptions())
    ..registerPlugin(commands);

  await client.connect();
}
