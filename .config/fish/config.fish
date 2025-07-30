if status is-interactive
    starship init fish | source
    # Add aliases here if needed
    alias ls="lsd"
    alias lt="lsd --tree"
end
