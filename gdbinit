set history save on
set history filename ~/.gdb_history

python
import sys, os.path
sys.path.insert(0, os.path.expanduser('~/.gdb'))
from qt import register_qt_printers
register_qt_printers (None)
end
