import 'dart:async';
import 'dart:convert';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx/nyxx.dart';
import 'package:spicey/src/util.dart';
import '../Services/checks.dart';

final detabase = deta.base('ragenki-ps');

ChatCommand addCode = ChatCommand(
    'add-code',
    'Add a specific games private server code',
    id('add', (
      IChatContext context,
      @Description("The name of the game") String gameName,
      @Description("the code") String code,
    ) async {
      var member = context.guild?.members[context.user.id];
      // Fetch the member if it was not cached
      member ??= await context.guild?.fetchMember(context.user.id);

      if (valueExistsInList(member?.id.toString(), canChange) == true) {
        var rawcodes = await detabase.get('codes');
        var codes = jsonDecode(rawcodes['codes']) as Map<String, dynamic>;

        addKeyValuePair(codes, gameName, code);

        detabase.update(key: 'codes', item: <String, dynamic>{'codes': json.encode(codes)});

        EmbedBuilder embed = EmbedBuilder()
          ..color = getRandomColor()
          ..addField(
              name: 'Sucess!',
              content:
                  "Sucessfully added $gameName with the code `$code` to the private server list!",
              inline: true);
        context.respond(MessageBuilder.embed(embed));
      }
    }),
    checks: [check]);