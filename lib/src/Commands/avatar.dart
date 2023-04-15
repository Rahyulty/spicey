import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:spicey/src/util.dart';

ChatCommand avatar = ChatCommand(
  'avatar',
  "Get a user's avatar",
  id('avatar', (
    IChatContext context, [
    @Description('The user to fetch the avatar for') IUser? target,
    @Description("Whether to show the user's guild profile, if they have one")
        bool showGuildProfile = true,
  ]) async {
    // Default to the user who invoked the command
    final color = getRandomColor();
    target ??= context.user;
    final id = target.id.toString();

    String? avatarUrl;

    var member = context.guild?.members[target.id];
    // Fetch the member if it was not cached
    member ??= await context.guild?.fetchMember(target.id);

    // Try to fetch the guild profile
    if (showGuildProfile) {
      try {
        avatarUrl = member?.avatarUrl();
      } on IHttpResponseError catch (e) {
        if (e.statusCode != 404) {
          rethrow;
        }
        // Ignore: member was not found
      }
    }

    // Default to the user avatar
    avatarUrl ??= target.avatarUrl(size: 512);

    EmbedBuilder embed = EmbedBuilder()
      ..color = color
      ..imageUrl = avatarUrl
      ..title = "<@$id> avatar";

    await context.respond(MessageBuilder.embed(embed));
  }),
);
