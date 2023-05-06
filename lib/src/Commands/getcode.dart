import 'dart:async';
import 'dart:convert';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx/nyxx.dart';
import 'package:spicey/src/util.dart';
import '../Services/checks.dart';

final detabase = deta.base('ragenki-ps');

var check = GuildCheck.id(Snowflake(798666698873503814));

Future<Iterable<ArgChoiceBuilder>> autocompletCode(AutocompleteContext _) async {
  var rawcodes = await detabase.get('codes');
  var codes = jsonDecode(rawcodes['codes']) as Map<String, dynamic>;
  return codes.entries.map((entry) {
    return ArgChoiceBuilder(entry.key, entry.key);
  });
}

ChatCommand getcode = ChatCommand(
    'get-code',
    'get a desired private server',
    id('server', (IChatContext context, @Autocomplete(autocompletCode) String game) async {
      var rawcodes = await detabase.get('codes');
      var codes = jsonDecode(rawcodes['codes']) as Map<String, dynamic>;

      EmbedBuilder embed = EmbedBuilder()
        ..color = getRandomColor()
        ..addField(name: "Requested code for the game $game", content: '```${codes[game]}```');

      context.respond(MessageBuilder.embed(embed));
    }),
    checks: [check]);