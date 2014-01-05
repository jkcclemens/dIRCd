module dircd.irc.modes.UserMode;

public enum UserMode : string {
    Away                    = "a",
    Invisible               = "i",
    ReceiveWallops          = "w",
    RestrictedConnection    = "r",
    Operator                = "o",
    LocalOperator           = "O",
    ServerNoticeReceipt     = "s"
}
