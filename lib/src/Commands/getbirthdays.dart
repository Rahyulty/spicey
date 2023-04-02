import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx/nyxx.dart';
import 'package:spicey/src/util.dart';
import 'getcode.dart';

final detabase = deta.base('ragenki-birthdays');

ChatCommand getBirthday = ChatCommand(
    'get-birthday',
    'Get all upcoming birthdays in your server',
    id('get-birthday', (
      IChatContext context,
    ) async {

      var birthdays = await detabase.get('bdays');
      birthdays = jsonDecode(birthdays['data']);
      
      var serverBirthdays = birthdays[context.guild?.id.toString()];


      EmbedBuilder embed = EmbedBuilder()
        ..color = getRandomColor()
        ..title = 'Birthdays'
        ..description = 'List of all birthdays in this server';
      
      for (final entry in serverBirthdays.entries) {
        if (entry.key != "textChannel") {
          final userId = entry.key;
          final birthdayString = entry.value as String;
          final age = calculateAges(birthdayString);

          final birthday = DateTime.parse(birthdayString);
          final now = DateTime.now();

          DateTime nextBirthday;

          // Check if birthday has already occurred this year
          if (now.month > birthday.month ||
              (now.month == birthday.month && now.day >= birthday.day)) {
            nextBirthday = DateTime(now.year + 1, birthday.month, birthday.day);
          } else {
            nextBirthday = DateTime(now.year, birthday.month, birthday.day);
          }

          final formattedBirthday = DateFormat('MMMM dd, yyyy').format(nextBirthday);

          embed.addField(
              name: formattedBirthday,
              content: "<@$userId> (${age.item1}) ➡️ (${age.item2})");
        }
      }

      context.respond(MessageBuilder.embed(embed));
    }));