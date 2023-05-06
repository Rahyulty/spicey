import 'dart:async';
import 'dart:convert';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx/nyxx.dart';
import 'package:spicey/src/util.dart';
import '../Services/checks.dart';

final detabase = deta.base('ragenki-ps');

var check = GuildCheck.id(Snowflake(798666698873503814));

ChatCommand listcode = ChatCommand(
    'list-codes',
    'list all codes',
    id('list', (IChatContext context) async {
      var rawcodes = await detabase.get('codes');
      var codes = jsonDecode(rawcodes['codes']) as Map<String, dynamic>;

      EmbedBuilder embed = EmbedBuilder()
        ..color = getRandomColor();

      // loop through the database
      codes.forEach((key, value) {
        embed.addField(
          name: key,
          content: '$value'
        );

      });

      context.respond(MessageBuilder.embed(embed));
    }),
    checks: [check]);
