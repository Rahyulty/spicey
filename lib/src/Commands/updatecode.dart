import 'dart:async';
import 'dart:convert';
import 'package:dio_client_deta_api/dio_client_deta_api.dart';
import 'package:dio/dio.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:deta/deta.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx/nyxx.dart';
import 'package:spicey/src/util.dart';
import '../Services/checks.dart';

final detabase = deta.base('ragenki-ps');

// void main(List<String> args) async {
//   final data = await detabase.get('codes');
//   print(jsonDecode(data['codes']));
// }

Future<Iterable<ArgChoiceBuilder>> autocompleteCode(
    AutocompleteContext _) async {
  var rawcodes = await detabase.get('codes');
  var codes = jsonDecode(rawcodes['codes']) as Map<String, dynamic>;
  return codes.entries.map((entry) {
    return ArgChoiceBuilder(entry.key, entry.key);
  });
}

ChatCommand updatecode = ChatCommand(
    'update-code',
    'Update a specific games private server code',
    id('update-code', (
      IChatContext context,
      @Autocomplete(autocompleteCode) String key,
      @Description('updated code') String newCode,
    ) async {
      var member = context.guild?.members[context.user.id];
      // Fetch the member if it was not cached
      member ??= await context.guild?.fetchMember(context.user.id);

      if (valueExistsInList(member?.id.toString(), canChange) == true) {
        var rawcodes = await detabase.get('codes');
        var codes = jsonDecode(rawcodes['codes']) as Map<String, dynamic>;

        detabase.update(key: 'codes', item: <String, dynamic>{'codes': json.encode(codes)});

        EmbedBuilder embed = EmbedBuilder()
          ..color = getRandomColor()
          ..addField(
              name: 'sucess',
              content: "Sucessfully changed $key to $newCode",
              inline: true);
        context.respond(MessageBuilder.embed(embed));

      } else if (valueExistsInList(member?.id, canChange) == false) {
        EmbedBuilder embed = EmbedBuilder()
          ..color = getRandomColor()
          ..addField(
              name: 'Woah!',
              content: "you not gangsta enough to change private server codes",
              inline: true);

        context.respond(MessageBuilder.embed(embed));
      }
    }),
    checks: [check]);