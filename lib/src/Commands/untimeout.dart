import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:spicey/src/util.dart';


ChatCommand untimeout = ChatCommand(
    'untimeout',
    'Untimeout a user who has been timed out',
    id('untimeout', (
      IChatContext context,
      @Description('the user we are removing the timeout for')IMember target
      ) async {
      MemberBuilder untimeout = MemberBuilder()
      ..timeoutUntil = DateTime.now();
      
      if (target.isTimedOut == true) {
        target.edit(builder: untimeout);

        final embed = sucessMessage("${target.mention} is no longer timed out!");

        context.respond(MessageBuilder.embed(embed));
      } else if (target.isTimedOut == false) {
        final embed = errorMessage("${target.mention} is not timed out");
        
        context.respond(MessageBuilder.embed(embed));
      }
    }));