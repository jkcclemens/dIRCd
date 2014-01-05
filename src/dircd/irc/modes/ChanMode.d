module dircd.irc.modes.ChanMode;

public enum ChanMode : string {
//    ChannelCreator      = "O", Not going to support this
    ChannelOperator     = "o", // takes param
    Voice               = "v", // takes param
    Anonymous           = "a",
    InviteOnly          = "i",
    Moderated           = "m",
    NoOutsideMessages   = "n",
    Quiet               = "q",
    Private             = "p",
    Secret              = "s",
//    Reop                = "r", Not going to support this as of now
    TopicOpOnly         = "t",
    Key                 = "k", // takes param
    LimitUsers          = "l", // takes param
    Ban                 = "b", // takes param
    BanException        = "e", // takes param, ban exception mask
    InviteException     = "I" // takes param
}
