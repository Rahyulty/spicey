import 'dart:async';
import 'dart:convert';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx/nyxx.dart';
import 'package:spicey/src/util.dart';

final detabase = deta.base('ragenki-birthdays');

ChatCommand addBirthday = ChatCommand(
    'add-birthday',
    'Add a birthday to the bots memory (ex. 1999-12-31)',
    id('add-birthday', (
      IChatContext context,
      @Description("Enter Birthday Here (ex. 1999-12-31)") String bday,
      @Description("Enter the user this birthday is for") IUser target,
    ) async {
      // get the data from our database
      // the way this is formated is in such
      // ServerID
      //   userid
      //     birthday

      var birthdays = await detabase.get('bdays');
      birthdays = jsonDecode(birthdays['data']) as Map<String, dynamic>;

      if (isValidDateFormat(bday) == false) {
        // create error embed will make a regular function for this later so i dont keep rewriting
        final embed = errorMessage('Invalid Format! Make sure your inputing (YYYY-DD-MM) if your birthday is December 31 1999 then you would input 1999-31-12');
        
        context.respond(MessageBuilder.embed(embed));
      } else if (isValidDateFormat(bday) == true) {
        // we have good format we dont proceed with data logic

        if (birthdays.containsKey(context.guild?.id.toString()) == true) {
          if (birthdays[context.guild!.id.toString()].containsKey(target.id.toString()) == false) {
            
            birthdays[context.guild!.id.toString()][target.id.toString()] = bday;
            
           if (birthdays['textChannel'] == null){
              print("ADJUSTED TEXT CHANNEL");
              birthdays['textChannel'] = context.channel.id.toString();
            } 

            detabase.update(key: 'bdays', item: <String, dynamic>{'data': json.encode(birthdays)});

            final embed = sucessMessage("Sucessfully added to database! cant wait for your birthday!");

            context.respond(MessageBuilder.embed(embed));
          } else if (birthdays[context.guild!.id.toString()].containsKey(target.id.toString()) == true) {
            
            if (birthdays['textChannel'] == null){
              print("ADJUSTED TEXT CHANNEL");
              birthdays['textChannel'] = context.channel.id.toString();
            } 

            detabase.update(key: 'bdays', item: <String, dynamic>{'data': json.encode(birthdays)});

            final embed = errorMessage('Seems like you have already entered data for this users birthday! (if this is a error or you made a mistake in the future you will be able to remove birthdays)');

            context.respond(MessageBuilder.embed(embed));


          }
        } else if (birthdays.containsKey(context.guild?.id.toString()) == false) {
          // create the guild ID
          birthdays[context.guild?.id.toString() ?? ''] = {"textChannel" : context.channel.id.toString()};
          birthdays[context.guild!.id.toString()][target.id.toString()] = bday;
          detabase.update(key: 'bdays', item: <String, dynamic>{'data': json.encode(birthdays)});

          final embed = sucessMessage("Sucessfully added your server to our database. Cant wait to start celebrating birthdays");
          context.respond(MessageBuilder.embed(embed));
        }
      }
    }));