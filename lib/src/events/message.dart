import 'dart:async';

import "../resources/guild.dart";
import "../resources/user.dart";
import "../resources/channel.dart";
import "../resources/message.dart";
import "../resources/emoji.dart";

import "../internals.dart";

class MessageCreateEvent {
  /// The channel the message was created in.
  Channel channel;
  /// The guild of the channel that the message was created in. This may be null as this may be a non-guild message.
  Guild guild;
  /// The user that created this message. May be null due to webhooks.
  User author;
  /// The message that was created.
  Message message;

  MessageCreateEvent(this.message, {this.author, this.guild, this.channel});

  static Future<Null> construct(Packet packet) async {
    final message = await Message.fromMap(packet.data, packet.client);
    final event = new MessageCreateEvent(message,
      author: message.author,
      channel: message.channel,
      guild: message.guild);
    packet.client.onMessage.add(event);
  }
}
class MessageDeleteEvent {
  /// The [TextChannel] this message was deleted in.
  TextChannel channel;
  /// A snowflake ID of the message that was deleted.
  int messageId;

  MessageDeleteEvent(this.channel, this.messageId);

  static Future<Null> construct(Packet packet) async {
    final event = new MessageDeleteEvent(
      await packet.client.getChannel(packet.data["channel_id"]),
      packet.data["id"]
    );
    packet.client.onMessageDelete.add(event);
  }
}