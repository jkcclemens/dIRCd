# dIRCd

An IRC daemon written in D.

RFCs
- [2810](http://tools.ietf.org/html/rfc2810): Internet Relay Chat: Architecture
- [2811](http://tools.ietf.org/html/rfc2811): Internet Relay Chat: Channel Management
- [2812](http://tools.ietf.org/html/rfc2812): Internet Relay Chat: Client Protocol
- [2813](http://tools.ietf.org/html/rfc2813): Internet Relay Chat: Server Protocol

## Differences from the [RFC](http://tools.ietf.org/html/rfc1459.html)
There are many deviations from the spec in the IRC RFC in this server. They are listed below.

- All commands that are not implemented, basically. A (mostly) complete list is below.
- Does not support multiple servers (RFC)
  - Does not support netsplit (RFC)
- Wildcards are, at this point, not implemented (RFC)
- No OPER support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.1.5))
- Partial MODE support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.2.3), partially planned)
  - No "r" mode support (reop) ([RFC](http://tools.ietf.org/html/rfc2811#section-4.2.7))
  - No KICK support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.2.8))
- No LIST support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.2.6), planned)
- No INVITE support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.2.7), planned)
- No VERSION support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.2.8))
- No STATS support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.3.2))
- No LINKS support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.3.3))
- No TIME support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.3.4))
- No CONNECT support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.3.5))
- No TRACE support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.3.6))
- No ADMIN support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.3.7))
- No INFO support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.3.8))
- No NOTICE support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.4.2), planned)
- No "User based queries" ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.5), planned)
- WHO works only on channels ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.5.1))
- No WHOIS query ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.5.2))
  - No WHOWAS query ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.5.3))
- None of the "Optionals" are included ([RFC](http://tools.ietf.org/html/rfc1459.html#section-5))
- No KILL support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.6.1))
- Pings are sent at a constant rate, regardless of recent activity. ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.6.2))
- No ERROR support ([RFC](http://tools.ietf.org/html/rfc1459.html#section-4.6.4))

## What works
That seems like a huge list of everything that doesn't work. Some of those are planned, but a lot of things are not
included in this server. However, many things still work.

- ISON (RFC)
- JOIN (RFC)
- MODE (RFC) - reading modes (chan & user), setting modes (chan only, currently)
- NAMES on channels (RFC)
- NICK (RFC)
- PART (RFC)
- PASS (RFC)
- PING (RFC) - only sending pings to clients works; receiving pings is not yet supported
- PONG (RFC)
- PRIVMSGs (RFC)
- QUIT (RFC)
- TOPIC (RFC)
- USER (RFC)
- WHO on channels only (RFC)

## Bugs
- (Possible) Ping timeouts may take longer than 120 seconds.

## Planned Features
- [CAP](http://ircv3.org/specification/capability-negotiation-3.1) support
- Full [IRCv3](http://ircv3.org/) support
