# bash completion for openstack keystone

_keystone_opts="" # lazy init
_keystone_flags="" # lazy init
_keystone_opts_exp="" # lazy init
_keystone()
{
    local cur prev kbc
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [ "x$_keystone_opts" == "x" ] ; then
        kbc="`keystone bash-completion | sed -e "s/ -h / /"`"
        _keystone_opts="`echo "$kbc" | sed -e "s/--[a-z0-9_-]*//g" -e "s/[ ][ ]*/ /g"`"
        _keystone_flags="`echo " $kbc" | sed -e "s/ [^-][^-][a-z0-9_-]*//g" -e "s/[ ][ ]*/ /g"`"
        _keystone_opts_exp="`echo $_keystone_opts | sed -e "s/[ ]/|/g"`"
    fi

    if [[ " ${COMP_WORDS[@]} " =~ " "($_keystone_opts_exp)" " && "$prev" != "help" ]] ; then
        COMPREPLY=($(compgen -W "${_keystone_flags}" -- ${cur}))
    else
        COMPREPLY=($(compgen -W "${_keystone_opts}" -- ${cur}))
    fi
    return 0
}
complete -F _keystone keystone

