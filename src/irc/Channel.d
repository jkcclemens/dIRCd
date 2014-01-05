module org.royaldev.dircd.irc.Channel;

import std.algorithm: countUntil, remove;
import org.royaldev.dircd.irc.User;

public class Channel {

    private string name; // name of chan
    private User[] users; // users in chan
    private string topic; // topic
    private User topicUser; // person who set topic

    public this(string name) {
        this.name = name;
    }

    public string getName() {
        return this.name;
    }

    public User[] getUsers() {
        return this.users;
    }

    public string getTopic() {
        return this.topic;
    }

    public User getTopicUser() {
        return this.topicUser;
    }

    public void setTopic(string topic, User setting) {
        this.topic = topic;
        this.topicUser = setting;
    }

    public void sendMessage(User who, string message) {
        sendLineAllExcept(who, ":" ~ who.getHostmask() ~ " PRIVMSG " ~ this.getName() ~ " :" ~ message);
    }

    public void sendLineAll(string line) {
        foreach (User u; users) u.sendLine(line);
    }

    public void sendLineAllExcept(User except, string line) {
        foreach (User u; users) {
            if (u.getNick() == except.getNick()) continue;
            u.sendLine(line);
        }
    }

    public void addUser(User u) {
        this.users ~= u;
        sendLineAll(":" ~ u.getHostmask() ~ " JOIN " ~ getName());
    }

    public void partUser(User u, string message) {
        sendLineAll(":" ~ u.getHostmask ~ " PART " ~ getName() ~ " :" ~ message);
        removeUser(u);
    }

    public void quitUser(User u, string message) {
        sendLineAll(":" ~ u.getHostmask() ~ " QUIT :" ~ message);
        removeUser(u);
    }

    public void removeUser(User u) {
        int index = -1;
        for (int i = 0; i < users.length; i++) {
            if (users[i].getNick() != u.getNick()) continue;
            index = i;
            break;
        }
        if (index == -1) return;
        users = users.remove(index);
    }

}
