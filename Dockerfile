FROM dart:2.19.6 AS build

WORKDIR /app
COPY pubspec.* /app/
RUN dart pub get

COPY . /app
RUN dart pub get --offline

RUN dart run nyxx_commands:compile bin/spicey.dart -o bot.dart

CMD [ "./bot.exe" ]