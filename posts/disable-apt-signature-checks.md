Categories: debian
Tags: apt

    # cat /etc/apt/apt.conf.d/allowunauthenticated
    APT::Get::AllowUnauthenticated 1;
    Aptitude::CmdLine::Ignore-Trust-Violations true;

