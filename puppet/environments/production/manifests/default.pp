node default {
  include ubuntu

  class { 'custom_user':
    username => 'dlp',
    dotfiles_source => 'https://github.com/aperiodic/dotfiles',
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC8F/GflPY+uSSMjyBK0AizlDpcII9GLh4usOVavMnJ3tuJ1DBOqevReuklqlc2oEsZ/iCH8lJYcHHobWDE+TMRU6g2h8Wi/ishleR40kH7mUiGZtRQarB0zAgKGc9bDAyOshj7gUjaEKCoYmaqqsVCWkNpy/Ea6jKyv8i1AnHd0PXRat2CtWZyakictEpS4w2OZKWN//25UZL9P1rEVJhWP8JMkKJTrpSOSPlOouOArmhfXvCHpttFGmBS+vw/Qhn6l/JlGc4BUpnM0Ja6AiVDBtrOyW+UOdcNF2nsOhMkWSWwcH/LD45B0IIuGnkRhA+FFTulc5HZuajIqE4RHyj5',
  }
}
