import os
import subprocess

from ranger.api.commands import Command
from ranger.ext import img_display

# ranger's kitty image preview refuses to run unless $TERM contains "kitty"
# (KittyImageDisplayer._late_init), but rex/ghostty/wezterm/konsole speak the
# same kitty graphics protocol with a different $TERM. Pretend to be kitty
# during the one-time handshake, then restore the real $TERM so child
# processes (nvim, ...) still see it. Skipped inside tmux/screen, where the
# kitty protocol does not pass through.
_KITTY_PROTOCOL_TERM_PROGRAMS = frozenset({'kitty', 'rex', 'ghostty', 'wezterm', 'konsole'})

_orig_kitty_late_init = getattr(img_display.KittyImageDisplayer, '_late_init', None)


def _kitty_late_init(self):
    term = os.environ.get('TERM', '')
    if (
        _orig_kitty_late_init is not None
        and 'kitty' not in term
        and not os.environ.get('TMUX')
        and 'tmux' not in term
        and 'screen' not in term
        and os.environ.get('TERM_PROGRAM', '').lower() in _KITTY_PROTOCOL_TERM_PROGRAMS
    ):
        os.environ['TERM'] = 'xterm-kitty'
        try:
            _orig_kitty_late_init(self)
        finally:
            os.environ['TERM'] = term
    else:
        _orig_kitty_late_init(self)


if _orig_kitty_late_init is not None:
    img_display.KittyImageDisplayer._late_init = _kitty_late_init


class fzf_select(Command):
    """:fzf_select

    Find a file with fzf and jump to it. With a count, search directories only.
    """

    def execute(self):
        if self.quantifier:
            find = (
                "find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune "
                "-o -type d -print 2>/dev/null"
            )
        else:
            find = (
                "find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune "
                "-o -print 2>/dev/null"
            )
        cmd = find + (
            " | sed 1d | cut -b3- | fzf --height 40% --reverse "
            "--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || head -200 {}'"
        )
        fzf = self.fm.execute_command(cmd, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        out, _ = fzf.communicate()
        if fzf.returncode != 0:
            return
        path = os.path.abspath(out.strip())
        if not path:
            return
        if os.path.isdir(path):
            self.fm.cd(path)
        else:
            self.fm.select_file(path)


class edit(Command):
    """:edit

    Open the current file in the editor (rifle's 'editor' label, i.e. nvim).
    """

    def execute(self):
        fobj = self.fm.thisfile
        if fobj is not None and not fobj.is_directory:
            self.fm.execute_file([fobj], label='editor')
