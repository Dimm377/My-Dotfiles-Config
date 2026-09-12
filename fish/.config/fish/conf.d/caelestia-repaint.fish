if status is-interactive
    function __caelestia_repaint --on-signal USR1
        commandline -f repaint 2>/dev/null
    end
end
