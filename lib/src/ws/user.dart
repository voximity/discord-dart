import "../internals.dart";
import "../client.dart";
import "guild.dart";
import "channel.dart";
import "message.dart";

class User extends DiscordObject {
  /// Username of the user.
  String username;

  /// Discriminator of the user.
  String discriminator;

  int id;

  User(this.username, this.discriminator, this.id);

  static User fromDynamic(dynamic obj, DiscordClient client) =>
    new User(obj["username"], obj["discriminator"], obj["id"])..client = client;
}

class Member extends DiscordObject {
  /// The guild that this Member is in.
  Guild guild;

  /// The user representing this member.
  User user;

  /// The nickname of the member.
  String nickname;

  /// A list of Role objects that the user possesses in the guild.
  List<Role> roles;

  /// Whether or not the user is deafened by the guild.
  bool deafened;

  /// Whether or not the user is muted by the guild.
  bool muted;

  Member(this.user, this.guild, {this.nickname, this.roles, this.deafened, this.muted});

  static Member fromDynamic(dynamic obj, DiscordClient client, Guild guild) {
    List<Role> roleList = [];
    for (int i = 0; i < obj["roles"].length; i++) {
      int roleId = obj["roles"][i];
      Role role = guild.roles.firstWhere((r) => r.id == roleId);
      roleList.add(role);
    }
    return new Member(User.fromDynamic(obj["user"], client), guild,
      roles: roleList,
      nickname: obj["nick"],
      deafened: obj["deaf"],
      muted: obj["mute"])..client = client;
  }
}