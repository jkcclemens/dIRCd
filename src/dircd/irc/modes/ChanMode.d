module dircd.irc.modes.ChanMode;

public enum ChanMode : string {
    ChannelCreator      = "O",
    ChannelOperator     = "o",
    Voice               = "v",
    Anonymous           = "a",
    InviteOnly          = "i",
    Moderated           = "m",
    NoOutsideMessages   = "n",
    Quiet               = "q",
    Private             = "p",
    Secret              = "s",
//    Reop                = "r", Not going to support this as of now
    TopicOpOnly         = "t",
    Key                 = "k",
    LimitUsers          = "l",
    Ban                 = "b",
    BanException        = "e", // ban exception mask
    InviteException     = "I"
}
