#
# Put this file at ~/.gdbinit or ~/.config/gdb/gdbinit
#

echo >>>> Changing charset to UTF-8 <<<<\n
set charset UTF-8
set target-charset UTF-8
set target-wide-charset UTF-16
set print sevenbit-strings off
echo >>>> Changing charset to UTF-8 done <<<<\n

python
import sys
import os
print(">>>> Loading qt pretty printers <<<<")
sys.path.insert(0, os.path.expanduser('~/.config/gdb/printers'))
from qt import register_qt_printers
register_qt_printers(None)
print(">>>> Loading qt pretty printers done <<<<")
end

