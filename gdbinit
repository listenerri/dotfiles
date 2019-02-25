# pretty print qt type value
# "Lekensteyn/qt5printers" github project needed be cloned into "~/.config/gdb/"
python
import sys, os.path
sys.path.insert(0, os.path.expanduser('~/.config/gdb'))
import qt5printers
qt5printers.register_printers(gdb.current_objfile())
end
