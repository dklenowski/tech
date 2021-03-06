Categories: networking
Tags: voip
      jitter
      delay

## Voice Over IP (VoIP) Terms

### Delay

- Voice is more tolerant to packet loss (provided loss < 5% of total).
- Voice is extremely intolerant of delay.
- Round Trip Time (RTT)
  - Most important.
  - e.g. A talking to B, B decides to interrupt.
  - Because there is a delay, what B is hearing is already old.
  - ITU-T Recommendation G.114 states that the round trip delay should be 300 ms or less for telephony.

### Jitter

- aka delay variation (Variation in the amount of delay in a given conversation).
- Hard to adjust to a delay that is varying.
- Jitter causes in IP networks
  - Packets take different routes from sender to receiver (therefore experience different delays).
  - A given packet in a voice conversation can experience longer queueing times than the previous packet.
  - e.g. when the queues that voice packets use are used by other traffic.

### Packet loss

- Speech must be received in same order as transmitted.
- Traditional retransmission techniques take to long for real time applications. Therefore if packet missing, end system must carry on without the packet.

### Speech coding techniques

- In general, coding techniques are such that speech quality degrades as bandwidth reduces (although this is not linear).

### Toll Quality Voice

- Goal of speech coding technique.
- Toll quality relates to a Mean Opinion Score (MOS) of >= 4 as specified in the scale (ITU-T Recommendation P.800)

        5       Excellent
        4       Good
        3       Fair
        2       Poor
        1       Bad

- Ratings summation of various quality parameters (delay, jitter, echo, noise, cross talk etc)
- MOS std is the most common std for voice measurement.

        Speech Coder        Bit Rate (kbps)     MOS
        G.711               64                  4.3
        G.726               32                  4.0
        G.723 (CELP)        6.3                 3.8
        G.728               16                  3.9