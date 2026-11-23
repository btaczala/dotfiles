import os
import subprocess

from ranger.api.commands import Command


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
