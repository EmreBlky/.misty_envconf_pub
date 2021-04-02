#########################################################################
#
# Global smart proxy configurations
# By default it proxies everything
#
#


alias proxychains='proxychains4 '
alias p='ALL_PROXY= all_proxy= proxychains4 '
alias pq='ALL_PROXY= all_proxy= proxychains4 -q'
alias pin='ALL_PROXY= all_proxy= proxychains4 -f /etc/proxychains4_internal.conf '
alias pdbg='ALL_PROXY= all_proxy= proxychains4 -f /etc/proxychain4_debug.conf '
alias apt='pq apt '
alias sshp='pq ssh '
compdef sshp=ssh

setopt complete_aliases
compdef _precommand p
compdef _precommand pq
compdef _precommand pin
compdef _precommand pdbg
compdef _precommand proxychains
compdef _precommand proxychains4

alias gitssh=ssh

export PROXY_STR=""
proxy () {
  if [[ ! "$PROXY_STR" = "" ]]; then
    export ALL_PROXY="$PROXY_STR"
  else
    orihost="parent-host"
    host=$(getent ahosts $orihost | head -n 1 | awk '{ print $1 }' | head -n 1)
    if [[ "$host" = "" ]]; then
      host = $orihost
    fi
    export ALL_PROXY="http://$host:7890"
  fi
  export all_proxy=$ALL_PROXY
  export HTTP_PROXY=$ALL_PROXY
  export HTTPS_PROXY=$ALL_PROXY
  export http_proxy=$ALL_PROXY
  export https_proxy=$ALL_PROXY
  alias gitssh=sshp
  
  update_gitsshfun
  #curl https://ip.gs &
}

unproxy () {
  unset ALL_PROXY
  unset all_proxy
  unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy
  alias gitssh=ssh
  curl https://ip.gs &
  update_gitsshfun
}

update_gitsshfun() {
    eval 'gitsshfun() { gitssh "$@" }'

    export GITSSHFUNC=$(which gitsshfun)
}

proxy