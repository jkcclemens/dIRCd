module dircd.irc.Channel;

import std.algorithm: countUntil, remove;
import dircd.irc.User;
import dircd.irc.modes.ChanMode;

public class Channel {

    private string name; // name of chan
    private User[] users; // users in chan
    private string topic; // topic
    private User topicUser; // person who set topic

    private ChanMode[] modes = [ChanMode.NoOutsideMessages, ChanMode.TopicOpOnly];

    public this(string name) {
        this.name = name;
    }

    public ChanMode[] getModes() {
        return this.modes;
    }

    public void setModes(ChanMode[] modes) {
        this.modes = modes;
    }

    public void sendModes() {
        foreach (User u; this.getUsers()) sendModes(u);
    }

    public void sendModes(User u) {
        string toSend = "+";
        foreach (ChanMode cm; this.getModes()) toSend ~= cm;
        u.sendHostLine("MODE " ~ this.getName() ~ " " ~ toSend);
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

    public void setTopic(User setting, string topic) {
        this.topic = topic;
        this.topicUser = setting;
        sendLineAll(":" ~ setting.getHostmask() ~ " TOPIC " ~ this.getName() ~ " :" ~ topic);
    }

    public void sendMessage(User who, string message) {
        sendLineAllExcept(who, ":" ~ who.getHostmask() ~ " PRIVMSG " ~ this.getName() ~ " :" ~ message);
    }

    public void sendLineAll(string line) {
        foreach (User u; users) u.sendLine(line);
    }

    public void sendHostLineAll(string line) {
        foreach (User u; users) u.sendHostLine(line);
    }

    public void sendLineAllExcept(User except, string line) {
        foreach (User u; users) {
            if (u.getNick() == except.getNick()) continue;
            u.sendLine(line);
        }
    }

    public void addUser(User u) {
        bool isOp = this.users.length < 1; // first user gets op
        this.users ~= u;
        sendLineAll(":" ~ u.getHostmask() ~ " JOIN " ~ getName());
        if (isOp) {
            auto modes = this.getModes();
            // do something
            this.setModes(modes);
        }
    }

    public void partUser(User u, string message) {
        sendLineAll(":" ~ u.getHostmask() ~ " PART " ~ getName() ~ " :" ~ message);
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
