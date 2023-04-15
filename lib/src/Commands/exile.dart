import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:spicey/src/util.dart';
import 'package:spicey/src/Services/checks.dart';

ChatCommand exile = ChatCommand(
  "exile",
  "Remove player from seeing important chats",
  checks: [
    administratorCheck,
  ],
  id('exile', (
    IChatContext context,
    @Description("The user we are exiling") IMember target,
  ) async {
    var rolesToRemove = target.roles.map((role) => SnowflakeEntity(role.id)).toList();

    print("BEFORE : ${target.roles.isEmpty}");
 
    await Future.wait(
      rolesToRemove.map((role) async {
        print("REMOVING ROLE $role");
        await target.removeRole(role);
      })
    );

    // Fetch the updated member object if context.guild is not null
    if (context.guild != null) {
      target = await context.guild!.fetchMember(target.id);
    }

    print("AFTER : ${target.roles.isEmpty}");

    if (target.roles.isEmpty) {
      context.respond(MessageBuilder.embed(sucessMessage("Successfully exiled ${target.mention}")));      
    }
  })
);