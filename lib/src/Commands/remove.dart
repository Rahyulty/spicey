import 'dart:async';
import 'dart:convert';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx/nyxx.dart';
import 'package:spicey/src/util.dart';
import 'getcode.dart';

final detabase = deta.base('ragenki-ps');


// void main(List<String> args) async {
//   final data = await detabase.get('codes');
//   print(jsonDecode(data['codes']));
// }

Future<Iterable<ArgChoiceBuilder>> autocompletCode(AutocompleteContext _) async {
  var rawcodes = await detabase.get('codes');
  var codes = jsonDecode(rawcodes['codes']) as Map<String, dynamic>;
  return codes.entries.map((entry) {
    return ArgChoiceBuilder(entry.key, entry.key);
  });
}


ChatCommand removecode = ChatCommand(
    'remove-code',
    'remove a specific games private server code',
    id('remove-code', (
      IChatContext context,
      @Autocomplete(autocompletCode) String key,
    ) async {
      var member = context.guild?.members[context.user.id];
      // Fetch the member if it was not cached
      member ??= await context.guild?.fetchMember(context.user.id);

      if (valueExistsInList(member?.id.toString(), canChange) == true) {
        var rawcodes = await detabase.get('codes');
        var codes = jsonDecode(rawcodes['codes']) as Map<String, dynamic>;
        removeKeyValue(codes, key);

        detabase.update(key: 'codes', item: <String, dynamic>{'codes': json.encode(codes)});

        EmbedBuilder embed = EmbedBuilder()
          ..color = getRandomColor()
          ..addField(
              name: 'Sucess!', content: "Sucessfully removed $key from server list", inline: true);

        context.respond(MessageBuilder.embed(embed));
      }
    }),
    checks: [check]);