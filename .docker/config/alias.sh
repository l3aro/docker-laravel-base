alias pa="php artisan"
alias lg="lazygit"
alias ll="ls -la"
alias ..="cd .."

tx() {
    local session_name="$1"

    # Check if the session exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        # Attach to the existing session
        tmux attach -t "$session_name"
    else
        # Create a new session
        tmux new-session -s "$session_name"
    fi
}

export PATH=./vendor/bin:$PATH
