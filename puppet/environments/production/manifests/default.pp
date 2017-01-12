node default {
  include ubuntu

  custom_user { 'dlp':
    dotfiles_source => 'https://github.com/aperiodic/dotfiles',
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC8F/GflPY+uSSMjyBK0AizlDpcII9GLh4usOVavMnJ3tuJ1DBOqevReuklqlc2oEsZ/iCH8lJYcHHobWDE+TMRU6g2h8Wi/ishleR40kH7mUiGZtRQarB0zAgKGc9bDAyOshj7gUjaEKCoYmaqqsVCWkNpy/Ea6jKyv8i1AnHd0PXRat2CtWZyakictEpS4w2OZKWN//25UZL9P1rEVJhWP8JMkKJTrpSOSPlOouOArmhfXvCHpttFGmBS+vw/Qhn6l/JlGc4BUpnM0Ja6AiVDBtrOyW+UOdcNF2nsOhMkWSWwcH/LD45B0IIuGnkRhA+FFTulc5HZuajIqE4RHyj5',
  }

  custom_user { 'joel':
    ssh_key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEArKzPEM79bH1Tr2deG6ypbhHP91RkABtYW5Iea6G+8GCL7ZpdSuDI0CwZuzNa/LVZGITI2y0xmf8meuFWkKZAG7LSMtygIrCL7as1Gy/wDfzK2xbBYQHRwI/Lsfutl2l3wYnGGiI7gLFpvTl27q7ro2cvIPiVVvPGts7HGjrWRaCCG6AUH+iNEs9B4wPY9W9vn+sn4IUh4W/is4f5i5oJxhoN+cZSSaAENXAFJYMx9v/HzSPXQWmfyzAxoBFQ60+jUE9up8FcOrmwLRGuzGkGO4Sr3JKkCGw1w3xM4/JweIwal22mylMV1zwiTm+CAq+S0q4bRBhLrElmxXdlfpf+yQ==',
  }
}
