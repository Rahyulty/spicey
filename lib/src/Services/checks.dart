import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:spicey/src/util.dart';

final administratorCheck = UserCheck.anyId(BulkSnowflakes().action(canChange));
var check = GuildCheck.id(Snowflake(798666698873503814));