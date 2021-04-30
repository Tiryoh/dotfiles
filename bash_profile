# ENV SETTINGS
export BASH_PROFILE_LOADED=true

if [ -x ~/catkin_ws ]; then
    # function catkin_make(){(cd $HOME/catkin_ws && command catkin_make $@) && source $HOME/catkin_ws/devel/setup.bash;}
    export MYWLAN0IP=$(ifconfig wlan0 2>/dev/null | grep -o -E "([0-9]+\.){3}[0-9]+" | head -n1)
    export MYETH0IP=$(ifconfig eth0 2>/dev/null | grep -o -E "([0-9]+\.){3}[0-9]+" | head -n1)
    export ROS_IP=$(echo $MYETH0IP $MYWLAN0IP 127.0.0.1 | cut -d' ' -f1)
    export ROS_MASTER_URI=http://$ROS_IP:11311
fi

if [ -d ~/.anyenv ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
else
    if [ -d ~/.pyenv ]; then
        export PYENV_ROOT=$HOME/.pyenv
        export PATH=$PYENV_ROOT/bin:$PATH
        eval "$(pyenv init -)"
    fi

    if [ -d ~/.rbenv ]; then
        export PATH=$HOME/.rbenv/bin:$PATH
        eval "$(rbenv init -)"
    fi

    if [ -d ~/.nodebrew  ]; then
        export PATH=$HOME/.nodebrew/current/bin:$PATH
    fi
fi

if [ -d ~/.poetry  ]; then
    export PATH="$HOME/.poetry/bin:$PATH"
fi

if [ -x ~/usr/local/bin  ]; then
    export PATH=$HOME/usr/local/bin:$PATH
fi

if [ -x /usr/local/go  ]; then
    export PATH=/usr/local/go/bin:$PATH
    if [ -x ~/go/bin  ]; then
        export PATH=$HOME/go/bin:$PATH
    fi
fi

if [ -x ~/.local/bin  ]; then
    export PATH=$HOME/.local/bin:$PATH
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

