import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import '../Services/db.dart' as db;
import 'package:spicey/src/util.dart';

ChatCommand snipe = ChatCommand(
    'snipe',
    'get most recent deleted message',
    id('snipe', (IChatContext context) async {
      // final color = getRandomColor();
      final serverId = context.guild?.id.toString();
      final database = db.MyDatabase('./lib/src/Data');
      final data = await database.getTable(serverId!);
      if (data.isEmpty == false) {
        // EmbedBuilder embed = EmbedBuilder()
        // ..color = color
        // ..title = "Sniped Message";
        
        print(formatMap(data));
      }

      context.respond(MessageBuilder.content("Soon to come"));
    }));
