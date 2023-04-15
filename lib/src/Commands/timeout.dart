
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:spicey/src/util.dart';
import 'package:spicey/src/Services/checks.dart';


ChatCommand timeout = ChatCommand(
    'timeout',
    "Time out the specified user",
    checks: [
      administratorCheck,
    ],
    id('timeout', (
      IChatContext context,
      @Description('the user who wer are timing out') IMember target,
      @Choices({
        '60 Seconds': 60,
        '5 Mins': 300,
        '10 Mins': 600,
        '1 Hour': 3600,
        '1 Day': 86400,
        '1 Week': 604800
      }) int time,
    ) async {
      DiscordColor color = getRandomColor();

      MemberBuilder timeout = MemberBuilder()
        ..timeoutUntil = DateTime.now().toUtc().add(Duration(seconds: time));

      await target
          .edit(builder: timeout)
          .onError((error, stackTrace) => print("ERROR : $error"));

      EmbedBuilder embed = EmbedBuilder()
        ..color = color
        ..addField(
            name: "Success",
            content:
                "Successfully timed out user ${target.mention} for $time seconds",
            inline: true)
        ..addAuthor((author) {
          author.name = context.user.username;
          author.iconUrl = context.user.avatarUrl();
        });

      context.respond(MessageBuilder.embed(embed));
    }));