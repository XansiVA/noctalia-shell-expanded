#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias noctashot='grim -t ppm -g "$(slurp)" - | satty -f - --initial-tool=arrow --copy-command=wl-copy --actions-on-escape=save-to-clipboard,exit --brush-smooth-history-size=5 --disable-notifications'
PS1='[\u@\h \W]\$ ' 

[ -n "$PS1" ] &&

export _JAVA_AWT_WM_NONREPARENTING=1

fastfetch

eval "$(oh-my-posh init bash)"


