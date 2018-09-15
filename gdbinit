# pretty print qt type value
# "Lekensteyn/qt5printers" github project is needed cloned into "~/.gdb/"
python
import sys, os.path
sys.path.insert(0, os.path.expanduser('~/.gdb'))
import qt5printers
qt5printers.register_printers(gdb.current_objfile())
end
