+++
title = 'Launch a shell command in an ephemeral tmux pane'
date = 2025-04-19T16:07:22-04:00
draft = false
+++

I often want to quickly run a command in a new tmux pane without losing my current shell context.
I essentially want the Control + Click "Open in New Tab" from the browser in tmux.

We can achieve this by creating a zsh line editor widget which reads the current buffer and runs a tmux command.

Here is a minimal example bound to `Ctrl-\`:
```sh
# Widget to run current command in new tmux pane
tmux_split_with_current_command() {
  # Execute tmux split-window with the current command
  (tmux split-window -h "$BUFFER" &)
}

# Create the widget from the function
zle -N tmux_split_with_current_command

# Bind Ctrl-\ to the widget
bindkey '^\' tmux_split_with_current_command
```

It uses a subshell and runs the command in the background to minimize the affect on the current shell and return control to the current shell as soon as possible.

This has a few problems. For one, if we try to run this widget while not in tmux,
we get an unexpected behavior where we open the new pane in another existing tmux session.

Here is a more defensive version of the widget which protects against this case and the case where the buffer is emmpty:

The updated version also clears the editing buffer and resets the cursor position to remove the command that was executed in the new tmux pane.

```sh
# Widget to run current command in new tmux pane
tmux_split_with_current_command() {
  # First check if we're in a tmux session
  if [[ -z "$TMUX" ]]; then
    zle -M "Not in a tmux session"
    return 1
  fi

  # Get the current command line content
  local cmd="$BUFFER"
  
  # Only proceed if there's actually a command
  if [[ -n "$cmd" ]]; then
    # Execute tmux split-window with the current command
    # Using zsh's silent command execution with the () syntax
    (tmux split-window -h "$cmd" &)
    
    # Clear the editing buffer
    BUFFER=""; CURSOR=0; zle redisplay
  fi
}

# Create the widget from the function
zle -N tmux_split_with_current_command

# Bind Ctrl-\ to the widget
bindkey '^\' tmux_split_with_current_command
```
